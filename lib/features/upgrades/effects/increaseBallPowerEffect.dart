import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/runtimeContext.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';

class IncreaseBallPowerEffect implements UpgradeEffect {
  @override
  // TODO: implement applied
  bool get applied => throw UnimplementedError();

  @override
  void apply(RuntimeContext context) {
    context.ballViewModel.model.power += 20;
  }

  // @override
  // void remove() {
  //   // TODO: implement remove
  // }
}
