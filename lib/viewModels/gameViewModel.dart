import 'dart:developer' as dev;
import 'dart:io';
import 'package:bouncer/bonuses/bonusType.dart';
import 'package:bouncer/bonuses/effects/bigPlatformEffect.dart';
import 'package:bouncer/bonuses/effects/platformGunEffect.dart';
import 'package:bouncer/collisionManager.dart';
import 'package:bouncer/inputController.dart';
import 'package:bouncer/levelManager.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/bonuses/bonusManager.dart';
import 'package:bouncer/viewModels/brickViewModel.dart';
import 'package:bouncer/viewModels/gunViewModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';

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
  Duration? _lastTick;

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
    } else {
      input.inputType = InputType.key;
      dev.log('🎮 Game initialized for web');
    }
  }

  void _onTick(Duration elapsed) {
    final dt = _calculateDelta(elapsed);
    if (input.paused || _gameState != GameState.playing) return;

    _updateSystems(dt);
    collisionManager.checkCollisions();
    gameOverCheck();
    levelManager.checkLevelCompletion(() {
      _gameState = GameState.levelCompleted;
      // _gameState = GameState.gameOver;
    });

    if (_gameState == GameState.gameOver) _ticker.stop();
    notifyListeners();
  }

  void _updateSystems(double dt) {
    if (input.inputType == InputType.touch) {
      platformViewModel.moveCenterTo(input.tapTarget, dt);
    } else {
      platformViewModel.setInput(input.axis);
      platformViewModel.update(dt * input.timeScale);
    }

    final scaledDt = dt * input.timeScale;
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);
    particleSystem.update(scaledDt);
    bonusManager.update(scaledDt);
    bonusManager.checkCollect(platformViewModel, activateBonus);
  }

  void activateBonus(BonusType type) {
    switch (type) {
      case BonusType.bigPlatform:
        final effect = BigPlatformEffect(platformViewModel: platformViewModel);
        effect.onApply();
        bonusManager.registerActiveEffect(effect);
        break;

      case BonusType.platformGun:
        final effect = PlatformGunEffect(platformViewModel: platformViewModel);
        effect.onApply();
        bonusManager.registerActiveEffect(effect);
        break;

      // case BonusType.slowMotion:
      //   input.setSlowMotion(0.4);
      //   Future.delayed(Duration(seconds: 5), () {
      //     input.setSlowMotion(1.0);
      //   });
      //   break;
    }
  }

  double _calculateDelta(Duration elapsed) {
    final dt = _lastTick == null
        ? 1 / 60
        : (elapsed - _lastTick!).inMicroseconds / 1e6;
    _lastTick = elapsed;
    return dt.clamp(0.0, 0.033);
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

  void startNewGame() {
    dev.log('🎮 Starting new game');
    levelManager.resetLevel();
    _gameState = GameState.playing;
    _ticker.stop();
    _ticker.start();
    notifyListeners();
  }

  void startNextLevel() {
    dev.log('🎮 Starting next level');
    _gameState = GameState.initial;
    particleSystem.clear();
    levelManager.resetLevel();
    _ticker.stop();
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
    super.dispose();
  }
}
