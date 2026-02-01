import 'dart:ui';

import 'package:bouncer/bonuses/bonusType.dart';

class BonusModel {
  BonusModel({
    required this.type,
    required this.duration,
    required this.position,
  });
  final BonusType type;
  final Duration duration;
  Offset position;
}
