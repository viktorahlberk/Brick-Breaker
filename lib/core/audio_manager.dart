import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();

  static final AudioManager instance = AudioManager._();

  late final Future<AudioPool> _collisionPool = AudioPool.create(
    source: AssetSource('sounds/collision.wav'),
    minPlayers: 2,
    maxPlayers: 2,
  );
  late final Future<AudioPool> _updateSoundPool = AudioPool.create(
    source: AssetSource('sounds/add_update.mp3'),
    maxPlayers: 2,
  );

  Future<void> initialize() async {
    await Future.wait([_collisionPool, _updateSoundPool]);
  }

  Future<void> playCollisionSound() async {
    final pool = await _collisionPool;
    await pool.start();
  }

  Future<void> playAddUpdateSound() async {
    final pool = await _updateSoundPool;
    await pool.start();
  }
}
