import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class IncreasePlatformSizeEffect implements UpgradeEffect {
  final double multiplier;
  @override
  bool applied = false;
  IncreasePlatformSizeEffect(this.multiplier);

  @override
  void apply(context) {
    context.platformViewModel.width +=
        (context.platformViewModel.baseWidth * multiplier);
  }
}
