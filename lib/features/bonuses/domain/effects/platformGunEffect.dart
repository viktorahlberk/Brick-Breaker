import 'dart:async';

import 'package:bouncer/features/bonuses/domain/bonusEffect.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class PlatformGunEffect extends BonusEffect {
  PlatformViewModel platformViewModel;
  Timer? _timer;

  Duration duration;

  bool _isActive = false;

  PlatformGunEffect({
    required this.platformViewModel,
    this.duration = const Duration(seconds: 7),
  });

  @override
  bool get isActive => _isActive;

  @override
  void onApply() {
    if (_isActive || platformViewModel.isGunActive) return;

    _isActive = true;
    platformViewModel.setGunActive(true);
    _timer = Timer(duration, () {
      onRemove();
    });
  }

  @override
  void onRemove() {
    if (!_isActive) return;

    _timer?.cancel();
    _timer = null;
    _isActive = false;
    platformViewModel.setGunActive(false);
    onExpired?.call();
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
