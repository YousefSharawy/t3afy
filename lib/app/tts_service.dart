import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  // -----------------------------------------------------------------------
  // Public state — listen to this in the UI to animate the volume icon.
  // -----------------------------------------------------------------------
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  /// The term currently being spoken. Used to toggle-stop on repeated taps.
  String? _currentTerm;

  // -----------------------------------------------------------------------
  // Init
  // -----------------------------------------------------------------------

  Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      isSpeaking.value = true;
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
      _currentTerm = null;
    });

    _flutterTts.setErrorHandler((dynamic msg) {
      isSpeaking.value = false;
      _currentTerm = null;
    });

    _isInitialized = true;
  }

  // -----------------------------------------------------------------------
  // Speak a raw string (generic, no toggle behaviour).
  // -----------------------------------------------------------------------

  Future<void> speak(String text) async {
    await init();
    await _flutterTts.stop();
    _currentTerm = null;
    isSpeaking.value = false;
    await _flutterTts.speak(text);
  }

  // -----------------------------------------------------------------------
  // Speak a latin term.
  //
  // Toggle behaviour on repeated taps of the same term:
  //   1st tap  → speaks the term
  //   2nd tap  → stops
  //   3rd tap  → speaks again
  // -----------------------------------------------------------------------

  Future<void> speakPronunciation(String term) async {
    await init();

    if (_currentTerm == term && isSpeaking.value) {
      await stop();
      return;
    }

    await _flutterTts.stop();
    _currentTerm = term;
    await _flutterTts.speak('$term.');
  }

  // -----------------------------------------------------------------------
  // Stop
  // -----------------------------------------------------------------------

  Future<void> stop() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
    _currentTerm = null;
  }

  // -----------------------------------------------------------------------
  // Dispose
  // -----------------------------------------------------------------------

  void dispose() {
    _flutterTts.stop();
    isSpeaking.dispose();
  }
}