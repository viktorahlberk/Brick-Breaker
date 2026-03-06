// import 'dart:developer';
// import 'dart:math' as math;

import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
// import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:flutter/material.dart';

class BrickViewModel extends ChangeNotifier {
  List<BrickModel> _bricks = [];
  Size screenSize;

  BrickViewModel({required this.screenSize});

  List<BrickModel> get bricks => _bricks;
  bool get isEmpty => _bricks.isEmpty;

  void setBricks(List<BrickModel> bricks) {
    _bricks = bricks;
  }

  List<CollisionResult> checkCollisions(
      BallManager ballManager, GunViewModel gunViewModel) {
    List<CollisionResult> results = [];
    for (BallViewModel ball in ballManager.ballPool) {
      for (int brickIndex = 0; brickIndex < _bricks.length; brickIndex++) {
        final brick = _bricks[brickIndex];
        final brickRect = _brickToRect(brick, ball.screenSize);
        final ballRect = ball.ballRect;

        // === Collision with ball ===
        if (ballRect.overlaps(brickRect)) {
          if (brick.type == BrickType.strong) {
            results.add(CollisionResult(
              brickIndex: brickIndex,
              destroyed: false,
              isHardBrick: true,
              power: ball.model.power,
            ));
          } else {
            results.add(CollisionResult(
              brickIndex: brickIndex,
              destroyed: true,
              isHardBrick: false,
              power: ball.model.power,
            ));
          }
        }

        // === Collision with bullets ===
        for (int bulletIndex = 0;
            bulletIndex < gunViewModel.bulletsList.length;
            bulletIndex++) {
          final bullet = gunViewModel.bulletsList[bulletIndex];
          if (bullet.bulletRect.overlaps(brickRect)) {
            if (brick.type == BrickType.strong) {
              results.add(CollisionResult(
                brickIndex: brickIndex,
                destroyed: false,
                isHardBrick: true,
                bulletIndex: bulletIndex,
                power: 20,
              ));
            } else {
              results.add(CollisionResult(
                brickIndex: brickIndex,
                destroyed: true,
                isHardBrick: false,
                bulletIndex: bulletIndex,
                power: 20,
              ));
            }
          }
        }
      }
    }

    return results;
  }

  Rect _brickToRect(BrickModel model, Size screenSize) {
    final pixelX = (model.x + 1) * 0.5 * screenSize.width;
    final pixelY = (model.y + 1) * 0.5 * screenSize.height;
    final pixelWidth = model.width * screenSize.width * 0.5;
    final pixelHeight = model.height * screenSize.height * 0.5;

    return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
  }
}

class CollisionResult {
  final int? brickIndex; // индекс столкнувшегося кирпича
  final bool destroyed; // кирпич уничтожен или просто повреждён
  final bool isHardBrick;
  final int? bulletIndex; // если столкновение с пулей
  final double power;

  CollisionResult({
    this.brickIndex,
    this.destroyed = false,
    this.isHardBrick = false,
    this.bulletIndex,
    required this.power,
  });
}
