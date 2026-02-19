import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class IncreaseBallPowerEffect implements UpgradeEffect {
  @override
  // TODO: implement applied
  bool get applied => throw UnimplementedError();

  @override
  void apply(GameViewModel state) {
    state.ballViewModel.model.power += 20;
  }

  @override
  void remove(GameViewModel state) {
    // TODO: implement remove
  }
}
