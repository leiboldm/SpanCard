import 'package:angular2/core.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/components/header/header.dart';
import 'package:angular2/router.dart';
import 'dart:convert';

@Component(
    selector: 'lookup',
    templateUrl: 'lookup.html',
    directives: const [HeaderComponent])
class LookupComponent {
  String word = "";
  List translations;
  String toWord = "";
  final Router _router;
  String addWordErrorMessage = "";
  String addWordSuccessMessage = "";

  LookupComponent(this._router);

  lookupWord() {
    print('lookup word $word');
  }

  addToFlashcardSet() {
    print('add to flash card set');
  }

  startPractice() {
    print('start practice');
  }
}
