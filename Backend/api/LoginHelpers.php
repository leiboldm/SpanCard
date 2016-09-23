<?php
include_once "DatabaseHelper.php";

$userIdCookie = 'USER_ID';
$userHashCookie = 'USER_HASH';
function getCookie($cookieName) {
    if (isset($_COOKIE[$cookieName])) {
        return $_COOKIE[$cookieName];
    } else return null;
}

function isLoggedIn() {
    if (isset($_SESSION['username'])) return true;
    $username = getCookie($userIdCookie);
    $user_hash = getCookie($userHashCookie);
    if ($user_id != null) {
        $db = new DatabaseWrapper();
        $user = $db->exec_query("SELECT * FROM users WHERE username = $1", 
            array($username));
        if (count($user) != 1) return false;
        if (hashPassword($user['passwordhash'] . $username) ==
                $user_hash) {
            $_SESSION['username'] = $username;
            return true;
        }
    }
}

function setLoginCookies($username, $hash) {
    $cookieExpiration = 86400 * 365;
    setcookie($userIdCookie, $username, $cookieExpiration);
    setcookie($userHashCookie, hashPassword($hash . $username), 
                time() + $cookieExpiration);
}

?>