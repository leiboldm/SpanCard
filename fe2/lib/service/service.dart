import 'dart:html';
import 'dart:async';
String backendRoot = 'http://mattleibold.com/SpanCard/Backend/api/';

Future<String> sendPostRequest(path, data) {
  return HttpRequest.postFormData(
    backendRoot + path, data, withCredentials: true).then(
      (HttpRequest response) {
        return response.responseText;
      }
    );
}

Future<String> sendGetRequest(path) {
  return HttpRequest.getString(backendRoot + path, withCredentials: true);
}

Future<String> getTranslationPage(String word) {
  String url = 'http://www.wordreference.com/es/en/translation.asp?spen=$word';
  return HttpRequest.getString(url);
}
