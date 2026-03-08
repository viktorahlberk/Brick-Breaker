import 'package:bouncer/features/game/runtimeContext.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class AddOneBall implements UpgradeEffect {
  @override
  bool get applied => false;

  @override
  void apply(RuntimeContext context) {
    context.ballManager.addBall();
  }
}
