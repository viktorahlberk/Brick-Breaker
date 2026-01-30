import 'package:flutter/material.dart';

class BulletModel {
  double speed = 5.0;
  double radius = 2.0;
  late Offset position;
  Color color = Colors.white;

  BulletModel(Offset startingPoint) {
    position = startingPoint;
  }

  get bulletRect => Rect.fromCircle(center: position, radius: radius);

  move() {
    position = Offset(position.dx, position.dy - speed);
  }
}
