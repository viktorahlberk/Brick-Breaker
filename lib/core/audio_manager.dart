import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final _player = AudioPlayer();

  playCollisionSound() async {
    await _player.play(AssetSource('sounds/collision.mp3'));
  }

  playAddUpdateSound() async {
    await _player.play(AssetSource('sounds/add_update.mp3'));
  }
}
