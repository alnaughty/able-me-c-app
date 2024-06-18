import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  FlutterTts tts = FlutterTts();
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
    await tts.setLanguage('en_AU');
    await speak("HI, I'm Mabel! and I will be assisting you... I am listening");
  }

  Future<void> speak(String message) async {
    await tts.speak(message);
  }
}
