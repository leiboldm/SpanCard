import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:fe2/components/header/header.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/utils/app_state.dart';
import 'dart:convert';
import 'dart:html';

@Component(
    selector: 'login',
    templateUrl: 'login.html',
    directives: const [HeaderComponent])
class LoginComponent {
  String username;
  String password;
  String loginErrorMessage = "";
  String createAccountErrorMessage = "";
  final Router _router;
  AppState _appState;
  String create_username;
  String create_password;
  String create_password2;
  String create_email;
  bool loginVisible = true;

  LoginComponent(this._router, this._appState);

  submitLogin() {
    Map<String, String> data = {"username": username, "password": password};
    print(data);
    sendPostRequest("login.php", data).then((String responseText) {
      Map responseData = JSON.decode(responseText);
      if (responseData['success']) {
        _loginSuccessCallback(responseData['username']);
      } else {
        loginErrorMessage = responseData['message'];
      }
    });
  }

  createAccount() {
    if (create_password != create_password2) {
      createAccountErrorMessage = 'Passwords are not the same';
      return;
    } else if (create_password.length < 4){
      createAccountErrorMessage = 'Password must be more than 3 characters';
      return;
    }
    Map<String, String> data = {
      "username": create_username,
      "password": create_password,
      "email": create_email ?? ''
    };
    print(data);
    sendPostRequest("createUser.php", data).then((String responseText) {
      Map responseData = JSON.decode(responseText);
      if (responseData['success']) {
        _loginSuccessCallback(responseData['username']);
      } else {
        createAccountErrorMessage = responseData["message"] ?? 'Error occurred';
      }
    });
  }

  _loginSuccessCallback(String username) {
    _appState.isLoggedIn = true;
    _appState.username = username;
    _router.navigate(['Lookup']);
  }

  showCreateAccount() {
    loginVisible = false;
  }

  showLogin() {
    loginVisible = true;
  }
}
