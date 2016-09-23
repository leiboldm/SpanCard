<?php
include_once "DatabaseHelper.php";
include_once "LoginHelpers.php";

$db = new DatabaseWrapper();
session_start();

function generateRandomString($length = 10) {
    return substr(str_shuffle(str_repeat($x='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ceil($length/strlen($x)) )),1,$length);
}

function getPost($key) {
	return $_POST[$key];
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	$responseObject = array();
	$responseObject['success'] = false;
	$username = getPost('username');
	$existingUser = $db->exec_query("SELECT * from users WHERE username = $1", array($username));
	if (count($existingUser) > 0) {
		$responseObject['message'] = "Username already taken";
		echo json_encode($responseObject);
	}

	$salt = generateRandomString(16);
	$data = array();
	$data['username'] = $username;
	$data['passwordhash'] = hashPassword(getPost('password'), $salt);
	$data['salt'] = $salt;
	$data['email'] = getPost('email');
	$res = $db->insert("users", $data);
	$responseObject['success'] = $res;
	$responseObject['username'] = $username;
	$_SESSION['username'] = $username;
    setLoginCookies($username, data['passwordhash']);

	echo json_encode($responseObject);
} else {
	echo "Try sending a post request";
}

?>
