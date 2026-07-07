import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Speaks Punjabi (Gurmukhi) text aloud and plays feedback sounds.
///
/// Android: uses Google's TTS engine which supports Punjabi (India) natively.
/// iOS: AVSpeechSynthesizer does not reliably support Punjabi — this is a
/// known gap to revisit when we build the iOS version (likely bundled
/// pre-recorded audio instead of live TTS).
class AudioService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('pa-IN');
    await _tts.setSpeechRate(0.4); // slower, easier for kids to follow
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  Future<bool> isPunjabiAvailable() async {
    try {
      final result = await _tts.isLanguageAvailable('pa-IN');
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text) async {
    await _init();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  /// Plays a short 'tick' sound for successful actions.
  Future<void> playSuccess() async {
    await SystemSound.play(SystemSoundType.click);
    await HapticFeedback.lightImpact();
  }
}
