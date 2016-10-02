import 'package:angular2/core.dart';
import 'package:fe2/service/service.dart';
import 'package:angular2/router.dart';
import 'dart:convert';

@Component(
    selector: 'lookup',
    templateUrl: 'lookup.html')
class LookupComponent {
  String word;
  List translations;
  String toWord;
  Router _router;

  LookupComponent(this._router);

  lookupWord() {
    print('lookup word $word');
  }

  addToFlashCardSet() {
    print('add to flash card set');
  }

  startPractice() {
    print('start practice');
  }
}
