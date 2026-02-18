import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:flutter/widgets.dart';

class IncreasePlatformSizeEffect implements UpgradeEffect {
  final double multiplier;
  @override
  bool applied = false;
  IncreasePlatformSizeEffect(this.multiplier);

  @override
  void apply(GameViewModel state) {
    // debugPrint(state.platformViewModel.width.toString());

    state.platformViewModel.width +=
        (state.platformViewModel.baseWidth * multiplier);

    // debugPrint(state.platformViewModel.width.toString());
  }

  @override
  void remove(GameViewModel state) {
    // state.platformViewModel.width /= multiplier;
  }
}
