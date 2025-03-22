import 'package:flutter/material.dart';

class PlatformWidgetController extends ChangeNotifier {
  PlatformWidgetController({
    required this.screenWidth,
    required this.screenHeight,
  }) {
    // Initialize platform position at bottom center
    x = screenWidth / 2;
    y = screenHeight * 0.97; // Near bottom of screen
    platformWidth = screenWidth * 0.2; // 20% of screen width
  }
  
  // Screen dimensions
  final double screenWidth;
  final double screenHeight;
  
  // Platform properties in actual pixels
  late double x; // Center X position
  late double y; // Y position 
  late double platformWidth;
  double platformHeight = 5.0; // Fixed height in pixels
  
  // Speed in pixels per movement
  double speed = 10.0;

  // Get the rect for collision detection
  Rect get platformRect => Rect.fromCenter(
    center: Offset(x, y),
    width: platformWidth,
    height: platformHeight,
  );

  void moveLeft() {
    // Don't let platform go off screen (accounting for platform width)
    if (x > platformWidth / 2) {
      x -= speed;
      notifyListeners();
    }
  }

  void moveRight() {
    // Don't let platform go off screen (accounting for platform width)
    if (x < screenWidth - platformWidth / 2) {
      x += speed;
      notifyListeners();
    }
  }
}