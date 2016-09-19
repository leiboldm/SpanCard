<?php
include "DatabaseHelper.php";
$db = new DatabaseWrapper();

session_start();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	// validate login
	$username = $_POST['username'];
	$password = $_POST['password'];
	$user = $db->exec_query('SELECT * from users WHERE username = $1', Array($username));
	$login_result = array();
	$login_result["success"] = false;
	if (count($user) < 1) {
		$login_result["message"] = "That username doesn't exist";
	} else {
		$hash = $user[0]->passwordhash;
		$salt = $user[0]->salt;
		if (hashPassword($password, $salt) == $hash) {
			$_SESSION['username'] = $username;
			$login_result['success'] = true;
			$login_result['username'] = $username;
		} else {
			$login_result["message"] = "Incorrect password";
		}
	}
	echo json_encode($login_result);
} else {
	// get whether or not the user is logged in
	$response = array();
	if (array_key_exists('username', $_SESSION)) {
		$response['loggedIn'] = true;
		$response['username'] = $_SESSION['username'];
	} else {
		$response['loggedIn'] = false;
	}
	echo json_encode($response);
}

?>