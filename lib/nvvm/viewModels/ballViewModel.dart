// view_models/ball_view_model.dart
import 'package:bouncer/nvvm/models/ballModel.dart';
import 'package:bouncer/nvvm/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';

enum BallDirection { up, down, left, right }

class BallViewModel extends ChangeNotifier {
  final Size screenSize;
  final BallModel _model;

  BallDirection xDirection = BallDirection.left;
  BallDirection yDirection = BallDirection.down;
  double speed = 2.0;
  bool _isBelowScreen = false;
  bool get isBelowScreen => _isBelowScreen;

  BallViewModel({required this.screenSize})
      : _model = BallModel(
            position: Offset(screenSize.width / 2, screenSize.height / 2));

  BallModel get model => _model;
  get ballRect => Rect.fromCircle(
        center: _model.position,
        radius: _model.radius,
      );

  void updateBallDirection(PlatformViewModel platform) {
    if (_model.position.dy - _model.radius <= 0) {
      yDirection = BallDirection.down;
    }
    if (_model.position.dx - _model.radius <= 0) {
      xDirection = BallDirection.right;
    }

    if (_model.position.dx + _model.radius >= screenSize.width) {
      xDirection = BallDirection.left;
    }

    if (yDirection == BallDirection.down) {
      bool isColliding = ballRect.overlaps(platform.rect);
      if (isColliding) {
        yDirection = BallDirection.up;
      }
    }
    if (_model.position.dy + _model.radius >= screenSize.height) {
      _isBelowScreen = true;
      // print(_isBelowScreen);
    }
  }

  void moveBall() {
    if (_model.trail.length > 30) {
      _model.trail.removeFirst();
    }
    _model.trail.add(_model.position);

    double dx = xDirection == BallDirection.left ? -speed : speed;
    double dy = yDirection == BallDirection.up ? -speed : speed;

    _model.position = Offset(_model.position.dx + dx, _model.position.dy + dy);
  }

  void updateAndMove(PlatformViewModel platform) {
    updateBallDirection(platform);
    moveBall();
    notifyListeners();
  }

  void reset() {
    _isBelowScreen = false;
    _model.trail.clear();
    _model.position = Offset(screenSize.width / 2, screenSize.height / 2);
    yDirection = BallDirection.down;
    notifyListeners();
  }
}
