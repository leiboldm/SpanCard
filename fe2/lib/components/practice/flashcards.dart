import 'package:fe2/service/service.dart';

class Flashcard {
  String fromWord;
  String toWord;
  Flashcard(this.fromWord, this.toWord);
}

class FlashcardSet {
  List<Flashcard> cards;
  int currentIndex = -1;
  int successes = 0;
  FlashcardSet(this.cards);

  Flashcard getNextCard() {
    if (cards == null) return null;
    ++currentIndex;
    if (currentIndex == cards.length) {
      return null;
    } else {
      print(cards.runtimeType);
      return cards[currentIndex];
    }
  }

  registerResult(bool success) {
    successes += success ? 1 : 0;
    Map data = {
      'correct': success,
      'word': cards[currentIndex].fromWord
    };
    sendPostRequest("flashCardWords.php", data).then((r) {
      print(r); // don't really care all too much if this request fails
    });
  }

  reset() {
    currentIndex = -1;
    successes = 0;
  }

  bool hasCards() => cards != null && cards.isNotEmpty;
}
