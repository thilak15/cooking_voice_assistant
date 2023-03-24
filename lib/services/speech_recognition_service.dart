import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    return await _speech.initialize();
  }

  void toggleListening() {
    _isListening = !_isListening;
  }

  Future<void> startListening({
    required void Function(String text) onResult,
    required void Function(dynamic error) onError,
    required void Function(String status) onStatus,
  }) async {
    bool available = await _speech.initialize(onError: onError, onStatus: onStatus);
    if (available) {
      toggleListening();
      _speech.listen(onResult: (val) {
        onResult(val.recognizedWords);
      });
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      toggleListening();
      await _speech.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_isListening) {
      toggleListening();
      await _speech.cancel();
    }
  }
}
