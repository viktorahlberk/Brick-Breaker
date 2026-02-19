import 'dart:math';
import 'package:bouncer/core/audio_manager.dart';
import 'package:bouncer/features/game/domain/ballModel.dart';
import 'package:bouncer/core/vector2.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';

class BallViewModel extends ChangeNotifier {
  final Size screenSize;
  final BallPhysics physics;
  final BallModel _model;
  final Offset _startingPosition;
  final audioManager = AudioManager();

  bool _isBelowScreen = false;
  bool get isBelowScreen => _isBelowScreen;

  double velocityX = 0;
  double velocityY = 0;

  BallViewModel({required this.screenSize})
      : _startingPosition =
            Offset(screenSize.width / 2, screenSize.height * 0.89),
        _model = BallModel(
            position: Offset(screenSize.width / 2, screenSize.height * 0.89)),
        physics = BallPhysics();

  BallModel get model => _model;

  Offset get position => _model.position;

  Rect get ballRect =>
      Rect.fromCircle(center: _model.position, radius: _model.radius);

  void moveToPlatformCenter(PlatformViewModel platform) {
    _model.position = Offset(platform.platformCenterX, _model.position.dy);
    notifyListeners();
  }

  void updateAndMove(double dt, PlatformViewModel platform) {
    final wallVelocity = physics.bounceFromWall(
      Vector2(velocityX, velocityY),
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
      radius: _model.radius,
      position: Vector2(_model.position.dx, _model.position.dy),
    );

    velocityX = wallVelocity.x;
    velocityY = wallVelocity.y;

    if (_model.position.dy + _model.radius >= screenSize.height)
      _isBelowScreen = true;

    if (ballRect.overlaps(platform.rect) && velocityY > 0) {
      audioManager.playCollisionSound();
      final bounce = physics.bounceFromPlatform(
        ballX: _model.position.dx,
        platformCenterX: platform.position.x,
        platformWidth: platform.width,
        platformVelocityX: platform.velocityX,
        incomingVelocityX: velocityX,
      );

      velocityX = bounce.x;
      velocityY = bounce.y;
    }

    _moveBall(dt);
    notifyListeners();
  }

  void _moveBall(double dt) {
    _updateBallTrail();

    _model.position = Offset(
      _model.position.dx + velocityX * dt,
      _model.position.dy + velocityY * dt,
    );
  }

  void _updateBallTrail() {
    if (_model.trail.length > 30) _model.trail.removeFirst();
    _model.trail.add(Offset(_model.position.dx, _model.position.dy));
  }

  void launch() {
    const minAngle = -150 * pi / 180;
    const maxAngle = -30 * pi / 180;
    final angle = minAngle + Random().nextDouble() * (maxAngle - minAngle);
    velocityX = physics._speed * cos(angle);
    velocityY = physics._speed * sin(angle);
  }

  void reset() {
    _isBelowScreen = false;
    _model.trail.clear();
    _model.position = _startingPosition;
    velocityX = 0;
    velocityY = 0;
    notifyListeners();
  }
}

class BallPhysics {
  static const double maxBounceAngle = pi / 3;
  static const double platformInfluenceFactor = 0.3;

  final double _speed = 300;

  BallPhysics();

  Vector2 bounceFromPlatform({
    required double ballX,
    required double platformCenterX,
    required double platformWidth,
    required double platformVelocityX,
    required double incomingVelocityX,
  }) {
    final directionX = incomingVelocityX.sign == 0 ? 1 : incomingVelocityX.sign;

    final hitOffset =
        ((ballX - platformCenterX) / (platformWidth / 2)).clamp(-1.0, 1.0);

    final angle = hitOffset * maxBounceAngle;

    var vx = directionX * _speed * sin(angle).abs();
    var vy = -_speed * cos(angle);

    final influence = platformVelocityX * platformInfluenceFactor;
    if (influence.sign == directionX) vx += influence;

    // нормализация скорости
    final length = sqrt(vx * vx + vy * vy);
    vx = vx / length * _speed;
    vy = vy / length * _speed;

    return Vector2(vx, vy);
  }

  Vector2 bounceFromWall(Vector2 velocity,
      {double screenWidth = 0,
      double screenHeight = 0,
      double radius = 0,
      Vector2? position}) {
    double vx = velocity.x;
    double vy = velocity.y;
    final pos = position ?? Vector2(0, 0);

    if (pos.x - radius <= 0 && vx < 0) {
      vx = -vx;
      AudioManager().playCollisionSound();
    }
    if (pos.x + radius >= screenWidth && vx > 0) {
      vx = -vx;
      AudioManager().playCollisionSound();
    }
    if (pos.y - radius <= 0 && vy < 0) {
      vy = -vy;
      AudioManager().playCollisionSound();
    }

    return Vector2(vx, vy);
  }
}
