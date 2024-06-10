import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MySpeechRecognitionAssistant {
  MySpeechRecognitionAssistant._pr();
  static MySpeechRecognitionAssistant get _instance =>
      MySpeechRecognitionAssistant._pr();
  static List<GlobalKey> _keys = [];
  static int index = 0;
  static MySpeechRecognitionAssistant initialize(
      List<GlobalKey> keys, int currentIndex) {
    index = currentIndex;
    _keys = keys;
    return _instance;
  }

  String currentQuestion = "";
  final Random _random = Random();

  FlutterTts tts = FlutterTts();

  final stt.SpeechToText speech = stt.SpeechToText();
  Future<void> initTTS() async {
    if (Platform.isIOS) {
      await tts.setSharedInstance(true);
      await tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers
          ],
          IosTextToSpeechAudioMode.voicePrompt);
    }
    await tts.awaitSpeakCompletion(true);
    await tts.awaitSynthCompletion(true);
  }

  initTTS2(FlutterTts _tts) {
    if (Platform.isIOS) {
      _tts.setSharedInstance(true);
      _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers
          ],
          IosTextToSpeechAudioMode.voicePrompt);
    }
    _tts.awaitSpeakCompletion(true);
    _tts.awaitSynthCompletion(true);
  }

  void speechRecognitionIsolate(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    final stt.SpeechToText speech = stt.SpeechToText();
    final tts = FlutterTts(); // Replace with your actual TTS initialization

    receivePort.listen((message) async {
      if (message is ValueChanged<int>) {
        await initPlatform2(message, speech, tts, sendPort);
      }
    });
  }

  Future<void> initPlatform2(ValueChanged<int> commandCallback,
      stt.SpeechToText speech, FlutterTts tts, SendPort sendPort) async {
    if (speech.isListening) {
      print("IT IS ALREADY LISTENING");
      return;
    }
    await initTTS2(tts);

    await tts.setLanguage('en_AU');
    await tts
        .speak("HI, I'm Mabel! and I will be assisting you... I am listening");
    print("LISTENING");

    bool _available = await speech.initialize(
      onError: (err) {
        // print("ERROR: $err");
      },
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          if (currentQuestion.isNotEmpty) {
            _startListeningForResponse2(speech, tts, sendPort);
          } else {
            _startListening2(commandCallback, speech, tts, sendPort);
          }
        }
      },
    );

    if (_available) {
      _startListening2(commandCallback, speech, tts, sendPort);
      return;
    } else if (_available && currentQuestion.isNotEmpty) {
      _startListeningForResponse2(speech, tts, sendPort);
      return;
    }
  }

  void _startListening2(ValueChanged<int> commandCallback,
      stt.SpeechToText _speech, FlutterTts tts, SendPort sendPort) {
    _speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
          sendPort.send(text);
          if (currentQuestion.isEmpty) {
            if (_containsAny(text, [
              'ride',
              'transport',
              'drive',
              'trip',
              'cab',
              'car',
              'chauffeur',
              'pick'
            ])) {
              await speak(_getRandomResponse([
                "Ok, I will book you a ride. How many passengers?",
                "Sure, booking a ride for you. How many passengers?",
                "Ride coming up! How many passengers?",
                "Your transport is on the way. How many passengers?"
              ]));
              commandCallback(0);
              currentQuestion = "passengers";
              // await _waitForResponse((passengerCallback) async {
              //   await speak("You have said :$passengerCallback");
              //   await speak("Do you have luggages? if yes, how many?");
              //   await _waitForResponse((budg) async {
              //     await speak("Gotcha! how much are you allocating for budget?");
              //     await _waitForResponse((p) async {});
              //   });
              // });
            } else if (_containsAny(text, [
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
              await speak(_getRandomResponse([
                "Allow me to help you with your hunger",
                "Let's get you some food",
                "Food is on the way",
                "I will help you with your meal"
              ]));
              commandCallback(1);
            } else if (_containsAny(text, [
              'medicine',
              'doctor',
              'pill',
              'healthcare',
              'clinic',
              'health'
            ])) {
              await speak(_getRandomResponse([
                "I will find you the medicine you need",
                "Contacting the doctor for you",
                "Let me help you with your pills",
                "Medicine is being arranged"
              ]));
              commandCallback(2);
            } else if (_containsAny(text, [
              'exit',
              'end app',
              'quit app',
            ])) {
              await speak(_getRandomResponse([
                "Thank you for using Able Me",
                "Good bye",
                "Bye bye",
                "It's been a pleasure"
              ]));
              await Future.delayed(1000.ms);
              commandCallback(-1);
            }
          }
        },
        listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.dictation, partialResults: false));
    // Your start listening logic here
  }

  void _startListeningForResponse2(
      stt.SpeechToText speech, FlutterTts tts, SendPort sendPort) {
    // Your start listening for response logic here
  }
  Future<void> initPlatform(ValueChanged<int> commandCallback) async {
    if (speech.isListening) {
      print("IT IS ALREADY LISTENING");
      return;
    }
    await initTTS();

    await tts.setLanguage('en_AU');
    await tts
        .speak("HI, I'm Mabel! and I will be assisting you... I am listening");
    print("LISTENING");

    bool _available = await speech.initialize(
      onError: (err) {
        // print("ERROR: $err");
      },
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          if (currentQuestion.isNotEmpty) {
            _startListeningForResponse();
          } else {
            _startListening(commandCallback);
          }
        }
      },
    );
    if (_available) {
      _startListening(commandCallback);
      return;
    } else if (_available && currentQuestion.isNotEmpty) {
      _startListeningForResponse();
      return;
    }
  }

  void _startListening(ValueChanged<int> commandCallback) {
    speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
          if (currentQuestion.isEmpty) {
            if (_containsAny(text, [
              'ride',
              'transport',
              'drive',
              'trip',
              'cab',
              'car',
              'chauffeur',
              'pick'
            ])) {
              await speak(_getRandomResponse([
                "Ok, I will book you a ride. How many passengers?",
                "Sure, booking a ride for you. How many passengers?",
                "Ride coming up! How many passengers?",
                "Your transport is on the way. How many passengers?"
              ]));
              commandCallback(0);
              currentQuestion = "passengers";
              // await _waitForResponse((passengerCallback) async {
              //   await speak("You have said :$passengerCallback");
              //   await speak("Do you have luggages? if yes, how many?");
              //   await _waitForResponse((budg) async {
              //     await speak("Gotcha! how much are you allocating for budget?");
              //     await _waitForResponse((p) async {});
              //   });
              // });
            } else if (_containsAny(text, [
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
              await speak(_getRandomResponse([
                "Allow me to help you with your hunger",
                "Let's get you some food",
                "Food is on the way",
                "I will help you with your meal"
              ]));
              commandCallback(1);
            } else if (_containsAny(text, [
              'medicine',
              'doctor',
              'pill',
              'healthcare',
              'clinic',
              'health'
            ])) {
              await speak(_getRandomResponse([
                "I will find you the medicine you need",
                "Contacting the doctor for you",
                "Let me help you with your pills",
                "Medicine is being arranged"
              ]));
              commandCallback(2);
            } else if (_containsAny(text, [
              'exit',
              'end app',
              'quit app',
            ])) {
              await speak(_getRandomResponse([
                "Thank you for using Able Me",
                "Good bye",
                "Bye bye",
                "It's been a pleasure"
              ]));
              await Future.delayed(1000.ms);
              commandCallback(-1);
            }
          }
        },
        listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.dictation, partialResults: false));
  }

  String _getRandomResponse(List<String> responses) {
    return responses[_random.nextInt(responses.length)];
  }

  Future<void> speak(String message) async {
    await tts.speak(message);
  }

  bool _containsAny(String text, List<String> keywords) {
    for (var keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  // Future<void> _waitForResponse(ValueChanged<String> responseCallback) async {
  //   speech.listen(
  //     onResult: (res) async {
  //       final String text = res.recognizedWords;
  //       responseCallback(text);
  //       print("response : $text");
  //     },
  //     listenOptions: stt.SpeechListenOptions(
  //         listenMode: stt.ListenMode.dictation, partialResults: false),
  //   );
  // }
  void _startListeningForResponse() {
    speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
          await speak("You said : $text");
          await _handleFollowUpQuestions(text);
        },
        listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.dictation, partialResults: false));
  }

  Future<void> _handleFollowUpQuestions(String text) async {
    if (text.contains("cancel")) {
      currentQuestion = "";
      await speak("Command is cancelled");
    } else if (currentQuestion == "passengers") {
      // Process the response for passengers
      await speak("Got it. How many luggage?");
      currentQuestion = "luggage";
    } else if (currentQuestion == "luggage") {
      // Process the response for luggage
      await speak("Understood. What is your budget?");
      currentQuestion = "budget";
    } else if (currentQuestion == "budget") {
      // Process the response for budget
      await speak("Thank you! do you have a pet companion?");
      currentQuestion = "pet";
      // _commandCallback?.call(0);
    } else if (currentQuestion == "pet") {
      await speak("Booking your ride now!");
      currentQuestion = "";
    }
  }
}
