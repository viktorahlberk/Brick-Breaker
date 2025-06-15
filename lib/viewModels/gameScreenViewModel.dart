import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/viewModels/brickViewModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  final _platform = kIsWeb ? 'web' : Platform.operatingSystem;
  StreamSubscription<AccelerometerEvent>? accelometerSubscription;

  GameViewModel({
    required this.ballViewModel,
    required this.platformViewModel,
    required this.brickViewModel,
    required this.particleSystem,
  }) {
    _ticker = Ticker(_onTick);
    if (_platform == 'android') {
      // Инициализация для веба, если нужно
      log('🎮 Game initialized for android');
      accelometerSubscription = accelerometerEventStream().listen((event) {
        if (event.y < -1) {
          _isMovingLeft = true;
          _isMovingRight = false;
        } else if (event.y > 1) {
          _isMovingRight = true;
          _isMovingLeft = false;
        } else {
          _isMovingLeft = false;
          _isMovingRight = false;
        }
      });
    } else {
      log('🎮 Game initialized for web');
    }
  }

  void _onTick(Duration _) {
    // print(particleSystem.particles.length);
    // particleSystem.update(0.016);
    particleSystem.update(0.008);
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
    final start = DateTime.now();
    brickViewModel.checkCollision(ballViewModel);
    final duration = DateTime.now().difference(start);
    if (duration.inMilliseconds > 5) {
      log('⚠️ checkCollisions took ${duration.inMilliseconds} ms');
    }
  }

  void gameOverCheck() {
    if (ballViewModel.isBelowScreen || brickViewModel.isEmpty) {
      _gameState = GameState.gameOver;
    }
  }

  void startNewGame() {
    log('🎮 Starting new game');
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
    accelometerSubscription?.cancel();
    super.dispose();
  }
}
