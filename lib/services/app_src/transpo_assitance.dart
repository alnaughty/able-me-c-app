import 'dart:io';

import 'package:able_me/services/app_src/speech_recgonition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

mixin TranspoAssistance {
  // FlutterTts tts = FlutterTts();
  FlutterTts tts = FlutterTts();

  final stt.SpeechToText speech = stt.SpeechToText();
  Future<void> initTTS() async {
    await tts.getVoices.then((value) {
      print("VOICES : $value");
    });
    await tts.getLanguages.then((value) => print("LANG : $value"));
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

  Future<void> stop() async {
    await speech.stop();
  }

  // final stt.SpeechToText _speech = stt.SpeechToText();
  Future<void> initTransportPlatform(
      ValueChanged<String> commandCallback) async {
    // if (speech.isListening) {
    //   print("IT IS ALREADY LISTENING");
    //   // return;
    //   await speech.stop();
    // }
    // await initTTS();
    // // await tts.getDisplayLanguages();
    // // await tts.getLanguages().then(print);
    // await tts.speak("I will help you with your transportation");
    // await tts.speak("How many passengers?");
    // _startListening((cmd) async {
    //   await stop();
    //   commandCallback(cmd);
    //   await tts.speak("How many luggages?");
    //   _startListening((value) async {
    //     await stop();
    //     commandCallback(value);
    //   });
    // });
    // print("LISTENING");
    // // bool _available = await speech.initialize(
    // //   onError: (err) {},
    // //   onStatus: (status) {
    // //     // if (status == "done" || status == "notListening") {
    // //     //   _startListening(commandCallback);
    // //     // }
    // //     // print("SPEECH STATUS : $status");
    // //   },
    // // );
    // // if (_available) {
    // //   _startListening(commandCallback);
    // //   return;
    // // }
  }

  void _startListening(ValueChanged<String> commandCallback) {
    speech.listen(
        onResult: (res) async {
          final String text = res.recognizedWords;
        },
        // listenMode:
        listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.dictation, partialResults: false));
  }

  Future<void> askPassenger() async {
    await speak("How many passengers?");
  }

  Future<void> speak(String message) async {
    await tts.speak(message);
  }
}
