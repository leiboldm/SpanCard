<html>
<head>
	<title id="PageTitle">SpanCard!</title>
	<meta name="description" content="Learn Spanish now!">
	<script src="https://code.jquery.com/jquery-3.1.0.min.js" 
	integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=" 
	crossorigin="anonymous"></script>
	<script type="text/javascript" src="js/index.js"></script>
	<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>
	<header class="card-2">SpanCard</header>
	<div id="contentWrapper">
		<div id="loader">
			Loading ...
		</div>
		<div id="loginWrapper" style="display: none;">
			<span class="error" id="loginError"></span>
			<div id="loginBox">
				<form id="loginForm" onsubmit="return submitLogin();">
					<label for="username">Username </label><br>
					<input type="text" name="username" required><br>
					<label for="password">Password </label><br>
					<input type="password" name="password" required><br>
					<input type="submit" value="Login">
				</form>

				<span>You need an account to use SpanCard. Create one now, it only takes 15 seconds.</span><br>
				<button onclick="showCreateAccount();">Create account</button>
			</div>
			<div id="createAccountBox" style="display: none;">
				<form id="createAccountForm" onsubmit="return createAccount();">
					<label for="username">Pick a username </label><br>
					<input type="text" name="username" required><br>
					<label for="password">Pick a password </label><br>
					<input type="password" name="password" required><br>
					<label for="password2">Verify password </label><br>
					<input type="password" name="password2" required><br>
					<label for="email">Email (optional)</label><br>
					<input type="email" name="email"><br>
					<input type="submit" value="Create Account">
				</form>
				<span>Already have an account?</span><br>
				<button onclick="showLogin()">Login now</button>
			</div>
		</div>
		<div id="mainPageWrapper" style="display: none;">
			<div id="welcomeMessage">Welcome to SpanCard!</div>
			<div id="lookupHolder">
				<form id="lookupForm" onsubmit="return lookupWord();">
					<label for="word">Lookup spanish word</label><br>
					<input type="text" name="word" required><br>
					<input type="submit" value="Lookup">
				</form>
			</div>
			<div id="translationWrapper" style="display:none;">
				<span id="fromWord"></span>: <span id="toWord"></span><br>
				<button onclick="addToFlashcardSet()">Add to flashcard set</button>
				<span id="addWordError" class="error"></span>
				<span id="addWordSuccess" class="sucess"></span>
			</div>
			<button onclick="startPractice()">Practice with flashcards</button>
		</div>
		<div id="flashCardWrapper" style="display: none;">
			<span>Flashcard:</span><br>
			<span id="flashCardWord" class="fromWord"></span><br>
			<span id="flashCardTranslation" class="toWord"></span><br>
			<button id="showTranslationButton" onclick="showFlashCardTranslation()">Show translation</button>
			<div id="correctOrWrongButtons" style="display: none">
				<button id="correct" onclick="processResult(true);">I got it correct</button>
				<button id="wrong" onclick="processResult(false);">I got it wrong</button>
			</div>
			<br><button onclick="showMainPage()">Back to lookup</button>
		</div>
	</div>
	<footer id="footer">
		<div id="footerContent">
			<button onclick="logout()">logout</button>
		</div>
	</footer>
</body>
</html>