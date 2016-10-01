<?php
include_once "LoginHelpers.php";
session_start();
session_unset();
session_destroy();
LoginHelpers::unsetLoginCookies();
$response = array('success' => true);
echo json_encode($response);
?>
