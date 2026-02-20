import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:flutter/widgets.dart';

class IncreasePlatformSizeEffect implements UpgradeEffect {
  final double multiplier;
  @override
  bool applied = false;
  IncreasePlatformSizeEffect(this.multiplier);

  @override
  void apply(context) {
    // debugPrint(state.platformViewModel.width.toString());

    context.platformViewModel.width +=
        (context.platformViewModel.baseWidth * multiplier);

    // debugPrint(state.platformViewModel.width.toString());
  }

  // @override
  // void remove(GameViewModel state) {
  //   // state.platformViewModel.width /= multiplier;
  // }
}
