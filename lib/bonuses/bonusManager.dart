import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:bouncer/bonuses/bonusEffect.dart';
import 'package:bouncer/bonuses/bonusModel.dart';
import 'package:bouncer/bonuses/bonusPickupVmModel.dart';
import 'package:bouncer/bonuses/bonusType.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:flutter/cupertino.dart';

class BonusManager {
  final pickups = <BonusPickupViewModel>[];
  final _activeEffects = <BonusEffect>[];
  // bool isGunActive =

  // bool get isGunActive => _activeEffects.contains(PlatformGunEffect());

  void trySpawnBonus({
    required Offset position,
  }) {
    // debugPrint('trySpawnBonus');
    // return;
    if (Random().nextDouble() < 0.9) {
      if (Random().nextDouble() < 0.9) {
        pickups.add(
          BonusPickupViewModel(
            model: BonusModel(
                type: BonusType.bigPlatform,
                duration: Duration(seconds: 10),
                position: position),
          ),
        );
      }
      // else {
      //     pickups.add(
      //       BonusPickupViewModel(
      //         model: BonusModel(
      //             type: BonusType.platformGun,
      //             duration: Duration(seconds: 10),
      //             position: position),
      //       ),
      //     );
      //   }
    }
    // debugPrint(pickups.toString())
    //   // ;
  }

  void update(double dt) {
    if (pickups.isNotEmpty) {
      for (var pickupBonus in pickups) {
        pickupBonus.update(dt);
      }
    }
    // if (_activeEffects.isNotEmpty) {
    //   for (var activeBonus in _activeEffects) {
    //     activeBonus.update(dt);
    //   }
    // }
  }

  void checkCollect(
      PlatformViewModel platform, void Function(BonusType) onCollected) {
    for (final bonus in pickups) {
      if (platform.rect.overlaps(bonus.rect)) {
        // log('collected');
        bonus.collected = true;
        // _activeBonuses
        //     .add(ActiveBonus(effect: BigPlatformEffect(), duration: 10));
        onCollected(bonus.model.type);
      }
    }
    pickups.removeWhere((b) => b.collected);
  }

  void registerActiveEffect(BonusEffect effect) {
    _activeEffects.add(effect);
  }
}
