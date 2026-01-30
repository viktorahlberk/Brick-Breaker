import 'dart:math';
import 'package:bouncer/models/ballModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';

enum BallDirection { up, down, left, right }

class BallViewModel extends ChangeNotifier {
  final Size screenSize;
  final BallModel _model;
  final Offset _startingPosition;

  double velocityX = 0.1;
  double velocityY = 0.1;
  double speed = 100; // px/sec
  bool _isBelowScreen = false;
  bool get isBelowScreen => _isBelowScreen;

  BallViewModel({required this.screenSize})
      : _startingPosition =
            Offset(screenSize.width / 2, screenSize.height * 0.95),
        _model = BallModel(
            position: Offset(screenSize.width / 2, screenSize.height * 0.95));

  BallModel get model => _model;
  get ballRect => Rect.fromCircle(
        center: _model.position,
        radius: _model.radius,
      );

  void _moveBall(double dt) {
    _updateBallTrail();

    _model.position = Offset(
      _model.position.dx + velocityX * dt,
      _model.position.dy + velocityY * dt,
    );

    debugPrint(model.position.toString());
  }

  void _handleWallCollision() {
    if (_model.position.dx - _model.radius <= 0 && velocityX < 0) {
      velocityX = -velocityX;
    }

    if (_model.position.dx + _model.radius >= screenSize.width &&
        velocityX > 0) {
      velocityX = -velocityX;
    }

    if (_model.position.dy - _model.radius <= 0 && velocityY < 0) {
      velocityY = -velocityY;
    }

    if (_model.position.dy + _model.radius >= screenSize.height) {
      _isBelowScreen = true;
    }
  }

  void updateAndMove(double dt, PlatformViewModel platform) {
    _handleWallCollision();

    if (ballRect.overlaps(platform.rect) && velocityY > 0) {
      _bounceFromPlatform(
        ballX: _model.position.dx,
        platformX: platform.position.dx,
        platformWidth: platform.width,
        platformVelocityX: platform.velocityX,
      );
    }
    _moveBall(dt);
    notifyListeners();
  }

  void _bounceFromPlatform({
    required double ballX,
    required double platformX,
    required double platformWidth,
    required double platformVelocityX,
  }) {
    const maxBounceAngle = pi / 3; // 60°
    const double minVerticalSpeed = 150;

    final hitOffset =
        ((ballX - platformX) / (platformWidth / 2)).clamp(-1.0, 1.0);

    final angle = hitOffset * maxBounceAngle;

    velocityX = speed * sin(angle);
    velocityY = -speed * cos(angle);

    // влияние движения платформы
    velocityX += platformVelocityX * 0.3;

    // защита от горизонтального полёта
    if (velocityY.abs() < minVerticalSpeed) {
      velocityY = -minVerticalSpeed;
    }
  }

  void _updateBallTrail() {
    if (_model.trail.length > 30) {
      _model.trail.removeFirst();
    }
    _model.trail.add(_model.position);
  }

  void reset() {
    _isBelowScreen = false;
    _model.trail.clear();
    _model.position = _startingPosition;
    notifyListeners();
  }
}
