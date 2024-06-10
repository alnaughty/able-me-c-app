import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SpeechRecognitionNotifier extends StateNotifier<SpeechRecognitionState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final BuildContext context; // Added context for navigation

  SpeechRecognitionNotifier(this.context)
      : super(SpeechRecognitionState.initial(context)) {
    initSpeech();
  }

  Future<void> initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: _onStatus,
      onError: _onError,
    );
    if (available) {
      _startListening();
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: _onResult,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
    );
    // state = state.copyWith(isListening: true);
  }

  void _stopListening() {
    _speech.stop();
    state = state.copyWith(isListening: false);
  }

  void _restartListening() {
    _stopListening();
    _startListening();
  }

  void _onResult(SpeechRecognitionResult result) {
    state = state.copyWith(recognizedText: result.recognizedWords);
    // _handleCommands(result.recognizedWords);
    print(result.recognizedWords);
  }

  void _handleCommands(String recognizedWords) {
    if (recognizedWords.toLowerCase().contains('go to screen1')) {
      Navigator.pushNamed(context, '/screen1');
    } else if (recognizedWords.toLowerCase().contains('go to screen2')) {
      Navigator.pushNamed(context, '/screen2');
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _restartListening(); // Restart listening when speech recognition is done or not listening
    }
  }

  void _onError(Object error) {
    print('Error: $error');
    _restartListening(); // Restart listening on error
  }
}

class SpeechRecognitionState {
  final bool isListening;
  final String recognizedText;
  final BuildContext context;
  SpeechRecognitionState({
    required this.isListening,
    required this.recognizedText,
    required this.context,
  });

  factory SpeechRecognitionState.initial(BuildContext context) {
    return SpeechRecognitionState(
      isListening: false,
      recognizedText: '',
      context: context,
    );
  }

  SpeechRecognitionState copyWith({
    bool? isListening,
    String? recognizedText,
    BuildContext? context,
  }) {
    return SpeechRecognitionState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      context: context ?? this.context,
    );
  }
}

final navigationContextProvider = StateProvider<BuildContext>((ref) {
  throw UnimplementedError();
});
final speechRecognitionProvider =
    StateNotifierProvider<SpeechRecognitionNotifier, SpeechRecognitionState>(
  (ref) {
    final context = ref.watch(navigationContextProvider);
    return SpeechRecognitionNotifier(context);
  },
);
// final speechRecognitionProvider =
//     StateNotifierProvider<SpeechRecognitionNotifier, SpeechRecognitionState>(
//   (ref) => SpeechRecognitionNotifier(ref.watch(navigationContextProvider)),
// );

// final navigationContextProvider = StateProvider<BuildContext>((ref) {
//   throw UnimplementedError();
// });
