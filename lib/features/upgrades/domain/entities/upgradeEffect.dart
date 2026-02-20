import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/runtimeContext.dart';
import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';

abstract class UpgradeEffect {
  bool get applied;
  void apply(RuntimeContext context);
  // void remove();
}
