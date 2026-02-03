import 'dart:async';

import 'package:bouncer/bonuses/bonusEffect.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';

class PlatformGunEffect extends BonusEffect {
  PlatformViewModel platformViewModel;
  Timer? _timer;

  Duration duration;

  PlatformGunEffect({
    required this.platformViewModel,
    this.duration = const Duration(seconds: 7),
  });

  @override
  void onApply() {
    platformViewModel.isGunActive = true;
    _timer = Timer(duration, () {
      onRemove();
    });
  }

  @override
  void onRemove() {
    platformViewModel.isGunActive = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onUpdate(double dt) {
    // TODO: implement onUpdate
  }
  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
