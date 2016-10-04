import 'package:angular2/core.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:fe2/utils/app_state.dart';
import 'package:fe2/service/service.dart';
import 'dart:convert';

@Component(
  selector: 'spancard-header',
  templateUrl: 'header.html',
  directives: const [NgIf]
)
class HeaderComponent {
  AppState _appState;
  final Router _router;
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool set loggedIn(bool value) {
    _loggedIn = value;
  }

  HeaderComponent(this._appState, this._router) {
    sendGetRequest('login.php').then((String data) {
      var resp = JSON.decode(data);
      _appState.isLoggedIn = resp['loggedIn'];
      loggedIn = resp['loggedIn'];
      if (resp['loggedIn'] == false) {
        _router.navigate(['Login']);
      }
    });
  }

  logout() {
    sendGetRequest('logout.php').then((String data) {
      _appState.isLoggedIn = false;
      _router.navigate(['Login']);
    });
  }
}
