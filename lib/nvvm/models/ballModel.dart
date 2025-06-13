import 'dart:collection';
import 'dart:ui';

class BallModel {
  Offset position;
  double radius;
  Queue<Offset> trail;

  BallModel({
    required this.position,
    this.radius = 15.0,
    Queue<Offset>? trail,
  }) : trail = trail ?? Queue<Offset>();
}
