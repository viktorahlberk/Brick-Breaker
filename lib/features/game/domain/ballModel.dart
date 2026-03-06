import 'dart:collection';
import 'dart:ui';

class BallModel {
  Offset position;
  double radius;
  Queue<Offset> trail;
  double power = 100;
  // int index =

  BallModel({
    required this.position,
    this.radius = 5.0,
    Queue<Offset>? trail,
  }) : trail = trail ?? Queue<Offset>();
}
