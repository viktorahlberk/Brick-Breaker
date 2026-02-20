import 'dart:math';

import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeRarity.dart';
import 'package:bouncer/features/upgrades/effects/increaseBallPowerEffect.dart';
import 'package:bouncer/features/upgrades/effects/increasePlatformSizeEffect.dart';
// import 'package:flutter/material.dart';

class UpgradeManager {
  final List<UpgradeEntity> _upgradesPool = [
    UpgradeEntity(
        title: 'IncreaseBallPower',
        description: 'Increases ball power, so ball do more damage on bricks',
        rarity: UpgradeRarity.rare,
        effect: IncreaseBallPowerEffect()),
    UpgradeEntity(
        title: 'IncreasePlatformSize',
        description: 'Increases platform width',
        rarity: UpgradeRarity.rare,
        effect: IncreasePlatformSizeEffect(0.2))
  ];
  // addUpgrade(UpgradeEntity entity, GameCoordinator coordinator) {
  //   entity.effect.apply(coordinator);
  // }

  List<UpgradeEntity> getUpgrades(int quantity) {
    List<UpgradeEntity> picked = [];
    for (var i = 0; i < quantity; i++) {
      picked.add(_pickUpgrade());
    }
    return picked;
  }

  UpgradeEntity _pickUpgrade() {
    int totalUpgrades = _upgradesPool.length;
    var picked = Random().nextInt(totalUpgrades);
    // debugPrint('rng is: $picked');
    // debugPrint('added ${_upgradesPool[picked].title}');
    return _upgradesPool[picked];
  }
}
