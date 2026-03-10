import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/levelGenerator.dart';
// import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

class LevelManager {
  final BrickViewModel brickViewModel;
  final BallManager ballManager;
  final TimeManager timeManager;
  final PlatformViewModel platformViewModel;

  LevelManager(
      {required this.brickViewModel,
      required this.ballManager,
      required this.timeManager,
      required this.platformViewModel});

  final bool _isBossLevel = false;
  bool get isBossLevel => _isBossLevel;
  bool _levelCompletionScheduled = false;
  int level = 1;

  void resetLevel() {
    ballManager.resetAllBalls(platformViewModel);
    if (!_isBossLevel) _generateBricks();
    _levelCompletionScheduled = false;
  }

  void checkLevelCompletion(VoidCallback onLevelCompleted) {
    if (_levelCompletionScheduled) return;
    if (_isBossLevel) return;
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

    brickViewModel.setBricks(normalBricks);
    // brickViewModel.setBricks(testBricks);
    // log('Level generated');
  }
}
