import 'dart:async';

import 'package:bouncer/features/bonuses/domain/bonusEffect.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class BigPlatformEffect extends BonusEffect {
  final PlatformViewModel platformViewModel;
  final double scale;
  final Duration duration;
  final Duration blinkDuration = const Duration(seconds: 4);

  Timer? _mainTimer;
  Timer? _blinkTimer;
  bool _isActive = false;

  BigPlatformEffect({
    required this.platformViewModel,
    this.scale = 1.5,
    this.duration = const Duration(seconds: 15),
  });

  @override
  bool get isActive => _isActive;

  void _startBlinking() {
    if (!_isActive) return;
    platformViewModel.setBlinking(true);
  }

  @override
  void onApply() {
    if (_isActive || platformViewModel.scaled) return;

    platformViewModel.setScale(scale);
    _isActive = true;
    _mainTimer = Timer(duration, () {
      onRemove();
    });

    if (duration > blinkDuration) {
      _blinkTimer = Timer(duration - blinkDuration, () {
        _startBlinking();
      });
    } else {
      _startBlinking();
    }
  }

  @override
  void onRemove() {
    if (!_isActive) return;

    _mainTimer?.cancel();
    _blinkTimer?.cancel();
    platformViewModel.setScale(1);
    platformViewModel.setBlinking(false);

    _mainTimer = null;
    _blinkTimer = null;
    _isActive = false;
    onExpired?.call();
  }

  @override
  void onUpdate(double dt) {
    // Здесь можно добавлять анимацию постепенного уменьшения платформы,
    // например плавное возвращение к норме, если хочешь smooth эффект
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    // _blinkTimer?.cancel();
  }
}
