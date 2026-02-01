import 'dart:developer';

import 'package:bouncer/inputController.dart';
import 'package:bouncer/viewModels/gameViewModel.dart';
import 'package:bouncer/views/ballWidget.dart';
import 'package:bouncer/views/bonusWidget.dart';
import 'package:bouncer/views/brickWidget.dart';
import 'package:bouncer/views/bulletLayerView.dart';
import 'package:bouncer/views/gunWidget.dart';
import 'package:bouncer/views/levelCompleteScreen.dart.dart';
import 'package:bouncer/views/platformWidget.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameViewModel>();
    final input = context.watch<InputController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (game.gameState == GameState.levelCompleted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LevelCompleteScreen(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          // debugPrint(details.localPosition.toString());
          // final x = details.localPosition.dx;
          // final platformX = game.platformViewModel.position.dx;

          // if (x < platformX) {
          //   input.pressLeft();
          // } else {
          //   input.pressRight();
          // }
          // final screenWidth = MediaQuery.of(context).size.width;
          // final center = screenWidth / 2;
          // double platformCenter = game.platformViewModel.position.dx;
          // final delta = (details.localPosition.dx - center) / center;
          // double tapPosition = details.localPosition.dx;
          // if (tapPosition > platformCenter) {
          input.setTarget(details.localPosition.dx);
          // } else if (tapPosition < platformCenter) {
          // input.setAxis(-1);
          // }
        },
        onPanEnd: (_) {
          // input.releaseLeft();
          // input.releaseRight();
          input.resetTarget();
        },
        child: Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            final key = event.logicalKey.keyLabel.toLowerCase();

            if (event is KeyDownEvent) {
              if (key == 'a' || key == 'arrowleft') {
                input.pressLeft();
                return KeyEventResult.handled;
              }
              if (key == 'd' || key == 'arrowright') {
                input.pressRight();
                return KeyEventResult.handled;
              }
            }

            if (event is KeyUpEvent) {
              if (key == 'a' || key == 'arrowleft') {
                input.releaseLeft();
                return KeyEventResult.handled;
              }
              if (key == 'd' || key == 'arrowright') {
                input.releaseRight();
                return KeyEventResult.handled;
              }
            }

            return KeyEventResult.handled;
          },
          child: Stack(
            children: [
              const GunWidget(),
              const BallWidget(),
              const PlatformWidget(),
              const BulletLayerView(),
              ...game.brickViewModel.bricks
                  .map((brick) => BrickWidget(model: brick)),
              ...game.bonusManager.pickups.map((vm) => BonusWidget(vm)),
              CustomPaint(
                painter: ParticlePainter(game.particleSystem),
                size: Size.infinite,
              ),

              if (game.shouldShowActionButton)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (game.gameState == GameState.gameOver)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'ИГРА ОКОНЧЕНА',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 32,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ElevatedButton.icon(
                        onPressed: game.onActionButtonPressed,
                        icon: Icon(game.getButtonIcon(), size: 30),
                        label: Text(
                          game.getButtonText(),
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
              if (game.gameState == GameState.playing)
                Positioned(
                  top: 50,
                  right: 20,
                  child: IconButton(
                    onPressed: game.pauseGame,
                    icon: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
