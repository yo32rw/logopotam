import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class GameFeedbackService {
  static final GameFeedbackService _instance = GameFeedbackService._internal();

  late final AudioPlayer _backgroundPlayer;
  late final AudioPlayer _effectsPlayer;

  bool _isMusicEnabled = false;
  int _activeScreenCount = 0;

  factory GameFeedbackService() => _instance;

  GameFeedbackService._internal() {
    _backgroundPlayer = AudioPlayer();
    _effectsPlayer = AudioPlayer();
  }

  void playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.play(AssetSource('sounds/background.mp3'));
  }

  void playClickSound() async {
    if (_isMusicEnabled) {
      await _effectsPlayer.play(AssetSource('sounds/press.mp3'));
    }
    await HapticFeedback.lightImpact();
  }

  void playWinSound() async {
    if (_isMusicEnabled) {
      await _effectsPlayer.play(AssetSource('sounds/victory.mp3'));
    }
    await HapticFeedback.heavyImpact();
  }

  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
  }

  void registerScreen() {
    _activeScreenCount++;
  }

  void unregisterScreen() {
    _activeScreenCount--;
    if (_activeScreenCount <= 0) {
      _backgroundPlayer.stop();
    }
  }

  void dispose() {
    if (_activeScreenCount <= 0) {
      _backgroundPlayer.dispose();
      _effectsPlayer.dispose();
    }
  }
}
