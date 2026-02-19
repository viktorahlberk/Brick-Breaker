import 'dart:developer' as dev;
import 'package:bouncer/core/platform_detector.dart';
import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/bonuses/domain/bonus_activator.dart';
import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/features/bosses/architect/presentacion/architect_viewmodel.dart';
import 'package:bouncer/features/game/managers/game_loop_manager.dart';
import 'package:bouncer/features/game/game_ui_state.dart';
import 'package:bouncer/features/game/managers/collisionManager.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/features/game/managers/levelManager.dart';
import 'package:bouncer/features/game/managers/scoreManager.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
import 'package:bouncer/features/upgrades/upgradeManager.dart';
import 'package:flutter/material.dart';

class GameViewModel extends ChangeNotifier {
  final BallViewModel ballViewModel;
  final PlatformViewModel platformViewModel;
  final BrickViewModel brickViewModel;
  final ParticleSystem particleSystem;
  final GunViewModel gunViewModel;
  final InputController input;
  final CollisionManager collisionManager;
  final LevelManager levelManager;
  final BonusManager bonusManager;
  final BonusActivator bonusActivator;
  final ScoreManager scoreManager;
  final TimeManager timeManager;
  final ArchitectViewModel architectViewModel;
  final UpgradeManager upgradeManager;

  late final GameLoopManager _gameLoopManager;

  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;

  GameUIState get uiState => GameUIState(_gameState);

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
    required this.bonusActivator,
    required this.scoreManager,
    required this.timeManager,
    required this.architectViewModel,
    required this.upgradeManager,
  }) {
    _gameLoopManager = GameLoopManager(onUpdate: _onUpdate);
    _initializeGame();
  }
  void _onUpdate(double dt) {
    final scaledDt = dt * timeManager.timeScale;
    particleSystem.update(scaledDt);
    if (_gameState == GameState.initial) {
      _updatePlatform(dt);
      ballViewModel.moveToPlatformCenter(platformViewModel);
    }
    if (input.paused || _gameState != GameState.playing) {
      return;
    }

    _updateSystems(dt);
    collisionManager.checkCollisions();
    _checkGameOver();
    _checkLevelCompletion();

    if (_gameState == GameState.gameOver) {
      _gameLoopManager.stopGameloop();
    }

    notifyListeners();
  }

  _updatePlatform(double dt) {
    if (PlatformDetector.isMobile) {
      platformViewModel.moveCenterTo(input.tapTarget, dt);
    } else if (PlatformDetector.isWeb) {
      platformViewModel.setInput(input.axis);
      platformViewModel.update(dt * timeManager.timeScale);
    }
  }

  void _updateSystems(double dt) {
    _updatePlatform(dt);
    architectViewModel.update(dt, this);

    final scaledDt = dt * timeManager.timeScale;
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);

    bonusManager.update(scaledDt);
    bonusManager.checkCollect(
      platformViewModel,
      bonusActivator.activate,
    );
  }

  void _checkGameOver() {
    if (ballViewModel.isBelowScreen) {
      _gameState = GameState.gameOver;
      dev.log('💀 Game Over');
    }
  }

  void _checkLevelCompletion() {
    levelManager.checkLevelCompletion(() {
      _gameState = GameState.levelCompleted;
      dev.log('🎉 Level Completed');
      notifyListeners();
    });
  }

  void onActionButtonPressed() {
    switch (_gameState) {
      case GameState.initial:
        startGame();
        break;

      case GameState.gameOver:
        _initializeGame();
        break;

      case GameState.paused:
        resumeGame();
        break;

      case GameState.levelCompleted:
        startNextLevel();
        break;

      case GameState.playing:
        break;
    }
  }

  _initializeLevel() {
    _gameState = GameState.initial;
    _gameLoopManager.startGameloop();
    _resetLevel();
    notifyListeners();
  }

  void startGame() {
    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();
  }

  void startNextLevel() {
    _initializeLevel();
  }

  _initializeGame() {
    _gameState == GameState.initial;
    scoreManager.resetScore();
    _initializeLevel();
    _gameLoopManager.startGameloop();
    dev.log('🎮 Game initialized');
  }

  void resumeGame() {
    dev.log('🎮 Resuming game');

    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();

    notifyListeners();
  }

  void pauseGame() {
    dev.log('🎮 Pausing game');

    _gameLoopManager.stopGameloop();
    _gameState = GameState.paused;

    notifyListeners();
  }

  void _resetLevel() {
    levelManager.resetLevel();
    particleSystem.clear();
    bonusManager.reset();
    gunViewModel.reset();
    input.reset();
  }

  @override
  void dispose() {
    _gameLoopManager.dispose();
    super.dispose();
  }

  void addUpgrade(UpgradeEntity upgradeEntity) {
    upgradeManager.addUpgrade(upgradeEntity, this);
  }
  // void spawnStructuralBarrier() {
  //   field.spawnBarrier();
  // }

  // void shrinkPlayfield(double dt) {
  //   field.shrink(dt);
  // }
}
