<?php
include_once "DatabaseHelper.php";
include_once "LoginHelpers.php";

session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	// validate login
	$username = $_POST['username'];
	$password = $_POST['password'];
	$db = new DatabaseWrapper();
	$user = $db->exec_query('SELECT * from users WHERE username = $1', Array($username));
	$login_result = array();
	$login_result["success"] = false;
	if (count($user) < 1) {
		$login_result["message"] = "That username doesn't exist";
	} else {
		$hash = $user[0]->passwordhash;
		$salt = $user[0]->salt;
		if (LoginHelpers::hashPassword($password, $salt) == $hash) {
			$_SESSION['username'] = $username;
			$login_result['success'] = true;
			$login_result['username'] = $username;
            LoginHelpers::setLoginCookies($username, $hash);
		} else {
			$login_result["message"] = "Incorrect password";
		}
	}
	echo json_encode($login_result);
} else {
	// get whether or not the user is logged in
	$response = array();
	if (LoginHelpers::isLoggedIn()) {
		$response['loggedIn'] = true;
		$response['username'] = $_SESSION['username'];
	} else {
		$response['loggedIn'] = false;
	}
	echo json_encode($response);
}

?>
