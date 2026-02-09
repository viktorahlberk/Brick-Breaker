import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final _player = AudioPlayer();

  playSound() async {
    await _player.play(AssetSource('sounds/collision.mp3'));
  }
}
