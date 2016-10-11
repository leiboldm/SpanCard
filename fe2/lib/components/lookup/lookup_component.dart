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
  List translations = [];
  final Router _router;
  String addWordErrorMessage = "";
  String addWordSuccessMessage = "";

  LookupComponent(this._router);

  lookupWord() {
    addWordSuccessMessage = "";
    addWordErrorMessage = "";
    getTranslationPage(word).then((String data) {
      String parsed = parseTranslationData(data);
      translations = JSON.decode(parseTranslationData(data));
    });
  }

  addToFlashcardSet() {
    assert(translations.isNotEmpty);
    Map<String, String> data = {
      'fromWord': translations.first.first['fromWord'],
      'toWord': translations.first.first['translation']
    };
    addWordSuccessMessage = "";
    addWordErrorMessage = "";
    sendPostRequest("addWord.php", data).then((resp) {
      Map response = JSON.decode(resp);
      if (response['success']) {
        addWordSuccessMessage = "Flashcard added.";
      } else {
        addWordErrorMessage = "Error adding flashcard.  Please try again later.";
      }
    });
  }

  startPractice() {
    _router.navigate(['Practice']);
  }
}
