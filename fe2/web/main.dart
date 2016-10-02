import 'package:angular2/platform/browser.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:fe2/components/app_component/app_component.dart';

void main() {
  bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    const Provider(LocationStrategy, useClass: HashLocationStrategy),
    const Provider(APP_BASE_HREF, useValue: ''),
  ]);
}
