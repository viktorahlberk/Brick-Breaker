import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/level/levelGenerator.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class LevelManager {
  final BrickViewModel brickViewModel;
  final BallViewModel ballViewModel;
  final TimeManager timeManager;
  final PlatformViewModel platformViewModel;

  bool _levelCompletionScheduled = false;

  LevelManager(
      {required this.brickViewModel,
      required this.ballViewModel,
      required this.timeManager,
      required this.platformViewModel});

  void resetLevel() {
    log('Level resetted.');
    ballViewModel.reset();
    ballViewModel.launch();
    platformViewModel.reset();
    _generateLevel();
    _levelCompletionScheduled = false;
  }

  void checkLevelCompletion(VoidCallback onLevelCompleted) {
    if (_levelCompletionScheduled) return;

    if (brickViewModel.isEmpty) {
      _levelCompletionScheduled = true;
      timeManager.slowMotion(0.3, milliseconds: 2000);
      Future.delayed(Duration(seconds: 2), onLevelCompleted);
    }
  }

  void _generateLevel() {
    final testBricks = ProceduralLevelGenerator().generate(
      difficulty: const LevelDifficulty(
        bonusChance: 0.5,
        cols: 2,
        emptyChance: 0,
        rows: 1,
        strongBrickChance: 0,
      ),
      screenSize: brickViewModel.screenSize,
    );

    final normalBricks = ProceduralLevelGenerator().generate(
      difficulty: const LevelDifficulty(
        bonusChance: 80,
        cols: 3,
        emptyChance: 10,
        rows: 5,
        strongBrickChance: 25,
      ),
      screenSize: brickViewModel.screenSize,
    );

    // brickViewModel.setBricks(normalBricks);
    brickViewModel.setBricks(testBricks);
  }
}
