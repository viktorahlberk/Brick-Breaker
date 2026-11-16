import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/levelManager.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates a high-health boss brick every fifth level', () {
    const screenSize = Size(400, 800);
    final brickViewModel = BrickViewModel(screenSize: screenSize);
    final levelManager = LevelManager(
      brickViewModel: brickViewModel,
      ballManager: BallManager(screenSize),
      timeManager: TimeManager(),
      platformViewModel: PlatformViewModel(screenSize),
    )..level = LevelManager.bossEveryLevels;

    levelManager.resetLevel();

    expect(levelManager.isBossLevel, isTrue);
    expect(brickViewModel.bricks, hasLength(1));
    expect(brickViewModel.bricks.single.type, BrickType.strong);
    expect(brickViewModel.bricks.single.hp, LevelManager.bossMaxHp);
    expect(brickViewModel.bricks.single.color, const Color(0xFFE53935));
  });
}
