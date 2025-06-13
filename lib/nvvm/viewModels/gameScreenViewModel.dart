import 'dart:async';

import 'package:bouncer/nvvm/viewModels/ballViewModel.dart';
import 'package:bouncer/nvvm/viewModels/brickViewModel.dart';
import 'package:bouncer/nvvm/viewModels/platformViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum GameState {
  initial, // Начальное состояние (показать кнопку "Играть")
  playing, // Игра идет
  paused, // Игра на паузе
  gameOver, // Игра окончена
}

class GameViewModel extends ChangeNotifier {
  late BallViewModel ballViewModel;
  late PlatformViewModel platformViewModel;
  late BrickViewModel brickViewModel;
  late ParticleSystem particleSystem;

  late final Ticker _ticker;
  bool _isMovingLeft = false;
  bool _isMovingRight = false;
  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;

  GameViewModel({
    required this.ballViewModel,
    required this.platformViewModel,
    required this.brickViewModel,
    required this.particleSystem,
  }) {
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration _) {
    print(gameState);
    if (_gameState == GameState.gameOver) {
      // Future.delayed(const Duration(seconds: 2), () {
      _ticker.stop();
      // notifyListeners();
      // return;
      // });
    }
    // print({ballViewModel.model.position.dy, ballViewModel.screenSize.height});
    if (_isMovingLeft) {
      platformViewModel.moveLeft();
    }
    if (_isMovingRight) {
      platformViewModel.moveRight();
    }
    ballViewModel.updateAndMove(platformViewModel);
    gameOverCheck();
    notifyListeners();
    // print(_isMovingLeft);
  }

  void reset() {
    ballViewModel.reset();
  }

  void updateDependencies({
    required BallViewModel ballViewModel,
    required PlatformViewModel platformViewModel,
    required BrickViewModel brickViewModel,
  }) {
    this.ballViewModel = ballViewModel;
    this.platformViewModel = platformViewModel;
    this.brickViewModel = brickViewModel;
  }

  void checkCollisions() {
    ballViewModel.updateAndMove(platformViewModel);
    brickViewModel.checkCollision(ballViewModel);
  }

  gameOverCheck() {
    if (ballViewModel.isBelowScreen
        // || brickViewModel.isEmpty
        ) {
      _gameState = GameState.gameOver;
      // notifyListeners();
    }
  }

  // bool get isGameOver => ballViewModel.isBelowScreen || brickViewModel.isEmpty;

  void startNewGame() {
    brickViewModel.restoreBricks();
    ballViewModel.reset();
    _gameState = GameState.playing;
    notifyListeners();
  }

  // void onKeyPressed(String? key) {
  //   if (key == null) return;
  //   if (key == 'a' || key == 'ArrowLeft') {
  //     platformViewModel.moveLeft();
  //     notifyListeners();
  //   } else if (key == 'd' || key == 'ArrowRight') {
  //     platformViewModel.moveRight();
  //     notifyListeners();
  //   }
  // }

  void onKeyDown(String key) {
    print('Key pressed: $key');
    if (key == 'a' || key == 'arrowleft') {
      _isMovingLeft = true;
    } else if (key == 'd' || key == 'arrowright') {
      _isMovingRight = true;
    }
  }

  void onKeyUp(String key) {
    if (key == 'a' || key == 'arrowleft') {
      _isMovingLeft = false;
    } else if (key == 'd' || key == 'arrowright') {
      _isMovingRight = false;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
