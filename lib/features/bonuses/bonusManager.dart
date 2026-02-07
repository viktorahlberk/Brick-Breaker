import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:bouncer/features/bonuses/domain/bonusEffect.dart';
import 'package:bouncer/features/bonuses/domain/bonusModel.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusPickupVmModel.dart';
import 'package:bouncer/features/bonuses/domain/bonusType.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/cupertino.dart';

class BonusManager {
  final pickups = <BonusPickupViewModel>[];
  final _activeEffects = <BonusEffect>[];
  final double _bonusSpawnChanceProcent = 10;

  void trySpawnBonus({
    required Offset position,
  }) {
    // debugPrint('trySpawnBonus');
    if (Random().nextDouble() < _bonusSpawnChanceProcent / 100) {
      if (Random().nextDouble() < 0.5) {
        pickups.add(
          BonusPickupViewModel(
            model: BonusModel(
                type: BonusType.bigPlatform,
                duration: Duration(seconds: 10),
                position: position),
          ),
        );
      } else {
        pickups.add(
          BonusPickupViewModel(
            model: BonusModel(
                type: BonusType.platformGun,
                duration: Duration(seconds: 10),
                position: position),
          ),
        );
      }
    }
  }

  void update(double dt) {
    if (pickups.isNotEmpty) {
      for (var pickupBonus in pickups) {
        pickupBonus.update(dt);
      }
    }
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

  void reset() {
    for (final effect in _activeEffects) {
      effect.onRemove();
    }
    _activeEffects.clear();
    pickups.clear();
  }
}
