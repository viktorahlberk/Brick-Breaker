import 'package:flutter/material.dart';

class PlatformModel {
  final Size screenSize;
  // late double x;
  // late double y;
  late Offset position;
  late double width;
  final double height = 5.0;
  final double speed = 4;

  PlatformModel({required this.screenSize}) {
    width = screenSize.width * 0.125;
    position = Offset(screenSize.width / 2, screenSize.height * 0.97);
  }

  Rect get rect =>
      Rect.fromCenter(center: position, width: width, height: height);

  void moveLeft() {
    if (position.dx > width / 2) {
      position = Offset(position.dx - speed, position.dy);
    }
  }

  void moveRight() {
    if (position.dx < screenSize.width - width / 2) {
      position = Offset(position.dx + speed, position.dy);
    }
  }
}
