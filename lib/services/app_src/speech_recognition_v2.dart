import 'package:able_me/helpers/assistant_helpers.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/tts_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PayloadCallback {
  final String key;
  final dynamic value;
  const PayloadCallback({required this.key, required this.value});
}

class SpeechAssistant with AssistantHelper {
  final ValueChanged<PayloadCallback> onCommandListened;
  final ValueChanged<int> onNavigationCommand;
  bool isSpeaking = false;
  SpeechAssistant(
      {required this.onCommandListened, required this.onNavigationCommand});
  static final TTSHelper ttsHelper = TTSHelper();
  String currentQuestion = "";
  Future<void> initialize() async {
    isSpeaking = true;
    await Future.value([
      ttsHelper.initTTS(),
      listen(),
    ]);
    isSpeaking = false;
  }

  Future<void> listen() async {
    if (speech.isListening) {
      print("IT IS ALREADY LISTENING");
      return;
    }

    print("LISTENING");
    bool _available = await speech.initialize(
      onError: (err) {
        // print("ERROR: $err");
      },
      onStatus: (status) async {
        if ((status == "done" || status == "notListening") && !isSpeaking) {
          await Future.delayed(1000.ms);
          if (currentQuestion.isNotEmpty) {
            _startListeningForResponse();
          } else {
            _startListening();
          }
        }
      },
    );
    if (_available) {
      _startListening();
      return;
    } else if (_available && currentQuestion.isNotEmpty) {
      _startListeningForResponse();
      return;
    }
  }

  bool doesTextContainAnyValue(String text) {
    return _followupQs.any((element) => text.contains(element));
  }

  void _startListeningForResponse() {
    speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
          await ttsHelper.speak("You said : $text");
          await _handleFollowUpQuestions(text);
        },
        listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation, partialResults: false));
  }

  void _startListening() {
    speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
          if (currentQuestion.isEmpty) {
            if (containsAny(text, [
              'ride',
              'transport',
              'drive',
              'trip',
              'cab',
              'car',
              'chauffeur',
              'pick'
            ])) {
              onNavigationCommand(0);
              isSpeaking = true;
              await ttsHelper.speak(getRandomResponse([
                "Ok, I will book you a ride. How many passengers?",
                "Sure, booking a ride for you. How many passengers?",
                "Ride coming up! How many passengers?",
                "Your transport is on the way. How many passengers?"
              ]));
              isSpeaking = false;
              // (0);
              currentQuestion = "passengers";
              // await _waitForResponse((passengerCallback) async {
              //   await ttsHelper.ttsHelper.speak("You have said :$passengerCallback");
              //   await ttsHelper.ttsHelper.speak("Do you have luggages? if yes, how many?");
              //   await _waitForResponse((budg) async {
              //     await ttsHelper.ttsHelper.speak("Gotcha! how much are you allocating for budget?");
              //     await _waitForResponse((p) async {});
              //   });
              // });
            } else if (containsAny(text, [
              'food',
              'hungry',
              'eat',
              'meal',
              'restaurant',
              'lunch',
              'breakfast',
              'dinner',
              'snack',
              'dish',
              'munchies'
            ])) {
              onNavigationCommand(1);
              isSpeaking = true;
              await ttsHelper.speak(getRandomResponse([
                "Allow me to help you with your hunger",
                "Let's get you some food",
                "Food is on the way",
                "I will help you with your meal"
              ]));
              isSpeaking = false;
            } else if (containsAny(text, [
              'medicine',
              'doctor',
              'pill',
              'healthcare',
              'clinic',
              'health'
            ])) {
              onNavigationCommand(2);
              isSpeaking = true;
              await ttsHelper.speak(getRandomResponse([
                "I will find you the medicine you need",
                "Contacting the doctor for you",
                "Let me help you with your pills",
                "Medicine is being arranged"
              ]));
              isSpeaking = false;
            } else if (containsAny(text, [
              'exit',
              'end app',
              'quit app',
            ])) {
              await ttsHelper.speak(getRandomResponse([
                "Thank you for using Able Me",
                "Good bye",
                "Bye bye",
                "It's been a pleasure"
              ]));
              await Future.delayed(1000.ms);
              onNavigationCommand(-1);
            }
          }
        },
        listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation, partialResults: false));
  }

  Future<void> updateData(String text, String key,
      {required String onSuccess, required onSuccessNextQ}) async {
    if (text.containsNumber()) {
      // final notifier =
      final int? num = text.extractNumber();

      onCommandListened(PayloadCallback(key: key, value: num));
      await ttsHelper.speak("$num it is, $onSuccess");
      currentQuestion = onSuccessNextQ;
    } else {
      await ttsHelper.speak("Unable to find number");
    }
  }

  Future<void> updatePrice(String text) async {
    if (text.hasDecimanl()) {
      final double? num = text.extractPrice();
      if (num == null) {
        await ttsHelper.speak("Unable to find number");
        return;
      }
      onCommandListened(PayloadCallback(key: 'budget', value: num));

      await ttsHelper.speak("Thank you! do you have a wheelchair?");
      currentQuestion = 'wheelchair';
    } else {
      await ttsHelper.speak("Unable to find number");
    }
    // await updateData(
    //     text,
    //     'budget',
    //     onSuccess: "Thank you! do you have a pet companion?",
    //     onSuccessNextQ: "pet",
    //   );
  }

  final List<String> _followupQs = const [
    'Command is cancelled',
    'Unable to find number',
    'Updating passenger',
    'Updating luggage',
    'Got it. How many luggage?',
    'Understood. What is your budget?',
    "Ok, I will book you a ride. How many passengers?",
    "Sure, booking a ride for you. How many passengers?",
    "Ride coming up! How many passengers?",
    "Your transport is on the way. How many passengers?",
    "Thank you! do you have a pet companion?",
  ];
  String prevQ = '';
  bool updateValue(String text, String key) {
    if (text.containsNumber()) {
      // final notifier =
      final int? num = text.extractNumber();
      if (num == null) {
        return false;
      }
      onCommandListened(PayloadCallback(key: key, value: num));
      // await ttsHelper.speak("Value updated!");
      return true;
    } else {
      return false;
    }
  }

  Future<void> _handleFollowUpQuestions(String text) async {
    if (text.contains("cancel")) {
      currentQuestion = "";
      await ttsHelper.speak("Command is cancelled");
      isSpeaking = false;
    } else if (currentQuestion == 'update_pass') {
      bool hasUpdated = updateValue(text, 'passenger');
      if (hasUpdated) {
        await ttsHelper.speak("Value updated!");
        currentQuestion = prevQ;
      } else {
        await ttsHelper.speak("Speak again");
      }
      isSpeaking = false;
    } else if (text.contains("update passenger")) {
      // currentQuestion = "";
      // currentQuestion = "passengers";
      await ttsHelper.speak("Updating passenger, what's the updated value?");
      prevQ = currentQuestion;
      currentQuestion = 'update_pass';
      isSpeaking = false;
    } else if (text.contains("update luggage")) {
      // currentQuestion = "luggage";
      await ttsHelper.speak("Updating luggage");
      isSpeaking = false;
    } else if (text.contains("update price")) {
      await ttsHelper.speak("Updating price, what is your update?");
      await updatePrice(text);
    } else if (currentQuestion == "passengers") {
      await updateData(
        text,
        'passenger',
        onSuccess: "Got it. How many luggage?",
        onSuccessNextQ: "luggage",
      );
      isSpeaking = false;
    } else if (currentQuestion == "luggage") {
      await updateData(
        text,
        'luggage',
        onSuccess: "Understood. What is your budget?",
        onSuccessNextQ: "budget",
      );
      isSpeaking = false;
    } else if (currentQuestion == "budget") {
      // if (text.contains("yes")) {
      // } else {}
      await updatePrice(text);
      // await updateData(
      //   text,
      //   'budget',
      //   onSuccess: "Thank you! do you have a pet companion?",
      //   onSuccessNextQ: "pet",
      // );
      isSpeaking = false;
      // // Process the response for budget
      // await ttsHelper.speak("Thank you! do you have a pet companion?");
      // currentQuestion = "pet";
      // _commandCallback?.call(0);
    } else if (currentQuestion == "wheelchair") {
      onCommandListened(
        PayloadCallback(
          key: "wheelchair",
          value: text.contains("yes"),
        ),
      );
      bool y = text.contains("yes") || text.contains("yes");
      bool n = text.contains("no") || text.contains("none");
      if (y || n) {
        await ttsHelper.speak(
            "You said ${y ? "yes" : "no"},Awesome! do you have a pet companion?");
        currentQuestion = 'pet';
      }
    } else if (currentQuestion == "pet") {
      bool y = text.contains("yes") || text.contains("yes");
      bool n = text.contains("no") || text.contains("none");
      onCommandListened(
        PayloadCallback(
          key: "pet",
          value: y,
        ),
      );
      if (y || n) {
        await ttsHelper.speak("Do you have an additional note to rider?");

        currentQuestion = 'ask_note';
      }
    } else if (currentQuestion == 'note') {
      bool deny = text.contains("nevermind") || text.contains("none");
      if (deny) {
        await ttsHelper.speak("I will book a ride!");
        onCommandListened(
          const PayloadCallback(
            key: "book",
            value: true,
          ),
        );
        currentQuestion = '';
      } else {
        onCommandListened(
          PayloadCallback(
            key: "note",
            value: text,
          ),
        );
        await ttsHelper.speak("I will book a ride!");
        onCommandListened(
          const PayloadCallback(
            key: "book",
            value: true,
          ),
        );
        currentQuestion = '';
      }
    } else if (currentQuestion == "ask_note") {
      bool y = text.contains("yes") || text.contains("yes");
      bool n = text.contains("no") || text.contains("none");
      if (y) {
        await ttsHelper.speak("What is your note?");
        currentQuestion = 'note';
      } else if (n) {
        await ttsHelper.speak("I will book a ride!");
        onCommandListened(
          const PayloadCallback(
            key: "book",
            value: true,
          ),
        );
        currentQuestion = '';
      }
    }
  }
}
