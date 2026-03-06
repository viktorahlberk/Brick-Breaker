import 'package:bouncer/features/game/runtimeContext.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class IncreaseBallPowerEffect implements UpgradeEffect {
  @override
  bool applied = false;

  @override
  void apply(RuntimeContext context) {
    // context.ballViewModel.model.power += 20;
  }
}
