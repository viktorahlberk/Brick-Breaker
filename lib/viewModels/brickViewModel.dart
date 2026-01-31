import 'dart:math' as math;

import 'package:bouncer/models/brickModel.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:bouncer/viewModels/gunViewModel.dart';
import 'package:flutter/material.dart';

class BrickViewModel extends ChangeNotifier {
  final List<BrickModel> _bricks = [];
  final ParticleSystem particleSystem;

  BrickViewModel({required this.particleSystem}) {
    initLevel();
  }
  List<BrickModel> get bricks => _bricks;

  // Константы размещения
  static const int bricksQuantity = 23;
  static const int maxBricksPerRow = 7;
  static const double brickWidth = 0.23;
  static const double brickHeight = 0.09;
  static const double brickGap = 0.01;
  static const double sideMargin = 0.1;
  static const double availableSpace = 2;

  void initLevel() {
    _bricks.clear();
    createBricks();
    notifyListeners();
  }

  void createBricks() {
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
          // color: _randomColor(),
          type: col % 2 == 0 ? BrickType.normal : BrickType.hard,
        ));

        bricksCreated++;
      }
    }

    print('Created $bricksCreated bricks in $rows rows');
  }

  List<CollisionResult> checkCollision(
      BallViewModel ball, GunViewModel gunViewModel) {
    List<CollisionResult> results = [];
    // for (int brickIndex = 0; brickIndex < _bricks.length; brickIndex++) {
    //   final brick = _bricks[brickIndex];
    //   final brickRect = _brickToRect(brick, ball.screenSize);
    //   final ballRect = ball.ballRect;

    //   if (ballRect.overlaps(brickRect)) {
    //     if (brick.type == BrickType.hard) {
    //       _explodeBrick(brickRect, brick.color);
    //       _bricks[brickIndex].type = BrickType.normal;
    //       _bricks[brickIndex].color = Colors.white;
    //       // _invertBallY(ball);
    //       notifyListeners();
    //       break;
    //     } else {
    //       final removedBrick = _bricks.removeAt(brickIndex);
    //       _explodeBrick(brickRect, removedBrick.color);
    //       _invertBallY(ball);
    //       notifyListeners();
    //       break;
    //     }
    //   }

    //   ///Checking for bullets collide with bricks.
    //   for (int i = 0; i < gunViewModel.bulletsList.length; i++) {
    //     if (gunViewModel.bulletsList[i].bulletRect.overlaps(brickRect)) {
    //       if (brick.type == BrickType.hard) {
    //         gunViewModel.bulletsList.removeAt(i);
    //         _explodeBrick(brickRect, brick.color);
    //         _bricks[brickIndex].type = BrickType.normal;
    //         _bricks[brickIndex].color = Colors.white;
    //         notifyListeners();
    //         break;
    //       } else {
    //         final removedBrick = _bricks.removeAt(brickIndex);
    //         gunViewModel.bulletsList.removeAt(i);
    //         _explodeBrick(brickRect, removedBrick.color);
    //         notifyListeners();
    //         break;
    //       }
    //     }
    //   }
    // }
    for (int brickIndex = 0; brickIndex < _bricks.length; brickIndex++) {
      final brick = _bricks[brickIndex];
      final brickRect = _brickToRect(brick, ball.screenSize);
      final ballRect = ball.ballRect;

      // === Collision with ball ===
      if (ballRect.overlaps(brickRect)) {
        if (brick.type == BrickType.hard) {
          results.add(CollisionResult(
            brickIndex: brickIndex,
            destroyed: false,
            isHardBrick: true,
          ));
        } else {
          results.add(CollisionResult(
            brickIndex: brickIndex,
            destroyed: true,
            isHardBrick: false,
          ));
        }
        // НЕ делаем break, проверяем другие кирпичи
      }

      // === Collision with bullets ===
      for (int bulletIndex = 0;
          bulletIndex < gunViewModel.bulletsList.length;
          bulletIndex++) {
        final bullet = gunViewModel.bulletsList[bulletIndex];
        if (bullet.bulletRect.overlaps(brickRect)) {
          if (brick.type == BrickType.hard) {
            results.add(CollisionResult(
              brickIndex: brickIndex,
              destroyed: false,
              isHardBrick: true,
              bulletIndex: bulletIndex,
            ));
          } else {
            results.add(CollisionResult(
              brickIndex: brickIndex,
              destroyed: true,
              isHardBrick: false,
              bulletIndex: bulletIndex,
            ));
          }
        }
      }
    }
    return results;
  }

  // void _invertBallY(BallViewModel ball) {
  //   ball.velocityY = -ball.velocityY;
  // }

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

  // Color _randomColor() {
  //   Random random = Random();
  //   return Color.fromARGB(
  //     255,
  //     random.nextInt(256),
  //     random.nextInt(256),
  //     random.nextInt(256),
  //   );
  // }

  bool get isEmpty => _bricks.isEmpty;
}

class CollisionResult {
  final int? brickIndex; // индекс столкнувшегося кирпича
  final bool destroyed; // кирпич уничтожен или просто повреждён
  final bool isHardBrick;
  final int? bulletIndex; // если столкновение с пулей

  CollisionResult({
    this.brickIndex,
    this.destroyed = false,
    this.isHardBrick = false,
    this.bulletIndex,
  });
}
