import 'dart:async';
import 'package:bouncer/controllers/ballWidgetController.dart';
import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:bouncer/widgets/ballWidget.dart';
import 'package:bouncer/widgets/brick.dart';
import 'package:bouncer/widgets/platformWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cover_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<StatefulWidget> createState() => GameScreenState();
}

class GameScreenState extends State {
  final FocusNode _focusNode = FocusNode();

  late double x, y, z;
  @override
  void initState() {
    super.initState();

    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   setState(() {
    //     x = event.x;
    //     y = event.y;
    //     z = event.z;
    //       // if (y / 100 + playerX > -1 && y / 100 + playerX + playerWidth < 1) {
    //       //   playerX = playerX + y / 100;
    //       // }

    //       if (y / 100 + platform.x > -1 && y / 100 + platform.x + platform.width < 1) {
    //         platform.x = platform.x + y / 100;
    //       }
    //   });
    // });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool isGameStarted = false;
  bool isGameOver = false;

  static double firstBrickX = -1 + wallGap;
  static double firstBrixkY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.02;
  static double brickGap = 0.01;
  static int numberOfBrickInRow = 4;
  static double wallGap = 0.5 *
      (2 -
          numberOfBrickInRow * brickWidth -
          (numberOfBrickInRow - 1) * brickGap);

  var myBricks = [
    [brickHeight, brickWidth, firstBrickX, firstBrixkY, false],
    [
      brickHeight,
      brickWidth,
      firstBrickX + brickWidth + brickGap,
      firstBrixkY,
      false
    ],
    [
      brickHeight,
      brickWidth,
      firstBrickX + 2 * (brickWidth + brickGap),
      firstBrixkY,
      false
    ],
    [
      brickHeight,
      brickWidth,
      firstBrickX + 3 * (brickWidth + brickGap),
      firstBrixkY,
      false
    ],
    // Brick(
    //     brickHeight: brickHeight,
    //     brickWidth: brickWidth,
    //     brickX: firstBrickX + 3 * (brickWidth + brickGap),
    //     brickY: firstBrixkY,
    //     brickBroken: false)
  ];
  bool isNoBricksLeft() {
    // var isNoBricksLeft = false;
    for (var tile in myBricks) {
      if (tile[4] == true) {
        continue;
      } else {
        return false;
      }
    }
    return true;
  }

  bool gameIsOver(BallWidgetController ball) {
    return ball.y > ball.screenHeight;
  }

  void resetGame() {
    setState(() {
      isGameStarted = true;
      isGameOver = false;
    });
  }

  checkForBrokenBricks(BallWidgetController ball) {
    for (int i = 0; i < myBricks.length; i++) {
      var x = myBricks[i][2] as double;
      var y = myBricks[i][3] as double;
      if (ball.x >= x &&
          ball.x <= x + brickWidth &&
          ball.y <= y + brickHeight &&
          myBricks[i][4] == false) {
        setState(() {
          myBricks[i][4] = true;
          ball.xDirection = BallDirection.RIGHT;
          ball.yDirection = BallDirection.DOWN;
        });
      }
    }
  }

  void startGame(BallWidgetController ball, PlatformWidgetController platform,
      BuildContext context) {
    if (!isGameStarted) {
      isGameStarted = true;
      Timer.periodic(const Duration(milliseconds: 16), (timer) {
        ball.updateBallDirection(platform);
        ball.moveBall();

        if (gameIsOver(ball) || isNoBricksLeft()) {
          Future.delayed(
            Duration(seconds: 2),
            () => timer.cancel(),
          );

          isGameOver = true;
        }
        checkForBrokenBricks(ball);
      });
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
          GestureDetector(
              onTap: () => startGame(ball, platform, context),
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: KeyboardListener(
                    autofocus: true,
                    focusNode: _focusNode,
                    onKeyEvent: (KeyEvent key) {
                      if (key.character == 'a') {
                        platform.moveLeft();
                        // print(platform.x);
                      }
                      if (key.character == 'd') {
                        platform.moveRight();
                        // print(platform.x);
                      }
                    },
                    child: Stack(
                      children: [
                        // buildDebugOverlay(ball, platform, context),
                        isGameStarted ? SizedBox() : CoverScreen(),
                        BallWidget(),
                        PlatformWidget(),
                        isGameOver
                            ? Center(
                                child: Column(
                                  children: [
                                    const Text('G A M E  O V E R',
                                        style: TextStyle(color: Colors.white)),
                                    ElevatedButton(
                                      onPressed: () {
                                        Provider.of<BallWidgetController>(
                                                context,
                                                listen: false)
                                            .reset();
                                        resetGame();
                                        setState(() {});
                                      },
                                      child: const Text('Play again'),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        // myBricks[0]
                        Brick(
                          brickHeight: myBricks[0][0],
                          brickWidth: myBricks[0][1],
                          brickX: myBricks[0][2],
                          brickY: myBricks[0][3],
                          brickBroken: myBricks[0][4] as bool,
                        ),
                        Brick(
                          brickHeight: myBricks[1][0],
                          brickWidth: myBricks[1][1],
                          brickX: myBricks[1][2],
                          brickY: myBricks[1][3],
                          brickBroken: myBricks[1][4] as bool,
                        ),
                        Brick(
                          brickHeight: myBricks[2][0],
                          brickWidth: myBricks[2][1],
                          brickX: myBricks[2][2],
                          brickY: myBricks[2][3],
                          brickBroken: myBricks[2][4] as bool,
                        ),
                        Brick(
                          brickHeight: myBricks[3][0],
                          brickWidth: myBricks[3][1],
                          brickX: myBricks[3][2],
                          brickY: myBricks[3][3],
                          brickBroken: myBricks[3][4] as bool,
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
