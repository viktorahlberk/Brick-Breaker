import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class RuntimeContext {
  final BallViewModel ballViewModel;
  final PlatformViewModel platformViewModel;

  RuntimeContext(this.ballViewModel, this.platformViewModel);
}
