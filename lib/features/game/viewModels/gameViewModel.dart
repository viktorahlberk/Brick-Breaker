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
// import 'package:bouncer/features/upgrades/domain/entities/upgradeEffect.dart';
import 'package:bouncer/features/upgrades/domain/entities/upgradeEntity.dart';
// import 'package:bouncer/features/upgrades/effects/increasePlatformSizeEffect.dart';
import 'package:bouncer/features/upgrades/upgradeManager.dart';
import 'package:flutter/material.dart';

class GameViewModel extends ChangeNotifier {
  // ========================================
  // ЗАВИСИМОСТИ
  // ========================================

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

  // ========================================
  // ИГРОВОЙ ЦИКЛ
  // ========================================

  late final GameLoopManager _gameLoopManager; // ← Вместо Ticker

  // ========================================
  // СОСТОЯНИЕ
  // ========================================

  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;

  /// UI состояние (вычисляемое свойство)
  GameUIState get uiState => GameUIState(_gameState);

  // ========================================
  // КОНСТРУКТОР
  // ========================================

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

  // ========================================
  // ИГРОВОЙ ЦИКЛ
  // ========================================

  /// Обновление каждый кадр
  ///
  /// Вызывается из GameLoopManager с deltaTime
  void _onUpdate(double dt) {
    final scaledDt = dt * timeManager.timeScale;
    particleSystem.update(scaledDt);
    // Пропускаем обновление если на паузе или не играем
    if (_gameState == GameState.initial) {
      _updatePlatform(dt);
      ballViewModel.moveToPlatformCenter(platformViewModel);
      // return;
    }
    if (input.paused || _gameState != GameState.playing) {
      return;
    }

    _updateSystems(dt);
    collisionManager.checkCollisions();
    _checkGameOver();
    _checkLevelCompletion();

    // Останавливаем цикл при game over
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
    // notifyListeners();
  }

  /// Обновление всех систем
  void _updateSystems(double dt) {
    _updatePlatform(dt);
    architectViewModel.update(dt, this);

    // Обновление игровых объектов
    final scaledDt = dt * timeManager.timeScale;
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);

    // Обновление и проверка бонусов
    bonusManager.update(scaledDt);
    bonusManager.checkCollect(
      platformViewModel,
      bonusActivator.activate, // ← Используем BonusActivator
    );
  }

  // ========================================
  // ПРОВЕРКИ СОСТОЯНИЯ
  // ========================================

  /// Проверка game over
  void _checkGameOver() {
    if (ballViewModel.isBelowScreen) {
      _gameState = GameState.gameOver;
      dev.log('💀 Game Over');
    }
  }

  /// Проверка завершения уровня
  void _checkLevelCompletion() {
    levelManager.checkLevelCompletion(() {
      _gameState = GameState.levelCompleted;
      dev.log('🎉 Level Completed');
      notifyListeners();
    });
  }

  // ========================================
  // УПРАВЛЕНИЕ ИГРОЙ
  // ========================================

  /// Обработка нажатия кнопки действия
  ///
  /// Кнопка меняет поведение в зависимости от состояния
  void onActionButtonPressed() {
    switch (_gameState) {
      case GameState.initial:
        startGame();
        break;

      case GameState.gameOver:
        _gameState = GameState.initial;
        _initializeGame();
        break;

      case GameState.paused:
        resumeGame();
        break;

      case GameState.levelCompleted:
        startNextLevel();
        break;

      case GameState.playing:
        // Кнопка скрыта в этом состоянии
        break;
    }
  }

  _initializeLevel() {
    _gameState = GameState.initial;
    _gameLoopManager.startGameloop();
    _resetLevel();
    notifyListeners();
  }

  /// Начать новую игру
  void startGame() {
    dev.log('🎮 Starting new game');

    // _resetGame();
    scoreManager.resetScore();
    // _initializeLevel();
    _initializeGame();

    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();

    // notifyListeners();
  }

  /// Начать следующий уровень
  void startNextLevel() {
    // dev.log('🎮 Starting next level');
    // _resetGame();
    _initializeLevel();
    _gameState = GameState.initial;

    // notifyListeners();
  }

  _initializeGame() {
    _gameState == GameState.initial;
    scoreManager.resetScore();
    _initializeLevel();
    _gameLoopManager.startGameloop();
    dev.log('🎮 Game initialized');
  }

  /// Продолжить игру
  void resumeGame() {
    dev.log('🎮 Resuming game');

    _gameState = GameState.playing;
    _gameLoopManager.startGameloop();

    notifyListeners();
  }

  /// Пауза
  void pauseGame() {
    dev.log('🎮 Pausing game');

    _gameLoopManager.stopGameloop();
    _gameState = GameState.paused;

    notifyListeners();
  }

  // ========================================
  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ========================================

  void _resetLevel() {
    levelManager.resetLevel();
    particleSystem.clear();
    bonusManager.reset();
    gunViewModel.reset();
    input.reset();
  }

  // ========================================
  // LIFECYCLE
  // ========================================

  @override
  void dispose() {
    _gameLoopManager.dispose(); // ← Вместо _ticker.dispose()
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
