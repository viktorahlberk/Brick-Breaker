import 'package:bouncer/features/game/viewModels/gameViewModel.dart';

abstract class UpgradeEffect {
  bool get applied;
  void apply(GameViewModel state);
  void remove(GameViewModel state);
}
