import 'package:flutter/material.dart';
import 'package:bouncer/models/brickModel.dart';
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
  final BallViewModel ballViewModel;

  CollisionManager({
    required this.brickViewModel,
    required this.particleSystem,
    required this.gunViewModel,
    required this.bonusManager,
    required this.ballViewModel,
  });

  void checkCollisions() {
    final collisions =
        brickViewModel.checkCollisions(ballViewModel, gunViewModel);
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
    final brickRect = _getBrickRect(brick);

    if (collision.isHardBrick) {
      brick.type = BrickType.normal;
      brick.color = Colors.white;
    } else {
      _destroyBrick(brick, brickRect.center);
    }

    ballViewModel.velocityY = -ballViewModel.velocityY;
  }

  void _handleBulletCollision(CollisionResult collision) {
    if (collision.brickIndex == null || collision.bulletIndex == null) return;

    final brick = brickViewModel.bricks[collision.brickIndex!];
    final bullet = gunViewModel.bulletsList[collision.bulletIndex!];
    final brickRect = _getBrickRect(brick);

    gunViewModel.bulletsList.remove(bullet);

    if (collision.isHardBrick) {
      brick.type = BrickType.normal;
      brick.color = Colors.white;
    } else if (collision.destroyed) {
      _destroyBrick(brick, brickRect.center);
    }
  }

  void _destroyBrick(BrickModel brick, Offset center) {
    bonusManager.trySpawnBonus(position: center);
    brickViewModel.bricks.remove(brick);
    particleSystem.addBrickExplosion(center, brick.color);
  }

  Rect _getBrickRect(BrickModel brick) {
    return Rect.fromLTWH(
      (brick.x + 1) * 0.5 * ballViewModel.screenSize.width,
      (brick.y + 1) * 0.5 * ballViewModel.screenSize.height,
      brick.width * ballViewModel.screenSize.width * 0.5,
      brick.height * ballViewModel.screenSize.height * 0.5,
    );
  }
}
