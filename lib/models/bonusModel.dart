import 'dart:ui';

enum BonusType {
  gun,
  // slowMotion,
  bigPlatform,
}

class BonusModel {
  final BonusType type;
  Offset position;
  final double fallSpeed;
  final Duration? duration; // null = моментальный

  BonusModel({
    required this.type,
    required this.position,
    this.fallSpeed = 100,
    this.duration,
  });
}
