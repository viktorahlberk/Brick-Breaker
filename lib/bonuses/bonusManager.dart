import 'dart:developer';
import 'dart:math';
import 'dart:ui';

// import 'package:bouncer/bonus_pickup_vm.dart';
import 'package:bouncer/bonuses/activeBonus.dart';
import 'package:bouncer/bonuses/bonusModel.dart';
import 'package:bouncer/bonuses/bonusPickupVmModel.dart';
import 'package:bouncer/bonuses/bonusType.dart';
import 'package:flutter/cupertino.dart';

class BonusManager {
  final pickups = <BonusPickupViewModel>[];
  final _activeBonuses = <ActiveBonus>[];

  void trySpawnBonus({
    required Offset position,
  }) {
    debugPrint('trySpawnBonus');
    if (Random().nextDouble() < 0.8) {
      pickups.add(
        BonusPickupViewModel(
          model: BonusModel(
              type: BonusType.bigPlatform,
              duration: Duration(seconds: 10),
              position: position),
        ),
      );
    }
    debugPrint(pickups.toString());
  }

  void update(double dt) {
    if (pickups.isNotEmpty) {
      for (var b in pickups) {
        b.update(dt);
        // notifyListeners();
      }
    }
  }

  // void checkCollect(
  //   PlatformViewModel platform,
  //   void Function(BonusType) onCollected,
  // ) {
  //   for (final bonus in bonuses) {
  //     if (platform.rect.overlaps(bonus.rect)) {
  //       // debugPrint('overlap');
  //       bonus.collected = true;
  //       onCollected(bonus.model.type);
  //     }
  //   }

  //   bonuses.removeWhere((b) => b.collected);
  // }

  // Duration? _durationByType(BonusType type) {
  //   switch (type) {
  //     case BonusType.gun:
  //       return Duration(seconds: 10);
  //     // case BonusType.slowMotion:
  //     //   return Duration(seconds: 5);
  //     case BonusType.bigPlatform:
  //       return Duration(seconds: 8);
  //   }
  // }
}
