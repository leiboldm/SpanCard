<?php
include_once "DatabaseHelper.php";

class LoginHelpers {

    const userIdCookie = 'USER_ID';
    const userHashCookie = 'USER_HASH';

    public static function getCookie($cookieName) {
        if (isset($_COOKIE[$cookieName])) {
            return $_COOKIE[$cookieName];
        } else return null;
    }

    public static function isLoggedIn() {
        if (isset($_SESSION['username'])) return true;
        $username = self::getCookie(self::userIdCookie);
        $user_hash = self::getCookie(self::userHashCookie);
        if ($username != null) {
            $db = new DatabaseWrapper();
            $user = $db->exec_query("SELECT * FROM users WHERE username = $1", 
                array($username));
            if (count($user) != 1) return false;
            $user = $user[0];
            if (self::hashPassword($user->passwordhash, $username) ==
                    $user_hash) {
                $_SESSION['username'] = $username;
                self::setLoginCookies($username, $user->passwordhash);
                return true;
            }
        }
    }

    public static function setLoginCookies($username, $hash) {
        $cookieExpiration = time() + 86400 * 365;
        setcookie(self::userIdCookie, $username, $cookieExpiration, "/");
        setcookie(self::userHashCookie, self::hashPassword($hash, $username), $cookieExpiration, "/");
    }

    public static function unsetLoginCookies() {
        setcookie(self::userIdCookie, "", time() - 3600);
        setcookie(self::userHashCookie, "", time() - 3600);
    }

    public static function hashPassword($password, $salt) {
        return hash('sha256', $password . $salt);
    }
}

?>