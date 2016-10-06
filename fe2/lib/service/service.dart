import 'dart:async';
import 'dart:convert';
import 'dart:html';

String backendRoot = 'http://mattleibold.com/SpanCard/Backend/api/';

Future<String> sendPostRequest(String path, Map data) {
  return HttpRequest.request(backendRoot + path,
      withCredentials: true,
      method: 'POST',
      sendData: JSON.encode(data)
    ).then((HttpRequest response) {
      return response.responseText;
    }
  );

  /*
  return HttpRequest.postFormData(
    backendRoot + path, data, withCredentials: true).then(
      (HttpRequest response) {
        return response.responseText;
      }
    );*/
}

Future<String> sendGetRequest(path) {
  return HttpRequest.getString(backendRoot + path, withCredentials: true);
}

Future<String> getTranslationPage(String word) {
  String url = 'http://www.wordreference.com/es/en/translation.asp?spen=$word';
  return HttpRequest.getString(url);
}
