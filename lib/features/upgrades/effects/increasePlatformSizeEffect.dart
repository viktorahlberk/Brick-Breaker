import 'package:bouncer/features/game/runtimeContext.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class IncreasePlatformSizeEffect implements UpgradeEffect {
  final double multiplier;
  @override
  bool applied = false;
  IncreasePlatformSizeEffect(this.multiplier);

  @override
  void apply(RuntimeContext context) {
    final platform = context.platformViewModel;
    platform.increaseWidth(platform.baseWidth * multiplier);
    applied = true;
  }
}
