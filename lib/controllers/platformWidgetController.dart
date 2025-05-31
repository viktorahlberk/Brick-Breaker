import 'package:flutter/material.dart';

class PlatformWidgetController extends ChangeNotifier {
  PlatformWidgetController({required this.screenSize}) {
    // Initialize platform position at bottom center
    x = screenSize.width / 2;
    y = screenSize.height * 0.97; // Near bottom of screen
    width = screenSize.width * 0.2; // 20% of screen width
  }

  // Screen dimensions
  final Size screenSize;

  // Platform properties in actual pixels
  late double x; // Center X position
  late double y; // Y position
  late double width;
  Color color = Colors.green;
  double height = 5.0; // Fixed height in pixels

  // Speed in pixels per movement
  double speed = 7;

  // Get the rect for collision detection
  Rect get platformRect => Rect.fromCenter(
        center: Offset(x, y),
        width: width,
        height: height,
      );

  void moveLeft() {
    // Don't let platform go off screen (accounting for platform width)
    if (x > width / 2) {
      x -= speed;
      notifyListeners();
    }
  }

  void moveRight() {
    // Don't let platform go off screen (accounting for platform width)
    if (x < screenSize.width - width / 2) {
      x += speed;
      notifyListeners();
    }
  }
}
