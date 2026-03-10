// import 'package:bouncer/features/game/managers/game_loop_manager.dart';
import 'dart:developer';

import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/core/platform_detector.dart';
import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/bonuses/domain/bonus_activator.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusPickupVmModel.dart';
import 'package:bouncer/features/game/domain/brickModel.dart';
import 'package:bouncer/features/game/game_ui_state.dart';
import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/managers/collisionManager.dart';
import 'package:bouncer/features/game/managers/game_loop_manager.dart';
import 'package:bouncer/features/game/managers/levelManager.dart';
import 'package:bouncer/features/game/managers/scoreManager.dart';
import 'package:bouncer/features/game/runtimeContext.dart';
// import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
import 'package:bouncer/features/upgrades/upgradeManager.dart';
import 'package:flutter/material.dart';

class GameCoordinator extends ChangeNotifier {
  final ScoreManager _scoreManager;
  late final GameLoopManager _gameLoopManager;
  final LevelManager _levelManager;
  final ParticleSystem _particleSystem;
  final BonusManager _bonusManager;
  final GunViewModel _gunViewModel;
  final InputController _inputController;
  final TimeManager _timeManager;
  // final BallViewModel _ballViewModel;
  final BallManager _ballManager;
  final PlatformViewModel _platformViewModel;
  final CollisionManager _collisionManager;
  // final BonusActivator _bonusActivator;
  final UpgradeManager _upgradeManager;
  final BrickViewModel _brickViewModel;

  GameCoordinator(
    this._scoreManager,
    this._levelManager,
    this._particleSystem,
    this._bonusManager,
    this._gunViewModel,
    this._inputController,
    this._timeManager,
    this._ballManager,
    this._platformViewModel,
    this._collisionManager,
    // this._bonusActivator,
    this._upgradeManager,
    this._brickViewModel,
  ) {
    _gameLoopManager = GameLoopManager(onUpdate: _onUpdate);
    _initializeGame();
  }
  GameState _gameState = GameState.initial;
  int _lives = 1;
  int get level => _levelManager.level;

  GameUIState get uiState => GameUIState(_gameState);
  GameState get gameState => _gameState;
  List<BrickModel> get bricks => _brickViewModel.bricks;
  ParticleSystem get particleSystem => _particleSystem;
  int get score => _scoreManager.score;
  List<BonusPickupViewModel> get bonusesToPickup => _bonusManager.pickups;
  get isBossLevel => _levelManager.isBossLevel;
  RuntimeContext get runtimeContext =>
      RuntimeContext(_ballManager, _platformViewModel);

  void _onUpdate(double dt) {
    // print(gameState);
    final scaledDt = dt * _timeManager.timeScale;
    _particleSystem.update(scaledDt);
    if (_gameState == GameState.initial) {
      _updatePlatform(dt);
      _ballManager.moveToPlatformCenter(_platformViewModel);
    }
    if (_inputController.paused || _gameState != GameState.playing) {
      return;
    }

    _updateSystems(dt);
    _collisionManager.checkCollisions();
    _checkGameOver();
    _checkLevelCompletion();

    if (_gameState == GameState.gameOver) {
      _gameLoopManager.stopGameloop();
    }

    notifyListeners();
  }

  void _updateSystems(double dt) {
    _updatePlatform(dt);
    // architectViewModel.update(dt, this);

    final scaledDt = dt * _timeManager.timeScale;
    _ballManager.updateAndMove(scaledDt, _platformViewModel);
    _gunViewModel.update(scaledDt);

    // _bonusManager.update(scaledDt);
    // _bonusManager.checkCollect(
    //   _platformViewModel,
    //   _bonusActivator.activate,
    // );
  }

  _changeGameState(GameState state) {
    _gameState = state;
    notifyListeners();
  }

  _initializeGame() {
    _gameState == GameState.initial;
    // _changeGameState(GameState.initial);
    _scoreManager.resetScore();
    _initializeLevel();
    _gameLoopManager.startGameloop();
    log('🎮 Game initialized');
  }

  _initializeLevel() {
    _gameState = GameState.initial;
    _gameLoopManager.startGameloop();
    _resetLevel();
    notifyListeners();
  }

  void _resetLevel() {
    _levelManager.resetLevel();
    _particleSystem.clear();
    _bonusManager.reset();
    _gunViewModel.reset();
    _inputController.reset();
  }

  _updatePlatform(double dt) {
    if (PlatformDetector.isMobile) {
      _platformViewModel.moveCenterTo(_inputController.tapTarget, dt);
    } else if (PlatformDetector.isWeb) {
      _platformViewModel.setInput(_inputController.axis);
      _platformViewModel.update(dt * _timeManager.timeScale);
    }
  }

  void _checkGameOver() {
    if (_ballManager.allBallsIsBelowScreen) {
      _gameState = GameState.gameOver;
      log('💀 Game Over');
    }
  }

  void _checkLevelCompletion() {
    _levelManager.checkLevelCompletion(() {
      _gameState = GameState.levelCompleted;
      log('🎉 Level Completed');
      notifyListeners();
    });
  }

  void onActionButtonPressed() {
    switch (_gameState) {
      case GameState.initial:
        _startGame();
        break;

      case GameState.gameOver:
        _initializeGame();
        break;

      case GameState.paused:
        _resumeGame();
        break;

      case GameState.levelCompleted:
        startNextLevel();
        break;

      case GameState.playing:
        // _pauseGame();
        break;
    }
  }

  void _resumeGame() {
    log('🎮 Resuming game');

    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();

    notifyListeners();
  }

  void pauseGame() {
    log('🎮 Pausing game');

    _gameLoopManager.stopGameloop();
    _gameState = GameState.paused;

    notifyListeners();
  }

  void _startGame() {
    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();
  }

  void startNextLevel() {
    _levelManager.level += 1;
    _initializeLevel();
  }

  void applyUpgrade(UpgradeEffect upgradeEffect) {
    upgradeEffect.apply(runtimeContext);
  }

  List<UpgradeEntity> getUpgrades() {
    return _upgradeManager.getUpgrades(2);
  }

  @override
  void dispose() {
    _gameLoopManager.dispose();
    super.dispose();
  }
}
