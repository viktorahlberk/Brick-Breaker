import 'package:bouncer/core/audio_manager.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/scoreManager.dart';
import 'package:flutter/material.dart';
import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
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
    final collisions =
        brickViewModel.checkCollisions(ballManager, gunViewModel);

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
    // ballViewModel.velocityY = -ballViewModel.velocityY;
  }

  void _handleBulletCollision(CollisionResult collision) {
    if (collision.brickIndex == null || collision.bulletIndex == null) return;

    final brick = brickViewModel.bricks[collision.brickIndex!];
    final bullet = gunViewModel.bulletsList[collision.bulletIndex!];
    // final brickRect = _getBrickRect(brick);

    gunViewModel.bulletsList.remove(bullet);

    // if (collision.isHardBrick) {
    //   brick.hp -= collision.power / 3;
    // } else {
    //   brick.hp -= collision.power;
    // }

    // if (brick.hp <= 0) {
    //   _destroyBrick(brick, brickRect.center);
    // }
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
}

// class CollisionResult {
//   final int? brickIndex; // индекс столкнувшегося кирпича
//   final bool destroyed; // кирпич уничтожен или просто повреждён
//   final bool isHardBrick;
//   final int? bulletIndex; // если столкновение с пулей
//   final double power;

//   CollisionResult({
//     this.brickIndex,
//     this.destroyed = false,
//     this.isHardBrick = false,
//     this.bulletIndex,
//     required this.power,
//   });
// }
