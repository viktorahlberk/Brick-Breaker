import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:bouncer/gameSettings.dart';
import 'package:bouncer/inputController.dart';
import 'package:bouncer/models/bonusModel.dart';
import 'package:bouncer/models/brickModel.dart';
import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:bouncer/viewModels/bonusManager.dart';
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
  gameOver,
}

class GameViewModel extends ChangeNotifier {
  late BallViewModel ballViewModel;
  late PlatformViewModel platformViewModel;
  late BrickViewModel brickViewModel;
  late ParticleSystem particleSystem;
  late GunViewModel gunViewModel;
  final InputController input;
  BonusManager bonusManager = BonusManager();

  late final Ticker _ticker;
  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;
  bool get shouldShowActionButton => _gameState != GameState.playing;
  final _platform = kIsWeb ? 'web' : Platform.operatingSystem;
  StreamSubscription<AccelerometerEvent>? accelometerSubscription;
  Gamesettings _gameSettings = Gamesettings();
  Duration? _lastTick;
  bool _hitStopActive = false;

  GameViewModel({
    required this.ballViewModel,
    required this.platformViewModel,
    required this.brickViewModel,
    required this.particleSystem,
    required this.gunViewModel,
    required this.input,
  }) {
    // input.addListener(_onInputChanged);
    _ticker = Ticker(_onTick);
    if (_platform == 'android') {
      // Инициализация для веба, если нужно
      dev.log('🎮 Game initialized for android');
      if (_gameSettings.control == Control.sensor) {
        accelometerSubscription = accelerometerEventStream().listen((event) {
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
        });
      }
    } else {
      dev.log('🎮 Game initialized for web');
    }
  }

  void activateBonus(BonusType type) {
    switch (type) {
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
      case BonusType.bigPlatform:
        platformViewModel.setScale(1.5);
        Future.delayed(
          Duration(seconds: 8),
          () => platformViewModel.normalizeScale(),
        );
        break;
    }
  }

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

    bonusManager.update(scaledDt);
    bonusManager.checkCollect(
      platformViewModel,
      activateBonus,
    );

    // ===== INPUT → AXIS =====
    platformViewModel.setInput(input.axis);

    // ===== UPDATE SYSTEMS =====
    platformViewModel.update(scaledDt);
    ballViewModel.updateAndMove(scaledDt, platformViewModel);
    gunViewModel.update(scaledDt);
    particleSystem.update(scaledDt);

    // ===== COLLISIONS =====
    checkAllCollisions();

    // ===== GAME OVER =====
    gameOverCheck();
    if (_gameState == GameState.gameOver) {
      _ticker.stop();
      notifyListeners(); // UI должен узнать
      return;
    }

    // ⚠️ ВАЖНО:
    // notifyListeners здесь вызывается ОДИН раз за тик
    notifyListeners();
  }

  void checkAllCollisions() async {
    // Получаем все столкновения
    final collisions =
        brickViewModel.checkCollision(ballViewModel, gunViewModel);

    for (final result in collisions) {
      if (result.brickIndex == null) continue;

      final brick = brickViewModel.bricks[result.brickIndex!];
      final brickRect = Rect.fromLTWH(
        (brick.x + 1) * 0.5 * ballViewModel.screenSize.width,
        (brick.y + 1) * 0.5 * ballViewModel.screenSize.height,
        brick.width * ballViewModel.screenSize.width * 0.5,
        brick.height * ballViewModel.screenSize.height * 0.5,
      );

      // === Столкновение с мячом ===
      if (result.bulletIndex == null) {
        if (result.isHardBrick) {
          // Hard brick — меняем цвет, делаем explosion, не удаляем
          brick.type = BrickType.normal;
          brick.color = Colors.white;
          particleSystem.addBrickExplosion(
            Offset(brickRect.center.dx, brickRect.center.dy),
            brick.color,
          );
          tryBonus(brickRect.center);
        } else if (result.destroyed) {
          // Normal brick — удаляем
          final removedBrick =
              brickViewModel.bricks.removeAt(result.brickIndex!);
          particleSystem.addBrickExplosion(
            Offset(brickRect.center.dx, brickRect.center.dy),
            removedBrick.color,
          );
          tryBonus(brickRect.center);
        }

        // Инвертируем Y мячика
        ballViewModel.velocityY = -ballViewModel.velocityY;

        // Добавляем hit-stop
        // await hitStop(duration: 0.120);
      }

      // === Столкновение с пулей ===
      else {
        final bullet = gunViewModel.bulletsList[result.bulletIndex!];

        if (result.isHardBrick) {
          // Hard brick — только цвет меняем, удаляем пулю
          brick.type = BrickType.normal;
          brick.color = Colors.white;
          gunViewModel.bulletsList.remove(bullet);
          particleSystem.addBrickExplosion(
            Offset(brickRect.center.dx, brickRect.center.dy),
            brick.color,
          );
          tryBonus(brickRect.center);
        } else if (result.destroyed) {
          // Normal brick — удаляем и пулю
          final removedBrick =
              brickViewModel.bricks.removeAt(result.brickIndex!);
          gunViewModel.bulletsList.remove(bullet);
          particleSystem.addBrickExplosion(
            Offset(brickRect.center.dx, brickRect.center.dy),
            removedBrick.color,
          );
          tryBonus(brickRect.center);
        }
      }
    }

    // После всех изменений уведомляем UI
    // if (collisions.isNotEmpty) notifyListeners();
  }

  tryBonus(Offset brickCenter) {
    // if (Random().nextDouble() < 0.3) {
    bonusManager.spawnBonus(
      type: BonusType.bigPlatform,
      position: brickCenter,
    );
    // }
  }

  Future<void> hitStop({
    double duration = 0.06, // 60 ms
  }) async {
    if (_hitStopActive) return;
    _hitStopActive = true;

    final prevScale = input.timeScale;
    input.setSlowMotion(0.0001);

    await Future.delayed(
      Duration(milliseconds: (duration * 1000).toInt()),
    );

    input.setSlowMotion(prevScale);
    _hitStopActive = false;
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
    required GunViewModel gunViewModel,
  }) {
    this.ballViewModel = ballViewModel;
    this.platformViewModel = platformViewModel;
    this.brickViewModel = brickViewModel;
    this.particleSystem = particleSystem;
    this.gunViewModel = gunViewModel;
  }

  void gameOverCheck() {
    if (ballViewModel.isBelowScreen || brickViewModel.isEmpty) {
      _gameState = GameState.gameOver;
    }
  }

  void startNewGame() {
    dev.log('🎮 Starting new game');
    ballViewModel.reset();
    ballViewModel.launch();
    // brickViewModel.initLevel();
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
    // input.removeListener(_onInputChanged);
    accelometerSubscription?.cancel();
    super.dispose();
  }
}
