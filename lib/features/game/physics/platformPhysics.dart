import 'package:bouncer/core/vector2.dart';

class PlatformPhysics {
  final double speed;
  final double screenWidth;
  final double baseWidth;

  PlatformPhysics(
      {required this.speed,
      required this.screenWidth,
      required this.baseWidth});

  Vector2 move(Vector2 position, double velocityX, double dt) {
    double x = (position.x + velocityX * dt)
        .clamp(baseWidth / 2, screenWidth - baseWidth / 2);
    return Vector2(x, position.y);
  }
}

