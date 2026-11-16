import 'package:bouncer/features/bonuses/domain/bonusEffect.dart';
import 'package:bouncer/features/bonuses/domain/bonusType.dart';

class ActiveBonus {
  ActiveBonus({
    required this.type,
    required this.effect,
  });

  final BonusType type;
  final BonusEffect effect;
}
