import 'dart:ui';

import 'package:bouncer/features/bonuses/bonusType.dart';

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

