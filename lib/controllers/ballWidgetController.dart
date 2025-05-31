import 'package:flutter/widgets.dart';
import 'package:bouncer/controllers/platformWidgetController.dart';

enum BallDirection { UP, DOWN, LEFT, RIGHT }

class BallWidgetController with ChangeNotifier {
  BallWidgetController({required this.screenSize}) {
    // Initialize ball position
    x = screenSize.width * 0.5;
    y = screenSize.height * 0.5;
  }

  List<Offset> lastBallPositions = [];

  // Screen dimensions
  final Size screenSize;

  // Ball properties in actual pixels
  late double x; // x-position of center
  late double y; // y-position of center
  double radius = 15.0;

  // Movement properties
  BallDirection xDirection = BallDirection.LEFT;
  BallDirection yDirection = BallDirection.DOWN;
  double speed = 2.0; // pixels per update

  // Collision detection
  Rect get ballRect => Rect.fromCircle(
        center: Offset(x, y),
        radius: radius,
      );

  void updateBallDirection(PlatformWidgetController platform) {
    // Check screen boundaries
    if (y - radius <= 0) {
      yDirection = BallDirection.DOWN;
    }

    if (x - radius <= 0) {
      xDirection = BallDirection.RIGHT;
    }

    if (x + radius >= screenSize.width) {
      xDirection = BallDirection.LEFT;
    }

    // Check platform collision
    if (yDirection == BallDirection.DOWN) {
      bool isColliding = ballRect.overlaps(platform.platformRect);

      if (isColliding) {
        yDirection = BallDirection.UP;

        // Optional: change x direction based on where ball hits platform
        // If ball hits left side of platform, go left, otherwise go right
        // double hitPosition = (x - platform.x) / (platform.width / 2);
        // if (hitPosition < 0) {
        //   xDirection = BallDirection.LEFT;
        // } else {
        //   xDirection = BallDirection.RIGHT;
        // }
      }
    }

    notifyListeners();
  }

  void moveBall() {
    lastBallPositions.add(Offset(x, y));
    if (lastBallPositions.length > 10) {
      lastBallPositions.removeAt(0);
    }
    // Update x position
    if (xDirection == BallDirection.LEFT) {
      x -= speed;
    } else {
      x += speed;
    }

    // Update y position
    if (yDirection == BallDirection.DOWN) {
      y += speed;
    } else {
      y -= speed;
    }

    notifyListeners();
  }

  void reset() {
    x = screenSize.width * 0.5;
    y = screenSize.height * 0.5;
    yDirection = BallDirection.DOWN;
    notifyListeners();
  }
}
