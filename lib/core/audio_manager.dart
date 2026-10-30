import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // final _player = AudioPlayer();
  Future<AudioPool> collisionPool = AudioPool.create(
      source: AssetSource('sounds/collision.mp3'), maxPlayers: 2);
  Future<AudioPool> updatesoundPool = AudioPool.create(
      source: AssetSource('sounds/add_update.mp3'), maxPlayers: 2);

  playCollisionSound() async {
    AudioPool cp = await collisionPool;
    await cp.start();
  }

  playAddUpdateSound() async {
    AudioPool up = await updatesoundPool;
    await up.start();
  }
}
