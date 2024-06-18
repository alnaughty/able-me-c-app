import 'dart:math';

import 'package:speech_to_text/speech_to_text.dart' as stt;

mixin class AssistantHelper {
  final stt.SpeechToText speech = stt.SpeechToText();
  final Random _random = Random();
  String getRandomResponse(List<String> responses) {
    return responses[_random.nextInt(responses.length)];
  }

  bool containsAny(String text, List<String> keywords) {
    for (var keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}
