function parseTranslationData(data) {
  var startIndex = data.indexOf("<body");
  var endIndex = data.lastIndexOf("</body>");
  var html = data.substring(startIndex, endIndex + 7);

  var parsedHTML = $.parseHTML(data);
  var translation = "No translation found";
  for (var i = 0; i < parsedHTML.length; i++) {
    if (parsedHTML[i].id == 'container') {
      return JSON.stringify(parseNodeV2(parsedHTML[i]));
    }
  }
  return JSON.stringify(null);
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
	return tranny_blocks;
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

function hasClass(node, className) {
	return array_includes(node.classList, className);
}

function array_includes(arr, val) {
	if (!arr) return false;
	if (arr.length <= 0) return false;
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val) return true;
	}
	return false;
}
