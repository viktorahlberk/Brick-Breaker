import 'dart:developer';
import 'dart:ui';

import 'package:bouncer/core/timeManager.dart';
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
    brickViewModel.initLevel(); // если нужно
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
}

