import 'dart:ui';

import 'package:bouncer/timeManager.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/viewModels/brickViewModel.dart';

class LevelManager {
  final BrickViewModel brickViewModel;
  final BallViewModel ballViewModel;
  final TimeManager timeManager;

  bool _levelCompletionScheduled = false;

  LevelManager({
    required this.brickViewModel,
    required this.ballViewModel,
    required this.timeManager,
  });

  void startLevel() {
    ballViewModel.reset();
    ballViewModel.launch();
    // brickViewModel.initLevel(); // если нужно
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
