import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/utils/app_state.dart';
import 'dart:convert';
import 'dart:html';

@Component(
    selector: 'login',
    templateUrl: 'login.html')
class LoginComponent {
  String username;
  String password;
  String errorMessage = "";
  Router _router;
  AppState _appState;

  LoginComponent(this._router, this._appState);

  submitLogin() {
    Map<String, String> data = {"username": username, "password": password};
    sendPostRequest("login.php", data).then((String responseText) {
      Map responseData = JSON.decode(responseText);
      if (responseData['success']) {
        _appState.isLoggedIn = true;
        _appState.username = responseData['username'];
        _router.navigate(['Lookup']);
      } else {
        errorMessage = responseData['message'];
      }
    });
  }
}
