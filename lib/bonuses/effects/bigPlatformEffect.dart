import 'dart:async';

import 'package:bouncer/bonuses/bonusEffect.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';

class BigPlatformEffect extends BonusEffect {
  final PlatformViewModel platformViewModel;
  final double scale;
  final Duration duration;

  Timer? _timer;

  BigPlatformEffect({
    required this.platformViewModel,
    this.scale = 1.5,
    this.duration = const Duration(seconds: 15),
  });

  @override
  void onApply() {
    if (platformViewModel.scaled) return;

    platformViewModel.setScale(scale);
    platformViewModel.scaled = true;

    _timer = Timer(duration, () {
      onRemove();
    });
  }

  @override
  void onRemove() {
    platformViewModel.normalizeScale();
    platformViewModel.scaled = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onUpdate(double dt) {
    // Здесь можно добавлять анимацию постепенного уменьшения платформы,
    // например плавное возвращение к норме, если хочешь smooth эффект
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
