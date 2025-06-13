import 'package:bouncer/nvvm/models/brickModel.dart';
import 'package:bouncer/nvvm/viewModels/ballViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';

class BrickViewModel extends ChangeNotifier {
  final List<BrickModel> _bricks = [];
  final ParticleSystem particleSystem;

  BrickViewModel({required this.particleSystem});

  List<BrickModel> get bricks => List.unmodifiable(_bricks);

  // Константы размещения
  static const int bricksPerRow = 4;
  static const double brickWidth = 0.4;
  static const double brickHeight = 0.09;
  static const double brickGap = 0.01;
  static const double startY = -0.9;

  static double get wallGap =>
      0.5 * (2 - bricksPerRow * brickWidth - (bricksPerRow - 1) * brickGap);

  void restoreBricks() {
    _bricks.clear();
    double x = -1 + wallGap;

    for (int i = 0; i < bricksPerRow; i++) {
      _bricks.add(BrickModel(
        x: x + i * (brickWidth + brickGap),
        y: startY,
        width: brickWidth,
        height: brickHeight,
        color: _colorByIndex(i),
      ));
    }

    notifyListeners();
  }

  void checkCollision(BallViewModel ball) {
    for (int i = 0; i < _bricks.length; i++) {
      final brick = _bricks[i];
      final brickRect = _brickToRect(brick, ball.screenSize);
      final ballRect = ball.ballRect;

      if (ballRect.overlaps(brickRect)) {
        final removedBrick = _bricks.removeAt(i);
        _explodeBrick(brickRect, removedBrick.color);
        _invertBallY(ball);
        notifyListeners();
        break;
      }
    }
  }

  void _invertBallY(BallViewModel ball) {
    ball.yDirection = ball.yDirection == BallDirection.down
        ? BallDirection.up
        : BallDirection.down;
  }

  void _explodeBrick(Rect brickRect, Color color) {
    final center = Offset(
      brickRect.left + brickRect.width / 2,
      brickRect.top + brickRect.height / 2,
    );
    particleSystem.addBrickExplosion(center, color);
  }

  Rect _brickToRect(BrickModel model, Size screenSize) {
    final pixelX = (model.x + 1) * 0.5 * screenSize.width;
    final pixelY = (model.y + 1) * 0.5 * screenSize.height;
    final pixelWidth = model.width * screenSize.width * 0.5;
    final pixelHeight = model.height * screenSize.height * 0.5;

    return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
  }

  Color _colorByIndex(int i) {
    switch (i % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
      default:
        return Colors.white;
    }
  }

  bool get isEmpty => _bricks.isEmpty;
}
