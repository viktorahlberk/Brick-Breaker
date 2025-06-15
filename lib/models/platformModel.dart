import 'package:flutter/material.dart';

class PlatformModel {
  final Size screenSize;
  late double x;
  late double y;
  late double width;
  final double height = 5.0;
  final double speed = 7;

  PlatformModel({required this.screenSize}) {
    x = screenSize.width / 2;
    y = screenSize.height * 0.97;
    width = screenSize.width * 0.125;
  }

  Rect get rect =>
      Rect.fromCenter(center: Offset(x, y), width: width, height: height);

  void moveLeft() {
    if (x > width / 2) x -= speed;
  }

  void moveRight() {
    if (x < screenSize.width - width / 2) x += speed;
  }
}
