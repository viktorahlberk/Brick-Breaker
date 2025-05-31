import 'dart:async';
import 'dart:developer' as log;
import 'package:bouncer/controllers/ballWidgetController.dart';
import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:bouncer/particles.dart';
import 'package:bouncer/widgets/ballWidget.dart';
import 'package:bouncer/widgets/brick.dart';
import 'package:bouncer/widgets/platformWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Определяем enum для состояний игры
enum GameState {
  initial, // Начальное состояние (показать кнопку "Играть")
  playing, // Игра идет
  paused, // Игра на паузе
  gameOver, // Игра окончена
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<StatefulWidget> createState() => GameScreenState();
}

class GameScreenState extends State {
  // Заменяем булевы переменные на одну enum переменную
  GameState currentGameState = GameState.initial;

  // Остальные переменные остаются без изменений
  ParticleSystem particleSystem = ParticleSystem();
  final FocusNode _focusNode = FocusNode();
  late StreamSubscription<AccelerometerEvent> sub;
  late BallWidgetController ballController;
  late PlatformWidgetController platformController;
  List<Brick> myBricks = [];
  Timer? gameTimer; // Добавляем ссылку на таймер для управления

  @override
  void initState() {
    super.initState();
    restoreBricks();
    ballController = Provider.of<BallWidgetController>(context, listen: false);
    platformController =
        Provider.of<PlatformWidgetController>(context, listen: false);

    sub = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Акселерометр работает только во время игры
      if (currentGameState == GameState.playing) {
        if (event.y > 1) {
          platformController.moveRight();
        } else if (event.y < -1) {
          platformController.moveLeft();
        }
      }
    });
  }

  // Метод для смены состояния с логированием
  void changeGameState(GameState newState) {
    log.log('🎮 State change: ${currentGameState.name} -> ${newState.name}');
    setState(() {
      currentGameState = newState;
    });
  }

  // Запуск новой игры
  void startNewGame() {
    log.log('🎮 Starting new game');

    resetGame();
    changeGameState(GameState.playing);
    startGameLoop();
  }

  // Продолжение игры после паузы
  void resumeGame() {
    log.log('🎮 Resuming game');

    changeGameState(GameState.playing);
    startGameLoop();
  }

  // Пауза игры
  void pauseGame() {
    log.log('🎮 Pausing game');

    gameTimer?.cancel();
    changeGameState(GameState.paused);
  }

  // Завершение игры
  void endGame() {
    log.log('🎮 Game over');

    gameTimer?.cancel();
    changeGameState(GameState.gameOver);
  }

  // Сброс игры к начальному состоянию
  void resetGame() {
    log.log('🎮 Resetting game');

    gameTimer?.cancel();
    restoreBricks();
    ballController.reset();
    particleSystem.clear();
  }

  // Основной игровой цикл
  void startGameLoop() {
    gameTimer?.cancel(); // Отменяем предыдущий таймер, если есть

    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      // Проверяем, что игра все еще идет
      if (currentGameState != GameState.playing) {
        timer.cancel();
        return;
      }

      // Обновляем игровые объекты
      ballController.updateBallDirection(platformController);
      ballController.moveBall();
      particleSystem.update(0.016);
      checkForBrokenBricks(ballController);

      // Проверяем условия окончания игры
      if (isBallDownScreen(ballController)) {
        endGame();
      } else if (myBricks.isEmpty) {
        // Игрок выиграл - можно добавить состояние victory
        endGame();
      }
    });
  }

  // Геттеры для удобства проверки состояний
  bool get isInitial => currentGameState == GameState.initial;
  bool get isPlaying => currentGameState == GameState.playing;
  bool get isPaused => currentGameState == GameState.paused;
  bool get isGameOver => currentGameState == GameState.gameOver;

  // Геттер для определения, нужно ли показывать кнопку действия
  bool get shouldShowActionButton => !isPlaying;

  // Метод для получения текста кнопки
  String getButtonText() {
    switch (currentGameState) {
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

  // Метод для получения иконки кнопки
  IconData getButtonIcon() {
    switch (currentGameState) {
      case GameState.initial:
        return Icons.play_arrow;
      case GameState.paused:
        return Icons.play_arrow;
      case GameState.gameOver:
        return Icons.refresh;
      case GameState.playing:
        return Icons.play_arrow; // Не используется
    }
  }

  // Обработчик нажатия кнопки
  void onActionButtonPressed() {
    switch (currentGameState) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<PlatformWidgetController, BallWidgetController>(
      builder: (
        BuildContext context,
        PlatformWidgetController platform,
        BallWidgetController ball,
        Widget? child,
      ) =>
          Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: KeyboardListener(
            autofocus: true,
            focusNode: _focusNode,
            onKeyEvent: (KeyEvent key) {
              // Управление работает только во время игры
              if (isPlaying) {
                if (key.character == 'a') {
                  platform.moveLeft();
                }
                if (key.character == 'd') {
                  platform.moveRight();
                }
              }

              // Пауза на пробел
              if (key.character == ' ') {
                if (isPlaying) {
                  pauseGame();
                } else if (isPaused) {
                  resumeGame();
                }
              }
            },
            child: Stack(
              children: [
                BallWidget(),
                PlatformWidget(),

                // Основная кнопка действия
                if (shouldShowActionButton)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Показываем сообщение о состоянии игры
                        if (isGameOver)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              myBricks.isEmpty ? 'ПОБЕДА!' : 'ИГРА ОКОНЧЕНА',
                              style: TextStyle(
                                color: myBricks.isEmpty
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ElevatedButton.icon(
                          onPressed: onActionButtonPressed,
                          icon: Icon(getButtonIcon(), size: 30),
                          label: Text(
                            getButtonText(),
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Кнопка паузы во время игры
                if (isPlaying)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: IconButton(
                      onPressed: pauseGame,
                      icon: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                // Индикатор состояния для отладки
                Positioned(
                  top: 50,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'State: ${currentGameState.name}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                ...myBricks,
                CustomPaint(
                  painter: ParticlePainter(particleSystem),
                  size: Size.infinite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    sub.cancel();
    gameTimer?.cancel(); // Не забываем отменить таймер
    super.dispose();
  }

  // Остальные методы остаются без изменений
  static double firstBrickX = -1 + wallGap;
  static double firstBrixkY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.09;
  static double brickGap = 0.01;
  static int numberOfBrickInRow = 4;
  static double wallGap = 0.5 *
      (2 -
          numberOfBrickInRow * brickWidth -
          (numberOfBrickInRow - 1) * brickGap);

  bool isBallDownScreen(BallWidgetController ball) {
    return ball.y > ball.screenSize.height * 0.95;
  }

  restoreBricks() {
    myBricks = [
      Brick(brickHeight, brickWidth, firstBrickX + (brickWidth + brickGap),
          firstBrixkY, Colors.white),
      Brick(brickHeight, brickWidth, firstBrickX, firstBrixkY, Colors.red),
      Brick(brickHeight, brickWidth, firstBrickX + 2 * (brickWidth + brickGap),
          firstBrixkY, Colors.green),
      Brick(brickHeight, brickWidth, firstBrickX + 3 * (brickWidth + brickGap),
          firstBrixkY, Colors.blue)
    ];
  }

  void checkForBrokenBricks(BallWidgetController ball) {
    for (int i = 0; i < myBricks.length; i++) {
      Brick brick = myBricks[i];
      Rect brickRect = brick.getBrickPixelRect(context);
      Rect ballRect = ball.ballRect;
      if (ballRect.overlaps(brickRect)) {
        setState(() {
          myBricks.removeAt(i);
        });
        explodeBrick(
          Offset(
            brickRect.left + brickRect.width / 2,
            brickRect.top + brickRect.height / 2,
          ),
          brick.color,
        );
        ball.yDirection = ball.yDirection == BallDirection.DOWN
            ? BallDirection.UP
            : BallDirection.DOWN;
        break;
      }
    }
  }

  void explodeBrick(Offset brickPosition, Color brickColor) {
    particleSystem.addBrickExplosion(
      brickPosition,
      brickColor,
      count: 20,
      intensity: 1.2,
    );
  }
}
