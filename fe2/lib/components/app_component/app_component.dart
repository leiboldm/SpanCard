import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:fe2/components/login/login_component.dart';
import 'package:fe2/components/create_user/create_user_component.dart';
import 'package:fe2/components/lookup/lookup_component.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/utils/app_state.dart';
import 'dart:html';
import 'dart:convert';
import 'package:fe2/components/min.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app.html',
    directives: const [ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Route(path: 'login', name: 'Login', component: LoginComponent),
  const Route(path: 'create_user', name: 'CreateUser', component: CreateUserComponent),
  const Route(path: 'lookup', name: 'Lookup', component: LookupComponent, useAsDefault: true)
])
class AppComponent {}
