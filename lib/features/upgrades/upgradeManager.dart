import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:bouncer/features/upgrades/effects/increasePlatformSizeEffect.dart';

class UpgradeManager {
  // List<UpgradeEffect> _appliedUpgrades = [];
  addUpgrade(UpgradeEffect effect, GameViewModel state) {
    effect.apply(state);
    // _appliedUpgrades.add(effect);
  }

  // applyAllEffects() {}
}
