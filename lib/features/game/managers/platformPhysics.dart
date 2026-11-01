import 'package:bouncer/core/vector2.dart';

class PlatformPhysics {
  final double speed;
  final double screenWidth;

  PlatformPhysics({required this.speed, required this.screenWidth});

  Vector2 move(
    Vector2 position,
    double velocityX,
    double dt, {
    required double platformWidth,
  }) {
    final x = (position.x + velocityX * dt)
        .clamp(platformWidth / 2, screenWidth - platformWidth / 2)
        .toDouble();
    return Vector2(x, position.y);
  }
}
