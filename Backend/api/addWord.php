<?php
include "DatabaseHelper.php";
session_start();
$db = new DatabaseWrapper();
$data = array();
$data['word'] = $_POST['fromWord'];
$data['username'] = $_SESSION['username'];
$res = $db->insert("user_words", $data);
if ($res) {
	$data['translation'] = $_POST['toWord'];
	$res = $db->insert("spanish_translations", $data);
}
$response = array();
$response['success'] = $res;
echo json_encode($response);
?>