import 'package:bouncer/features/game/domain/brickModel.dart';

class ScoreManager {
  int _score = 0;
  int get score => _score;

  add(BrickType type) {
    switch (type) {
      case BrickType.normal:
        _score += 100;
        break;
      case BrickType.strong:
        _score += 200;
        break;
      default:
    }
  }

  resetScore() {
    _score = 0;
  }
}
