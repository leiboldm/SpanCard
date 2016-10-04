import 'package:angular2/core.dart';

@Injectable()
class AppState {
  ApplicationRef _applicationRef;
  AppState(this._applicationRef);

  String username;

  bool _isLoggedIn;
  bool get isLoggedIn => _isLoggedIn;
  void set isLoggedIn(bool value) {
    _isLoggedIn = value;
    _applicationRef.tick();
  }
}
