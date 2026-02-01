import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:bouncer/collisionManager.dart';
import 'package:bouncer/gameSettings.dart';
import 'package:bouncer/inputController.dart';
import 'package:bouncer/levelManager.dart';
// import 'package:bouncer/models/bonusModel.dart';
import 'package:bouncer/models/brickModel.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/bonuses/bonusManager.dart';
import 'package:bouncer/viewModels/brickViewModel.dart';
import 'package:bouncer/viewModels/gunViewModel.dart';
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
  levelCompleted,
  gameOver,
}

class GameViewModel extends ChangeNotifier {
  late BallViewModel ballViewModel;
  late PlatformViewModel platformViewModel;
  late BrickViewModel brickViewModel;
  late ParticleSystem particleSystem;
  late GunViewModel gunViewModel;
  final InputController input;

  final CollisionManager collisionManager;
  final LevelManager levelManager;
  final BonusManager bonusManager;

  late final Ticker _ticker;
  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;
  bool get shouldShowActionButton => _gameState != GameState.playing;
  final _platform = kIsWeb ? 'web' : Platform.operatingSystem;
  // StreamSubscription<AccelerometerEvent>? accelometerSubscription;
  // Gamesettings _gameSettings = Gamesettings();
  Duration? _lastTick;
  // bool _hitStopActive = false;
  // bool _levelCompletionScheduled = false;

  GameViewModel({
    required this.ballViewModel,
    required this.platformViewModel,
    required this.brickViewModel,
    required this.particleSystem,
    required this.gunViewModel,
    required this.input,
    required this.collisionManager,
    required this.levelManager,
    required this.bonusManager,
  }) {
    // input.addListener(_onInputChanged);
    _ticker = Ticker(_onTick);
    if (_platform == 'android') {
      input.inputType = InputType.touch;
      dev.log('🎮 Game initialized for android');
      // if (_gameSettings.control == Control.sensor) {
      // accelometerSubscription = accelerometerEventStream().listen((event) {
      // if (event.y < -1) {
      //   _isPlatformMovingLeft = true;
      //   _isPlatformMovingRight = false;
      // } else if (event.y > 1) {
      //   _isPlatformMovingLeft = false;
      //   _isPlatformMovingRight = true;
      // } else {
      //   _isPlatformMovingLeft = false;
      //   _isPlatformMovingRight = false;
      // }
      // });
      // }
    } else {
      dev.log('🎮 Game initialized for web');
      input.inputType = InputType.key;
    }
  }

  // void activateBonus(BonusType type) {
  //   switch (type) {
  // case BonusType.gun:
  //   gunViewModel.enable(duration: Duration(seconds: 10));
  //   break;

  // case BonusType.slowMotion:
  //   input.setSlowMotion(0.4);
  //   Future.delayed(
  //     Duration(seconds: 5),
  //     () => input.setSlowMotion(1.0),
  //   );
  //   break;

//TODO Check ! why scale changes back to normal too fast? oO
  //     case BonusType.bigPlatform:
  //       platformViewModel.setScale(1.5);
  //       Future.delayed(
  //         Duration(seconds: 8),
  //         () => platformViewModel.normalizeScale(),
  //       );
  //       break;
  //   }
  // }

  void _onTick(Duration elapsed) {
    // ===== deltaTime =====
    double dt;
    if (_lastTick == null) {
      dt = 1 / 60;
    } else {
      dt = (elapsed - _lastTick!).inMicroseconds / 1e6;
    }
    _lastTick = elapsed;

    // защита от лагов и резких скачков
    dt = dt.clamp(0.0, 0.033); // максимум ~30 FPS шаг

    // ===== если игра не активна — не обновляем мир =====
    if (input.paused || _gameState != GameState.playing) return;

    final scaledDt = dt * input.timeScale;

    // ===== UPDATE SYSTEMS =====

    //TODO Make normal behaviour depends input type!!
    if (input.inputType == InputType.touch) {
      final targetX = input.tapTarget;
      platformViewModel.moveCenterTo(targetX, dt);
    } else {
      platformViewModel.setInput(input.axis);
      platformViewModel.update(scaledDt);
    }
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);
    particleSystem.update(scaledDt);
    bonusManager.update(scaledDt);
    collisionManager.checkCollisions();

    gameOverCheck();
    levelManager.checkLevelCompletion(() {
      _gameState = GameState.levelCompleted;
    });
    if (_gameState == GameState.gameOver) {
      _ticker.stop();
      notifyListeners(); // UI должен узнать
      return;
    }

    // ⚠️ ВАЖНО:
    // notifyListeners здесь вызывается ОДИН раз за тик
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
      case GameState.levelCompleted:
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
      case GameState.levelCompleted:
        return ''; // Кнопка скрыта
    }
  }

  void updateDependencies({
    required BallViewModel ballViewModel,
    required PlatformViewModel platformViewModel,
    required BrickViewModel brickViewModel,
    required ParticleSystem particleSystem,
    required GunViewModel gunViewModel,
  }) {
    this.ballViewModel = ballViewModel;
    this.platformViewModel = platformViewModel;
    this.brickViewModel = brickViewModel;
    this.particleSystem = particleSystem;
    this.gunViewModel = gunViewModel;
  }

  void gameOverCheck() {
    if (ballViewModel.isBelowScreen) {
      _gameState = GameState.gameOver;
    }
  }

  // void levelDoneCheck() {
  //   if (_levelCompletionScheduled) return;

  //   if (brickViewModel.isEmpty) {
  //     _levelCompletionScheduled = true;
  //     _gameState = GameState.levelCompleted;

  //     input.setSlowMotion(0.3);

  //     Future.delayed(const Duration(seconds: 2), () {
  //       input.resetTimeScale();
  //       // notifyListeners();
  //     });
  //   }
  // }

  void startNewGame() {
    dev.log('🎮 Starting new game');
    levelManager.startLevel();
    _gameState = GameState.playing;
    _ticker.start();
    notifyListeners();
  }

  void resumeGame() {
    dev.log('🎮 Resuming game');
    _gameState = GameState.playing;
    _ticker.start();
    notifyListeners();
  }

  void pauseGame() {
    dev.log('🎮 Pausing game');
    _ticker.stop();
    _gameState = GameState.paused;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    // accelometerSubscription?.cancel();
    super.dispose();
  }
}
