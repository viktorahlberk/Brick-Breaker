import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/bonuses/domain/bonusType.dart';
import 'package:bouncer/features/bonuses/domain/effects/bigPlatformEffect.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('active bonus is removed and its effect is reverted on expiry',
      () async {
    final platform = PlatformViewModel(const Size(400, 800));
    final bonusManager = BonusManager();
    final effect = BigPlatformEffect(
      platformViewModel: platform,
      duration: const Duration(milliseconds: 10),
    );

    effect.onApply();
    bonusManager.registerActiveEffect(BonusType.bigPlatform, effect);

    expect(platform.scaled, isTrue);
    expect(bonusManager.activeBonuses, hasLength(1));
    expect(bonusManager.activeBonuses.single.type, BonusType.bigPlatform);

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(platform.scaled, isFalse);
    expect(platform.width, platform.baseWidth);
    expect(bonusManager.activeBonuses, isEmpty);
  });
}
