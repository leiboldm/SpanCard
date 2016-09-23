<?php
include_once "LoginHelpers.php";
session_start();
session_unset();
session_destroy();
setcookie($userIdCookie, "", time() - 3600);
setcookie($userHashCookie, "", time() - 3600);
$response = array('success' => true);
echo json_encode($response);
?>
