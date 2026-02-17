// import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';

abstract class Boss {
  void update(double dt, GameViewModel state);
  void onBallHit(double damage, GameViewModel state);
  bool get isDefeated;
}
