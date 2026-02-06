import 'dart:developer' as dev;
import 'package:bouncer/s/bonus_activator.dart';
import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/s/game_loop_manager.dart';
import 'package:bouncer/s/game_ui_state.dart';
import 'package:bouncer/features/game/managers/collisionManager.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/features/game/level/levelManager.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/core/particles.dart';
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
  final BonusActivator bonusActivator; // ← Новая зависимость

  // ========================================
  // ИГРОВОЙ ЦИКЛ
  // ========================================

  late final GameLoopManager _gameLoop; // ← Вместо Ticker

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
    required this.bonusActivator, // ← Новая зависимость
  }) {
    // Создаём игровой цикл с callback'ом
    _gameLoop = GameLoopManager(onUpdate: _onUpdate);

    // Инициализируем уровень
    levelManager.resetLevel();

    dev.log('🎮 GameViewModel initialized');
  }

  // ========================================
  // ИГРОВОЙ ЦИКЛ
  // ========================================

  /// Обновление каждый кадр
  ///
  /// Вызывается из GameLoopManager с deltaTime
  void _onUpdate(double dt) {
    // Пропускаем обновление если на паузе или не играем
    if (input.paused || _gameState != GameState.playing) return;

    _updateSystems(dt);
    collisionManager.checkCollisions();
    _checkGameOver();
    _checkLevelCompletion();

    // Останавливаем цикл при game over
    if (_gameState == GameState.gameOver) {
      _gameLoop.stop();
    }

    notifyListeners();
  }

  /// Обновление всех систем
  void _updateSystems(double dt) {
    // Обновление ввода
    if (input.inputType == InputType.touch) {
      platformViewModel.moveCenterTo(input.tapTarget, dt);
    } else {
      platformViewModel.setInput(input.axis);
      platformViewModel.update(dt * input.timeScale);
    }

    // Обновление игровых объектов
    final scaledDt = dt * input.timeScale;
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);
    particleSystem.update(scaledDt);

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
      case GameState.gameOver:
        startNewGame();
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

  /// Начать новую игру
  void startNewGame() {
    dev.log('🎮 Starting new game');

    _resetGame();
    _gameState = GameState.playing;
    _gameLoop.start();

    notifyListeners();
  }

  /// Начать следующий уровень
  void startNextLevel() {
    dev.log('🎮 Starting next level');

    _resetGame();
    _gameState = GameState.initial;

    notifyListeners();
  }

  /// Продолжить игру
  void resumeGame() {
    dev.log('🎮 Resuming game');

    _gameState = GameState.playing;
    _gameLoop.start();

    notifyListeners();
  }

  /// Пауза
  void pauseGame() {
    dev.log('🎮 Pausing game');

    _gameLoop.stop();
    _gameState = GameState.paused;

    notifyListeners();
  }

  // ========================================
  // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
  // ========================================

  /// Сброс игры
  void _resetGame() {
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
    _gameLoop.dispose(); // ← Вместо _ticker.dispose()
    super.dispose();
  }
}
