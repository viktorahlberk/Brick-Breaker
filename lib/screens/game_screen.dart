import 'dart:async';

import 'package:bouncer/widgets/ball.dart';
import 'package:bouncer/widgets/brick.dart';
import 'package:bouncer/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'cover_screen.dart';
import 'gameover_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<StatefulWidget> createState() => GameScreenState();
}

enum Direction { UP, DOWN, LEFT, RIGHT }

class GameScreenState extends State {
  late double x, y, z;
  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
        if (y / 100 + playerX > -1 && y / 100 + playerX + playerWidth < 1) {
          playerX = playerX + y / 100;
        }
      });
    });
  }

  double playerWidth = 0.25;
  double playerY = 0.9;
  double playerX = 0;

  bool isGameStarted = false;
  bool isGameOver = false;

  double ballX = 0;
  double ballY = 0;
  var ballXDirection = Direction.LEFT;
  var ballYDirection = Direction.DOWN;
  var ballXinrement = 0.01;
  var ballYinrement = 0.01;

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
  // bool brickBroken = false;

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

  bool gameOverCheck() {
    return ballY >= 1.1;
  }

  void resetGame() {
    setState(() {
      ballX = 0;
      ballY = 0;
      ballXDirection = Direction.LEFT;
      ballYDirection = Direction.DOWN;
      ballXinrement = 0.01;
      ballYinrement = 0.01;
      isGameStarted = false;
      isGameOver = false;
    });
  }

  void moveBall() {
    //move horisontally
    if (ballXDirection == Direction.LEFT) {
      setState(() {
        ballX -= ballXinrement;
      });
    } else if (ballXDirection == Direction.RIGHT) {
      setState(() {
        ballX += ballXinrement;
      });
    }

    //move vertically
    if (ballYDirection == Direction.DOWN) {
      // setState(() {
      ballY += ballYinrement;
      // });
    } else if (ballYDirection == Direction.UP) {
      // setState(() {
      ballY -= ballYinrement;
      // });
    }
  }

  debug(String type) {
    if (type == "player") {
      print("playerX {$playerX}, playerY{$playerY}");
    } else {
      print("ballX{$ballX}, ballY{$ballY}");
    }
  }

  updateDirection() {
    //if ball hits up side of screen
    if (ballY <= -1) {
      ballYDirection = Direction.DOWN;
    }
    //if ball hits player pad
    else if (ballY >= playerY &&
        ballX >= playerX &&
        ballX <= playerX + playerWidth) {
      ballYDirection = Direction.UP;
    }
    //if ball hits left side of a screen
    if (ballX <= -1.0) {
      ballXDirection = Direction.RIGHT;
    }
    //if ball hits right side of a screen
    else if (ballX >= 1.0) {
      ballXDirection = Direction.LEFT;
    }
  }

  checkForBrokenBricks() {
    // print(myBricks[0][2]);
    for (int i = 0; i < myBricks.length; i++) {
      var x = myBricks[i][2] as double;
      var y = myBricks[i][3] as double;
      if (ballX >= x &&
          ballX <= x + brickWidth &&
          ballY <= y + brickHeight &&
          myBricks[i][4] == false) {
        setState(() {
          myBricks[i][4] = true;
          ballXDirection = Direction.RIGHT;
          ballYDirection = Direction.DOWN;
        });
      }
    }
  }

  // movePlayer() {
  //   setState(() {
  //     if (y / 100 + playerX > -1 && y / 100 + playerX + playerWidth/100 < 1) {
  //       playerX = playerX + y / 100;
  //     }
  //   });
  // }

  void startGame() {
    if (!isGameStarted) {
      isGameStarted = true;
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        // debug("ball");
        // setState(() {
        // movePlayer();
        updateDirection();
        moveBall();

        if (gameOverCheck() || isNoBricksLeft()) {
          timer.cancel();
          // setState(() {
          isGameOver = true;

          // });
        }
        checkForBrokenBricks();
        // print(isGameOver);
      });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Stack(
              children: [
                CoverScreen(isGameStarted: isGameStarted),
                Ball(x: ballX, y: ballY),
                Player(x: playerX, y: playerY, playerWidth: playerWidth),
                GameOverScreen(state: isGameOver, f: resetGame),
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
        ));
  }
}
