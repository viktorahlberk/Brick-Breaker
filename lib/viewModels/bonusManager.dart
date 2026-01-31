import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/models/bonusModel.dart';
import 'package:bouncer/viewModels/bonusViewModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:flutter/cupertino.dart';

class BonusManager {
  final List<BonusViewModel> bonuses = [];

  void spawnBonus({
    required BonusType type,
    required Offset position,
  }) {
    // log('spawned');
    // if (bonuses.contains())
    bonuses.add(
      BonusViewModel(
        BonusModel(
          type: type,
          position: position,
          duration: _durationByType(type),
        ),
      ),
    );
  }

  void update(double dt) {
    for (final bonus in bonuses) {
      bonus.update(dt);
    }
  }

  void checkCollect(
    PlatformViewModel platform,
    void Function(BonusType) onCollected,
  ) {
    for (final bonus in bonuses) {
      if (platform.rect.overlaps(bonus.rect)) {
        // debugPrint('overlap');
        bonus.collected = true;
        onCollected(bonus.model.type);
      }
    }

    bonuses.removeWhere((b) => b.collected);
  }

  Duration? _durationByType(BonusType type) {
    switch (type) {
      case BonusType.gun:
        return Duration(seconds: 10);
      // case BonusType.slowMotion:
      //   return Duration(seconds: 5);
      case BonusType.bigPlatform:
        return Duration(seconds: 8);
    }
  }
}
