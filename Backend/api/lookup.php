<?php
ini_set("allow_url_fopen", "1");
ini_set("allow_url_include", "1");

function get_content($URL){
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_URL, $URL);
      $data = curl_exec($ch);
      curl_close($ch);
      return $data;
}

$searchWord = $_GET['word'];
$response = array();
$response['success'] = false;
$response['searchWord'] = $searchWord;

$url = 'http://www.wordreference.com/es/en/translation.asp?spen=' + $searchWord;

$translationPage = file_get_contents($url);

$response['rawPage'] = $translationPage;
$doc = new DOMDocument();
$doc->loadHTML($translationPage);
$response['parsed'] = $doc->saveHTML();

echo json_encode($response);
?>