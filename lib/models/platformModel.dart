import 'package:flutter/material.dart';

class PlatformModel {
  final Size screenSize;
  late Offset position;
  late double width;
  final double height = 5.0;
  final double speed = 4;

  PlatformModel({required this.screenSize}) {
    width = screenSize.width * 0.2;
    position = Offset(screenSize.width / 2, screenSize.height * 0.9);
  }

  Rect get rect =>
      Rect.fromCenter(center: position, width: width, height: height);

  double get initialWidth => screenSize.width * 0.125;
}
