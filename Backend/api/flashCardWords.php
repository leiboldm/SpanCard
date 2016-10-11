<?php
include "DatabaseHelper.php";
session_start();
$username = $_SESSION['username'];
$db = new DatabaseWrapper();
$response['success'] = false;
if ($_SERVER['REQUEST_METHOD'] == "GET") {
	$words = $db->exec_query("SELECT spanish_translations.word as word, spanish_translations.translation as trans" .
		" FROM user_words JOIN spanish_translations " .
		"ON user_words.username = spanish_translations.username " .
		"AND user_words.word = spanish_translations.word WHERE user_words.username = $1" .
		" ORDER BY user_words.successes ASC LIMIT 1000", array($username));

	$translationMap = array();
	foreach ($words as $word) {
		$w = $word->word;
		$t = $word->trans;
		if (array_key_exists($w, $translationMap)) {
			$translationMap[$w] .= (", " . $t);
		} else {
			$translationMap[$w] = $t;
		}
	}
	$translations = array();
	foreach ($translationMap as $key => $value) {
		$translation = array();
		$translation['fromWord'] = $key;
		$translation['toWord'] = $value;
		array_push($translations, $translation);
	}
	$response['flashCardWords'] = $translations;
	$response['success'] = true;
} else {
	$word = $_POST['word'];
	$username = $_SESSION['username'];
	$success = $_POST['correct'] == 'true';
    $res = '';
	if (success)
		$res = $db->exec_query("UPDATE user_words SET successes = successes + 1" .
            " WHERE word = $1 AND username = $2", 
            array($word, $username));
        
	else
        $res = $db->exec_query("UPDATE user_words SET failures = failures + 1" .
            " WHERE word = $1 AND username = $2", 
            array($word, $username));
    $response['success'] = $res == [];
}
echo json_encode($response);
?>
