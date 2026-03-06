import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class RuntimeContext {
  final BallManager ballManager;
  final PlatformViewModel platformViewModel;

  RuntimeContext(this.ballManager, this.platformViewModel);
}
