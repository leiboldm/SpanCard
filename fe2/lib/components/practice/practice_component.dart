import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:fe2/service/service.dart';
import 'package:fe2/components/header/header.dart';
import 'package:fe2/components/practice/flashcards.dart';
import 'dart:convert';

@Component(
  selector: 'flashcard-practice',
  templateUrl: 'practice.html',
  directives: const [HeaderComponent])
class FlashcardPracticeComponent {
  Router _router;
  FlashcardSet cardDeck;
  Flashcard currentCard;
  bool translationVisible = false;
  String loadCardsErrorMessage;
  bool loadingCards = true;

  FlashcardPracticeComponent(this._router) {
    _loadCards();
  }

  processResult(bool correct) {
    cardDeck.registerResult(correct);
    currentCard = cardDeck.getNextCard();
    if (currentCard == null) {
      _loadCards();
    }
    translationVisible = false;
  }

  showMainPage() {
    _router.navigate(['Lookup']);
  }

  _loadCards() {
    loadingCards = true;
    sendGetRequest('flashCardWords.php').then((String resp) {
      Map response = JSON.decode(resp);
      if (response['success']) {
        List<Flashcard> cards = response['flashCardWords'].map(
          (c) => new Flashcard(c['fromWord'], c['toWord']))
          .toList();
        if (cards.isEmpty) {
          loadCardsErrorMessage =
            'You have no flashcards. Go to lookup to add some.';
        } else {
          cardDeck = new FlashcardSet(cards);
          currentCard = cardDeck.getNextCard();
        }
      } else {
        loadCardsErrorMessage = 'There was an error loading your cards. ' +
            'Try again later.';
      }
      loadingCards = false;
    });
  }
}
