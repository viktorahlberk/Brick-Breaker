import 'package:bouncer/core/audio_manager.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/scoreManager.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:flutter/material.dart';
import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';

class CollisionManager {
  final BrickViewModel brickViewModel;
  final ParticleSystem particleSystem;
  final GunViewModel gunViewModel;
  final BonusManager bonusManager;
  final BallManager ballManager;
  final ScoreManager scoreManager;

  CollisionManager(
      {required this.brickViewModel,
      required this.particleSystem,
      required this.gunViewModel,
      required this.bonusManager,
      required this.ballManager,
      required this.scoreManager});

  void checkCollisions() {
    final collisions = getCollisions(ballManager, gunViewModel);

    if (collisions.isEmpty) return;

    AudioManager().playCollisionSound();

    final sortedCollisions = collisions
        .where((c) => c.brickIndex != null)
        .toList()
      ..sort((a, b) => b.brickIndex!.compareTo(a.brickIndex!));

    for (final collision in sortedCollisions) {
      if (collision.bulletIndex == null) {
        _handleBallCollision(collision);
      } else {
        _handleBulletCollision(collision);
      }
    }
  }

  void _handleBallCollision(CollisionResult collision) {
    if (collision.brickIndex == null) return;

    final brick = brickViewModel.bricks[collision.brickIndex!];
    _handleBrickHealth(brick, collision);
    _addScore();
    collision.ball!.velocityY = -collision.ball!.velocityY;
  }

  void _handleBulletCollision(CollisionResult collision) {
    if (collision.brickIndex == null || collision.bulletIndex == null) return;

    final brick = brickViewModel.bricks[collision.brickIndex!];
    final bullet = gunViewModel.bulletsList[collision.bulletIndex!];

    gunViewModel.bulletsList.remove(bullet);
    _handleBrickHealth(brick, collision);
    _addScore();
  }

  _handleBrickHealth(BrickModel brick, CollisionResult collision) {
    if (collision.isHardBrick) {
      brick.hp -= collision.power / 3;
    } else {
      brick.hp -= collision.power;
    }

    if (brick.hp <= 0) {
      final brickRect = _getBrickRect(brick);
      _destroyBrick(brick, brickRect.center);
    }
  }

  _addScore() {
    scoreManager.add(BrickType.normal);
  }

  void _destroyBrick(BrickModel brick, Offset center) {
    bonusManager.trySpawnBonus(position: center);
    brickViewModel.bricks.remove(brick);
    particleSystem.addBrickExplosion(center, brick.color);
  }

  Rect _getBrickRect(BrickModel brick) {
    return Rect.fromLTWH(
      (brick.x + 1) * 0.5 * ballManager.screenSize.width,
      (brick.y + 1) * 0.5 * ballManager.screenSize.height,
      brick.width * ballManager.screenSize.width * 0.5,
      brick.height * ballManager.screenSize.height * 0.5,
    );
  }

  List<CollisionResult> getCollisions(
      BallManager ballManager, GunViewModel gunViewModel) {
    List<CollisionResult> results = [];
    for (BallViewModel ball in ballManager.ballPool) {
      for (int brickIndex = 0;
          brickIndex < brickViewModel.bricks.length;
          brickIndex++) {
        final brick = brickViewModel.bricks[brickIndex];
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
              ball: ball,
            ));
          } else {
            results.add(CollisionResult(
              brickIndex: brickIndex,
              destroyed: true,
              isHardBrick: false,
              power: ball.model.power,
              ball: ball,
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
}

Rect _brickToRect(BrickModel model, Size screenSize) {
  final pixelX = (model.x + 1) * 0.5 * screenSize.width;
  final pixelY = (model.y + 1) * 0.5 * screenSize.height;
  final pixelWidth = model.width * screenSize.width * 0.5;
  final pixelHeight = model.height * screenSize.height * 0.5;

  return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
}

class CollisionResult {
  final int? brickIndex; // индекс столкнувшегося кирпича
  final bool destroyed; // кирпич уничтожен или просто повреждён
  final bool isHardBrick;
  final int? bulletIndex; // если столкновение с пулей
  final double power;
  final BallViewModel? ball;

  CollisionResult({
    this.brickIndex,
    this.destroyed = false,
    this.isHardBrick = false,
    this.bulletIndex,
    required this.power,
    this.ball,
  });
}
