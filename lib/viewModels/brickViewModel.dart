import 'dart:developer';
import 'dart:math';
import 'dart:math' as math;

import 'package:bouncer/models/brickModel.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';

class BrickViewModel extends ChangeNotifier {
  final List<BrickModel> _bricks = [];
  final ParticleSystem particleSystem;

  BrickViewModel({required this.particleSystem}) {
    // createBricks();
  }

  List<BrickModel> get bricks {
    if (_bricks.isEmpty) {
      createBricks();
    }
    return _bricks;
  }

  // Константы размещения
  static const int bricksQuantity = 50;
  static const int maxBricksPerRow = 7;
  static const double brickWidth = 0.23;
  static const double brickHeight = 0.09;
  static const double brickGap = 0.01;
  static const double sideMargin = 0.1;
  static const double availableSpace = 2;

  void createBricks() {
    // _bricks.clear();

    if (bricksQuantity <= 0) return;

    // Определяем количество рядов и колонок
    final int rows = (bricksQuantity / maxBricksPerRow).ceil();

    int bricksCreated = 0;

    for (int row = 0; row < rows && bricksCreated < bricksQuantity; row++) {
      // Сколько кирпичей в этом ряду
      final int bricksInThisRow =
          math.min(maxBricksPerRow, bricksQuantity - bricksCreated);

      // Y позиция ряда
      double y = -0.9 + row * (brickHeight + brickGap * 3);

      // Центрируем ряд
      final double totalRowWidth =
          bricksInThisRow * brickWidth + (bricksInThisRow - 1) * brickGap;
      final double startX = -totalRowWidth / 2;

      for (int col = 0; col < bricksInThisRow; col++) {
        double x = startX + col * (brickWidth + brickGap);

        _bricks.add(BrickModel(
          x: x,
          y: y,
          width: brickWidth,
          height: brickHeight,
          color: _randomColor(),
        ));

        bricksCreated++;
      }
    }

    print('Created $bricksCreated bricks in $rows rows');
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

  Color _randomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  bool get isEmpty => _bricks.isEmpty;
}
