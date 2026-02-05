import 'package:bouncer/models/platformModel.dart';
import 'package:bouncer/vector2.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  final PlatformModel _platformModel;
  final PlatformPhysics _physics;

  Vector2 _position;
  double baseWidth;
  double width;
  double scale = 1;
  bool scaled = false;
  bool isGunActive = false;
  final Size _screensize;

  double velocityX = 0;

  PlatformViewModel(Size screenSize)
      : _screensize = screenSize,
        _platformModel = PlatformModel(),
        baseWidth = screenSize.width * 0.2,
        width = screenSize.width * 0.2,
        _position = Vector2(screenSize.width / 2, screenSize.height * 0.9),
        _physics = PlatformPhysics(
          speed: 600,
          screenWidth: screenSize.width,
          baseWidth: screenSize.width * 0.2,
        );

  double get height => _platformModel.height;
  Vector2 get position => _position;

  Offset get positionOffset => Offset(_position.x, _position.y);

  Rect get rect => Rect.fromCenter(
        center: positionOffset,
        width: width,
        height: height,
      );

  void setInput(double axis) {
    velocityX = axis.clamp(-1.0, 1.0) * _physics.speed;
  }

  void update(double dt) {
    _position = _physics.move(_position, velocityX, dt);
    notifyListeners();
  }

  void moveCenterTo(double? targetX, double dt) {
    if (targetX == null) return;

    final delta = targetX - _position.x;
    if (delta.abs() < 1) return;

    final step = _physics.speed * dt;
    final move = delta.clamp(-step, step);

    _position = Vector2(_position.x + move, _position.y);
    notifyListeners();
  }

  void setScale(double value) {
    scale = value;
    width = baseWidth * value;
  }

  void normalizeScale() {
    scale = 1;
    width = baseWidth;
    scaled = false;
  }

  void reset() {
    _position = Vector2(_screensize.width / 2, _screensize.height * 0.9);
    velocityX = 0;
    notifyListeners();
  }
}

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
