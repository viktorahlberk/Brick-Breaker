import 'package:bouncer/features/bonuses/bonusEffect.dart';

class ActiveBonus {
  ActiveBonus({
    required this.effect,
    required double duration,
  }) : _remaining = duration;

  final BonusEffect effect;
  double _remaining;

  double get remaining => _remaining;

  bool get isExpired => _remaining <= 0;

  void update(double dt) {
    if (isExpired) return;
    _remaining -= dt;
    // effect.onApply();
  }
}

