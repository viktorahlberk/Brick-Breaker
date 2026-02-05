import 'dart:async';

import 'package:bouncer/bonuses/bonusEffect.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';

class BigPlatformEffect extends BonusEffect {
  final PlatformViewModel platformViewModel;
  final double scale;
  final Duration duration;
  final Duration blinkDuration = const Duration(seconds: 4);

  Timer? _mainTimer;
  Timer? _blinkTimer;

  BigPlatformEffect({
    required this.platformViewModel,
    this.scale = 1.5,
    this.duration = const Duration(seconds: 15),
  });

  void _startBlinking() {
    platformViewModel.isBlinking = true;
  }

  @override
  void onApply() {
    if (platformViewModel.scaled) return;

    platformViewModel.setScale(scale);
    platformViewModel.scaled = true;
    _mainTimer = Timer(duration, () {
      onRemove();
    });

    if (duration > blinkDuration) {
      Timer(duration - blinkDuration, () {
        _startBlinking();
      });
    } else {
      _startBlinking();
    }
  }

  @override
  void onRemove() {
    _mainTimer?.cancel();
    _blinkTimer?.cancel();
    platformViewModel.normalizeScale();
    platformViewModel.isBlinking = false;
    // platformViewModel.scaled = false;
    // platformViewModel.isBlinking = false;
    // platformViewModel.blinkVisible = true;
    // platformViewModel.notifyListeners();

    _mainTimer = null;
    // _blinkTimer = null;
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
