import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/levelGenerator.dart';
// import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class LevelManager {
  static const int bossEveryLevels = 5;
  static const double bossMaxHp = 600;

  final BrickViewModel brickViewModel;
  final BallManager ballManager;
  final TimeManager timeManager;
  final PlatformViewModel platformViewModel;

  LevelManager(
      {required this.brickViewModel,
      required this.ballManager,
      required this.timeManager,
      required this.platformViewModel});

  bool get isBossLevel => level % bossEveryLevels == 0;
  bool _levelCompletionScheduled = false;
  int level = 1;

  void resetLevel() {
    ballManager.resetAllBalls(platformViewModel);
    if (isBossLevel) {
      _generateBossBrick();
    } else {
      _generateBricks();
    }
    _levelCompletionScheduled = false;
  }

  void checkLevelCompletion(VoidCallback onLevelCompleted) {
    if (_levelCompletionScheduled) return;
    if (brickViewModel.isEmpty) {
      _levelCompletionScheduled = true;
      timeManager.slowMotion(0.3, milliseconds: 5000);
      Future.delayed(Duration(seconds: 3), onLevelCompleted);
    }
  }

  void _generateBricks() {
    final testBricks = ProceduralLevelGenerator().generate(
      difficulty: const LevelDifficulty(
        cols: 1,
        emptyChance: 0,
        rows: 1,
        strongBrickChance: 0,
      ),
      screenSize: brickViewModel.screenSize,
    );

    final normalBricks = ProceduralLevelGenerator().generate(
      difficulty: const LevelDifficulty(
        // bonusChance: 80,
        cols: 3,
        emptyChance: 10,
        rows: 5,
        strongBrickChance: 25,
      ),
      screenSize: brickViewModel.screenSize,
    );

    // brickViewModel.setBricks(normalBricks);
    brickViewModel.setBricks(testBricks);
    // log('Level generated');
  }

  void _generateBossBrick() {
    final screenSize = brickViewModel.screenSize;
    const bossTop = 80.0;
    const bossHeight = 50.0;
    final bossWidth = screenSize.width * 0.7;
    final bossLeft = (screenSize.width - bossWidth) / 2;

    final boss = BrickModel(
      x: bossLeft / screenSize.width * 2 - 1,
      y: bossTop / screenSize.height * 2 - 1,
      width: bossWidth / screenSize.width * 2,
      height: bossHeight / screenSize.height * 2,
      type: BrickType.strong,
    )
      ..hp = bossMaxHp
      ..color = const Color(0xFFE53935);

    brickViewModel.setBricks([boss]);
  }
}
