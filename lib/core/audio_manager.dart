import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager.internal();
  static AudioManager get instance => _instance;
  factory AudioManager() => _instance;
  AudioManager.internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;

  Future<void> init() async {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void playSfx(String path) {
    if (_isMuted) return;
    _sfxPlayer.play(AssetSource(path));
  }

  void playBgm(String path) {
    if (_isMuted) return;
    _bgmPlayer.play(AssetSource(path));
  }

  void playClick() {
    playSfx('audio/sound_UI_StartClick01.wav');
  }

  void stopBgm() {
    _bgmPlayer.stop();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _bgmPlayer.pause();
    } else {
      _bgmPlayer.resume();
    }
  }

  bool get isMuted => _isMuted;
}
