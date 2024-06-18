extension VALIDATOR on String {
  static final RegExp _email = RegExp(
      r"^((([a-z]|\d|[!#\$%&'*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  bool get isValidEmail {
    return _email.hasMatch(toLowerCase());
  }

  Uri get toUri => Uri.parse(this);
}

extension CapitalizeFirstLetter on String {
  String capitalizeWords() {
    List<String> words = split(" ");
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      words[i] = "${word[0].toUpperCase()}${word.substring(1)}";
    }
    return words.join(" ");
  }
}

extension Extractor on String {
  static final RegExp pattern =
      RegExp(r'\$?(\d+)(?:[\s,]*(\d+))?(?:[\s,]*(?:cents?))?');
  static final Map<String, int> _wordToNumberMap = {
    'none': 0,
    'zero': 0,
    'only me': 1,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'eleven': 11,
    'twelve': 12,
    'thirteen': 13,
    'fourteen': 14,
    'fifteen': 15,
    'sixteen': 16,
    'seventeen': 17,
    'eighteen': 18,
    'nineteen': 19,
    'twenty': 20,
    'thirty': 30,
    'forty': 40,
    'fifty': 50,
    'sixty': 60,
    'seventy': 70,
    'eighty': 80,
    'ninety': 90,
    'hundred': 100,
    'thousand': 1000,
    'million': 1000000,
    // Add more as needed
  };

  bool hasDecimanl() => pattern.firstMatch(this) != null;
  double? extractPrice() {
    var match = pattern.firstMatch(this);
    if (match != null) {
      // String? dollars = match.group(0); // Remove $ if present
      // String? cents = match.group(1);

      // Combine the parts into a decimal number
      String dollars = match.group(1) ?? '0';
      String cents = match.group(2) ?? '0';
      String decimalNumber = '$dollars.$cents';

      // Combine dollars and cents to get the price string
      decimalNumber = '$dollars.$cents';
      print("The text contains numbers that represent: $decimalNumber.");
      return double.tryParse(decimalNumber);
      // Extract the matched groups
      // String? dollars = match.group(1);
      // String? cents = match.group(2);

      // // Combine the parts into a decimal number
      // String decimalNumber = '$dollars.$cents';
      // if (dollars != null && cents != null) {
      //   decimalNumber = '$dollars.$cents';
      // } else if (dollars != null) {
      //   decimalNumber = dollars;
      // } else if (cents != null) {
      //   decimalNumber = '0.$cents';
      // }
      // print(this);
      // print(
      //     "The text contains numbers that represent: $decimalNumber dollars.");
      // return double.tryParse(decimalNumber);
    } else {
      print(
          "The text does not contain the pattern 'number dollars and number cents'.");
      return null;
    }
  }

  bool containsNumber() {
    final RegExp numericRegExp = RegExp(r'\d+');
    if (numericRegExp.hasMatch(this)) {
      return true;
    }

    final List<String> words = split(RegExp(r'\s+'));
    for (String word in words) {
      if (_wordToNumberMap.containsKey(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  int? _wordsToNumber(List<String> words) {
    int? result;
    int? temp;
    int factor = 1;

    for (String word in words) {
      word = word.toLowerCase();
      if (_wordToNumberMap.containsKey(word)) {
        int value = _wordToNumberMap[word]!;

        if (value >= 100) {
          if (temp != null) {
            temp *= value;
          } else {
            temp = (result ?? 0) * value;
          }
        } else if (value >= 1000) {
          if (result != null) {
            result *= value;
          } else {
            result = (temp ?? 1) * value;
            temp = null;
          }
        } else {
          if (temp != null) {
            temp += value;
          } else {
            temp = (result ?? 0) + value;
          }
        }

        if (value >= 1000) {
          factor = value;
        }
      }
    }

    return (result ?? 0) + (temp ?? 0) * factor;
  }

  int? extractNumber() {
    final RegExp numericRegExp = RegExp(r'\d+');
    final Match? numericMatch = numericRegExp.firstMatch(this);
    if (numericMatch != null) {
      return int.parse(numericMatch.group(0)!);
    }

    final List<String> words = split(RegExp(r'\s+'));
    final List<String> numberWords = words
        .where((word) => _wordToNumberMap.containsKey(word.toLowerCase()))
        .toList();
    if (numberWords.isNotEmpty) {
      return _wordsToNumber(numberWords);
    }

    return null;
  }
}
