// import 'dart:ui';

import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class BallManager extends ChangeNotifier {
  Size screenSize;
  int starterBalls = 3;
  List<BallViewModel> ballPool = [];
  BallManager(this.screenSize) {
    _initBalls();
  }
  _initBalls() {
    for (var i = 0; i < starterBalls; i++) {
      ballPool.add(BallViewModel(screenSize: screenSize));
    }
  }

  bool get allBallsIsBelowScreen => _isAllBallsIsBelowScreen();

  addBall() {
    ballPool.add(BallViewModel(screenSize: screenSize));
  }

  resetAllBalls(PlatformViewModel platformViewModel) {
    if (ballPool.isEmpty) {
      _initBalls();
    }
    for (BallViewModel ball in ballPool) {
      ball.reset(platformViewModel);
      ball.launch();
    }
  }

  moveToPlatformCenter(PlatformViewModel platformViewModel) {
    for (BallViewModel ball in ballPool) {
      ball.moveToPlatformCenter(platformViewModel);
    }
  }

  updateAndMove(scaledDt, platformViewModel) {
    for (BallViewModel ball in ballPool) {
      ball.updateAndMove(scaledDt, platformViewModel);
      if (ball.isBelowScreen) {
        ballPool.remove(ball);
      }
    }
  }

  bool _isAllBallsIsBelowScreen() {
    for (BallViewModel ball in ballPool) {
      if (!ball.isBelowScreen) {
        return false;
      }
    }
    return true;
  }
}
