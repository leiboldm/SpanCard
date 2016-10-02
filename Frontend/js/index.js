var apiRoot = "/SpanCard/Backend/api/";
var globalData = {};

$( document ).ready(function() {
	$.get(apiRoot + "login.php", function(data) {
		var response = JSON.parse(data);
		if (response['loggedIn'] == true) {
			globalData['username'] = response['username'];
			globalData['cardSet'] = new FlashCardSet();
			showMainPage();
		} else {
			showLoginWrapper();
		}
	})
});


function showCreateAccount() {
	$('#loginError').html("");
	$('#loginBox').hide();
	$('#createAccountBox').show();
}

function showLogin() {
	$('#loginError').html("");
	$('#createAccountBox').hide();
	$('#loginBox').show();
}

function showLoginWrapper() {
	hideAllContent();
	$('#loginWrapper').show();
}

function showMainPage() {
	hideAllContent();
	$('#mainPageWrapper').show();
	$('#welcomeMessage').html("Welcome, " + globalData['username']);
}

function submitLogin() {
	var data = $('#loginForm').serialize();
	$.post(apiRoot + "login.php", data, function(data) {
		var response = JSON.parse(data);
		console.log(response);
		if (response['success'] == false) {
			if ('message' in response) $('#loginError').html(response['message']);
			else $('#loginError').html("An error occurred logging into your account. Please try again later.");
		} else {
			globalData['username'] = response['username'];
			showMainPage();
		}
	});
	return false;
}

function createAccount() {
	var dataObj = $('#createAccountForm').serializeObject();
	if (dataObj['password'] != dataObj['password2']) {
		$('#loginError').html("Passwords don't match");
		return false;
	}
	var data = $('#createAccountForm').serialize();
	$.post(apiRoot + "createUser.php", data, function(data) {
		var response = JSON.parse(data);
		if (response['success'] == false) {
			if ('message' in response) $('#loginError').html(response['message']);
			else $('#loginError').html("An error occurred creating your account. Please try again later.");
		} else {
			globalData['username'] = response['username'];
			showMainPage();
		}
	});
	return false;
}

function array_includes(arr, val) {
	if (!arr) return false;
	if (arr.length <= 0) return false;
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val) return true;
	}
	return false;
}

function lookupWord() {
	$('#addWordSuccess').html("");
	$('#addWordError').html("");
	var data = $('#lookupForm').serializeObject();
	var word = data['word'];
	if (word.length < 1) {
		console.log("Empty word");
		return false;
	}
	$('#translationWrapper').hide();
	$.get("http://www.wordreference.com/es/en/translation.asp?spen=" + data['word'], function(data) {
		var startIndex = data.indexOf("<body");
		var endIndex = data.lastIndexOf("</body>");
		var html = data.substring(startIndex, endIndex + 7);

		var parsedHTML = $.parseHTML(data);
		var translation = "No translation found";
		for (var i = 0; i < parsedHTML.length; i++) {
			if (parsedHTML[i].id == 'container') {
				//translation = parseNode(parsedHTML[i]);
				var translation_blocks = parseNodeV2(parsedHTML[i]);
				if (translation_blocks.length > 0) {
					translation = "";
					translation_blocks[0].forEach(function(t) {
						translation += (t['translation'].replace('\n', ' ') + "<br><i>ex: " + t['example'] + "</i><br>");
					});
				}
				console.log(translation);
			}
		}
		$('#fromWord').html(word);
		$('#toWord').html(translation);
		$('#translationWrapper').show();
	});
	return false;
}

function addToFlashcardSet() {
	var data = {};
	data['fromWord'] = $('#fromWord').html();
	data['toWord'] = $('#toWord').html();
	$.post(apiRoot + "addWord.php", data, function(data) {
		var response = JSON.parse(data);
		if (response['success']) $('#addWordSuccess').html("Word added");
		else $('#addWordError').html("Failed to add word");
	});
}

function isTextNode(node) {
	return node.childNodes.length == 0;
}

function getTextContent(node) {
	var text = "";
	if (node == null) return null;
	node.childNodes.forEach(function(e) {
		if (isTextNode(e)) text += e.textContent;
	});
	return text;
}

function createOrPush(obj, key, value) {
	if (key in obj) {
		obj[key].push(value);
	} else {
		obj[key] = [value];
	}
}

function createOrAdd(obj, key, value) {
	if (key in obj) {
		obj[key] += value;
	} else {
		obj[key] = value;
	}
}

function parseNodeV2(node) {
	var tranny_blocks = []
	var trannies = [];
	var current_class = null;
	var current_tranny = {};
	var nodes = node.querySelectorAll('.WRD .even, .WRD .odd, .WRD .langHeader');
	for (var i = 0; i < nodes.length; i++) {
		var e = nodes[i];
		var evenOrOdd = e.classList[0];
		var blockSeparator = hasClass(e, 'langHeader');
		if (current_class == null && !blockSeparator) current_class = evenOrOdd;
		else if (current_class == null && blockSeparator) continue;
		else if (current_class != evenOrOdd || blockSeparator) {
			if (current_tranny['translation']) {
				current_tranny['translation'] = current_tranny['translation'].join(',\n');
				trannies.push(current_tranny);
			}
			current_tranny = {};
			if (blockSeparator) {
				tranny_blocks.push(trannies);
				trannies = [];
				current_class = null;
				continue;
			}
			current_class = evenOrOdd;
		}
		var fromWord = e.querySelector('.FrWrd strong');
		if (fromWord && !current_tranny['fromWord']) current_tranny['fromWord'] = getTextContent(fromWord);
		var translationElt = e.querySelector('.ToWrd');
		var exampleElt = e.querySelector('.FrEx');
		if (translationElt) {
			var translation = getTextContent(translationElt);
			var type = getTextContent(translationElt.querySelector('em span i'));
			createOrPush(current_tranny, 'translation', translation + "(" + type + ")");
		} else if (exampleElt) {
			current_tranny['example'] = getTextContent(exampleElt);
		}
	}
	if (current_tranny['translation']) {
		current_tranny['translation'] = current_tranny['translation'].join(',\n');
		trannies.push(current_tranny);
	}
	tranny_blocks.push(trannies);
	console.log(tranny_blocks);
	return tranny_blocks;
}

function hasClass(node, className) {
	return array_includes(node.classList, className);
}

function parseNode(node) {
	for (var i = 0; i < node.children.length; i++) {
		var child = node.children[i];
		if (array_includes(child.classList, "ToWrd")) {
			var endIndex = child.innerHTML.indexOf("<em");
			var translation = child.innerHTML;
			if (endIndex > 0) translation = child.innerHTML.substring(0, endIndex);
			if (translation.trim() !== "English") return translation;
		}
		var word = parseNode(child);
		if (word != null) return word;
	}
	return null;
}

function hideAllContent() {
	var children = $('#contentWrapper').children();
	for (var i = 0; i < children.length; i++) {
		$(children[i]).hide();
	}
}

function startPractice() {
	hideAllContent();
	$('#flashCardWrapper').show();
	showNextFlashCardWord();
}

function toggleFlashCardButtons() {
	$('#correctOrWrongButtons').toggle();
	$('#showTranslationButton').toggle();
}

function loadFlashCardWords(callback) {
	$.get(apiRoot + "flashCardWords.php", function(data) {
		var response = JSON.parse(data);
		if (response['success']) {
			globalData.cardSet.cards = response['flashCardWords'];
			globalData.cardSet.currentIndex = 0;
		}
		callback();
	});
}
function showNextFlashCardWord() {
	function populateData() {
		if (globalData.cardSet.currentIndex == globalData.cardSet.cards.length) {
			alert('youre out of words');
		} else {
			var translation = globalData.cardSet.getNextCard();
			$('#flashCardWord').html(translation['fromWord']);
			$('#flashCardTranslation').html(translation['toWord']);
		}
	}
	$('#flashCardTranslation').hide();
	if (globalData.cardSet.currentIndex == null) {
		console.log("hi");
		loadFlashCardWords(populateData);
	} else {
		populateData();
	}
}

function showFlashCardTranslation() {
	$('#flashCardTranslation').show();
	toggleFlashCardButtons();
}

function getCurrentFlashCardWord() {
	//return globalData['flashCardWords'][globalData['flashCardIndex']]['fromWord'];
	return globalData.cardSet.getCurrentCard();
}

function processResult(correct) {
	var data = {};
	data['correct'] = correct;
	data['word'] = globalData.cardSet.getCurrentCard().fromWord;
	console.log(data);
	$.post(apiRoot + "flashCardWords.php", data, function(response) {
		console.log(response);
	});
	toggleFlashCardButtons();
	showNextFlashCardWord();
}

function logout() {
	$.get(apiRoot + "logout.php", function(data) {
		var response = JSON.parse(data);
		if (response['success']) {
			globalData = {};
			showLoginWrapper();
		} else {
			console.log("Error logging out");
		}
	});
	return false;
}

jQuery.fn.serializeObject = function() {
  var arrayData, objectData;
  arrayData = this.serializeArray();
  objectData = {};

  $.each(arrayData, function() {
    var value;

    if (this.value != null) {
      value = this.value;
    } else {
      value = '';
    }

    if (objectData[this.name] != null) {
      if (!objectData[this.name].push) {
        objectData[this.name] = [objectData[this.name]];
      }

      objectData[this.name].push(value);
    } else {
      objectData[this.name] = value;
    }
  });

  return objectData;
};

function FlashCardSet() {
	this.cards = [];
	this.currentIndex = null;
	this.getCurrentCard = function()  {
		if (this.currentIndex != null) {
			return this.cards[this.currentIndex];
		} else return null;
	}

	this.getNextCard = function() {
		++this.currentIndex;
		if (this.currentIndex == this.cards.length) {
			return null;
		} else {
			return this.cards[this.currentIndex];
		}
	}
}