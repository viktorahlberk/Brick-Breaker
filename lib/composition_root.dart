import 'package:bouncer/features/bonuses/bonus_activator.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/game/managers/collisionManager.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/features/game/managers/levelManager.dart';
import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/core/particles.dart';
import 'package:flutter/material.dart';

/// Composition Root - единственное место создания зависимостей
///
/// Теория: Composition Root следует принципу Dependency Injection.
/// Все объекты создаются здесь один раз и передаются через конструкторы.
///
/// Преимущества:
/// - Зависимости создаются один раз
/// - Явный граф зависимостей
/// - Легко тестировать
/// - Контроль над lifecycle
class AppCompositionRoot {
  // Singleton instance
  static AppCompositionRoot? _instance;

  // Core dependencies
  late final ParticleSystem particleSystem;
  late final InputController inputController;
  late final TimeManager timeManager;
  late final BonusManager bonusManager;

  // ViewModels
  late final BallViewModel ballViewModel;
  late final PlatformViewModel platformViewModel;
  late final BrickViewModel brickViewModel;
  late final GunViewModel gunViewModel;

  // Managers
  late final LevelManager levelManager;
  late final CollisionManager collisionManager;

  // Root ViewModel
  late final GameViewModel gameViewModel;

  // Screen size - передаётся при инициализации
  late final Size screenSize;

  /// Private constructor для Singleton паттерна
  AppCompositionRoot._internal();

  /// Factory constructor для получения instance
  factory AppCompositionRoot() {
    _instance ??= AppCompositionRoot._internal();
    return _instance!;
  }

  /// Инициализация всех зависимостей
  ///
  /// Вызывается один раз при старте приложения с нужными параметрами
  ///
  /// Порядок важен! Создаём зависимости снизу вверх:
  /// 1. Базовые сервисы (без зависимостей)
  /// 2. ViewModels (зависят от сервисов)
  /// 3. Managers (зависят от ViewModels)
  /// 4. Root ViewModel (зависит от всего)
  void initialize(Size screenSize) {
    this.screenSize = screenSize;

    // ========================================
    // 1. БАЗОВЫЕ СЕРВИСЫ (без зависимостей)
    // ========================================
    particleSystem = ParticleSystem();
    inputController = InputController();
    bonusManager = BonusManager();

    // ========================================
    // 2. VIEWMODELS (зависят от сервисов)
    // ========================================
    ballViewModel = BallViewModel(screenSize: screenSize);
    platformViewModel = PlatformViewModel(screenSize);
    brickViewModel = BrickViewModel(
      particleSystem: particleSystem,
      screenSize: screenSize,
    );
    gunViewModel = GunViewModel(platformViewModel);

    // ========================================
    // 3. MANAGERS (зависят от ViewModels)
    // ========================================

    // TimeManager зависит от InputController
    timeManager = TimeManager(inputController);
    BonusActivator bonusActivator = BonusActivator(
        platformViewModel: platformViewModel, bonusManager: bonusManager);

    // LevelManager зависит от ViewModels
    levelManager = LevelManager(
      brickViewModel: brickViewModel,
      ballViewModel: ballViewModel,
      timeManager: timeManager,
      platformViewModel: platformViewModel,
    );

    // CollisionManager зависит от ViewModels и сервисов
    collisionManager = CollisionManager(
      brickViewModel: brickViewModel,
      particleSystem: particleSystem,
      gunViewModel: gunViewModel,
      bonusManager: bonusManager,
      ballViewModel: ballViewModel,
    );

    // ========================================
    // 4. ROOT VIEWMODEL (зависит от всего)
    // ========================================
    gameViewModel = GameViewModel(
      ballViewModel: ballViewModel,
      platformViewModel: platformViewModel,
      brickViewModel: brickViewModel,
      particleSystem: particleSystem,
      gunViewModel: gunViewModel,
      input: inputController,
      collisionManager: collisionManager,
      levelManager: levelManager,
      bonusManager: bonusManager,
      bonusActivator: bonusActivator,
    );
  }

  /// Очистка ресурсов при закрытии приложения
  void dispose() {
    gameViewModel.dispose();
    ballViewModel.dispose();
    platformViewModel.dispose();
    brickViewModel.dispose();
    gunViewModel.dispose();
    inputController.dispose();
    // Dispose других ресурсов если нужно
  }

  /// Сброс instance (для тестов)
  static void reset() {
    _instance?.dispose();
    _instance = null;
  }
}
