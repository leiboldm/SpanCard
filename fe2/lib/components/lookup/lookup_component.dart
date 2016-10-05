import 'package:angular2/core.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/components/header/header.dart';
import 'package:angular2/router.dart';
import 'package:js/js.dart';
import 'dart:convert';

@JS("parseTranslationData")
external String parseTranslationData(String);

@Component(
    selector: 'lookup',
    templateUrl: 'lookup.html',
    styleUrls: const ['lookup.css'],
    directives: const [HeaderComponent])
class LookupComponent {
  String word = "";
  String fromWord = "";
  List translations = [];
  String toWord = "";
  final Router _router;
  String addWordErrorMessage = "";
  String addWordSuccessMessage = "";

  LookupComponent(this._router);

  lookupWord() {
    getTranslationPage(word).then((String data) {
      String parsed = parseTranslationData(data);
      translations = JSON.decode(parseTranslationData(data));
      if (translations.isNotEmpty) {
        fromWord = translations.first.first['fromWord'];
        toWord = translations.first.first['translation'];
      }
    });
  }

  addToFlashcardSet() {
    print('add to flash card set');
  }

  startPractice() {
    print('start practice');
  }
}
