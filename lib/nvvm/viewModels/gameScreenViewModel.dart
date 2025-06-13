import 'dart:developer';
import 'package:bouncer/nvvm/viewModels/ballViewModel.dart';
import 'package:bouncer/nvvm/viewModels/brickViewModel.dart';
import 'package:bouncer/nvvm/viewModels/platformViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum GameState {
  initial,
  playing,
  paused,
  gameOver,
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
  bool get shouldShowActionButton => _gameState != GameState.playing;

  GameViewModel({
    required this.ballViewModel,
    required this.platformViewModel,
    required this.brickViewModel,
    required this.particleSystem,
  }) {
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration _) {
    particleSystem.update(0.016);
    if (_isMovingLeft) {
      platformViewModel.moveLeft();
    } else if (_isMovingRight) {
      platformViewModel.moveRight();
    }
    ballViewModel.updateAndMove(platformViewModel);
    checkCollisions();
    gameOverCheck();
    if (_gameState == GameState.gameOver) {
      log('🎮 Game Over, stopping ticker');
      _ticker.stop();
    }
    notifyListeners();
  }

  void onActionButtonPressed() {
    switch (_gameState) {
      case GameState.initial:
        startNewGame();
        break;
      case GameState.paused:
        resumeGame();
        break;
      case GameState.gameOver:
        startNewGame();
        break;
      case GameState.playing:
        // Кнопка скрыта, ничего не делаем
        break;
    }
  }

  IconData getButtonIcon() {
    switch (_gameState) {
      case GameState.initial:
        return Icons.play_arrow;
      case GameState.paused:
        return Icons.play_arrow;
      case GameState.gameOver:
        return Icons.refresh;
      case GameState.playing:
        return Icons.play_arrow;
    }
  }

  String getButtonText() {
    switch (_gameState) {
      case GameState.initial:
        return 'ИГРАТЬ';
      case GameState.paused:
        return 'ПРОДОЛЖИТЬ';
      case GameState.gameOver:
        return 'ИГРАТЬ СНОВА';
      case GameState.playing:
        return ''; // Кнопка скрыта
    }
  }

  void updateDependencies({
    required BallViewModel ballViewModel,
    required PlatformViewModel platformViewModel,
    required BrickViewModel brickViewModel,
    required ParticleSystem particleSystem,
  }) {
    this.ballViewModel = ballViewModel;
    this.platformViewModel = platformViewModel;
    this.brickViewModel = brickViewModel;
    this.particleSystem = particleSystem;
  }

  void checkCollisions() {
    ballViewModel.updateAndMove(platformViewModel);
    brickViewModel.checkCollision(ballViewModel);
  }

  gameOverCheck() {
    if (ballViewModel.isBelowScreen || brickViewModel.isEmpty) {
      _gameState = GameState.gameOver;
    }
  }

  void startNewGame() {
    log('🎮 Starting new game');
    ballViewModel.reset();
    brickViewModel.restoreBricks();
    ballViewModel.reset();
    _gameState = GameState.playing;
    _ticker.start();
    notifyListeners();
  }

  void resumeGame() {
    log('🎮 Resuming game');
    _gameState = GameState.playing;
    _ticker.start();
    notifyListeners();
  }

  // Пауза игры
  void pauseGame() {
    log('🎮 Pausing game');
    _ticker.stop();
    _gameState = GameState.paused;
    notifyListeners();
  }

  void onKeyDown(String key) {
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
