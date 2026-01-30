import 'dart:developer';

import 'package:bouncer/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/views/ballWidget.dart';
import 'package:bouncer/views/brickWidget.dart';
import 'package:bouncer/views/bulletLayerView.dart';
import 'package:bouncer/views/gunWidget.dart';
import 'package:bouncer/views/platformWidget.dart';
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameViewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          gameViewModel.handleTapMoving(details);
        },
        onPanEnd: (_) {
          gameViewModel.stopPlatformMovement();
        },
        child: Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            final keyLabel = event.logicalKey.keyLabel.toLowerCase();
            if (event is KeyDownEvent) {
              gameViewModel.onKeyDown(keyLabel);
              return KeyEventResult.handled;
            } else if (event is KeyUpEvent) {
              gameViewModel.onKeyUp(keyLabel);
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Stack(
            children: [
              const Gunwidget(),
              const BallWidget(),
              const PlatformWidget(),
              const BulletLayerView(),
              ...gameViewModel.brickViewModel.bricks
                  .map((brick) => BrickWidget(model: brick)),

              CustomPaint(
                painter: ParticlePainter(gameViewModel.particleSystem),
                size: Size.infinite,
              ),

              if (gameViewModel.shouldShowActionButton)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (gameViewModel.gameState == GameState.gameOver)
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
                        onPressed: gameViewModel.onActionButtonPressed,
                        icon: Icon(gameViewModel.getButtonIcon(), size: 30),
                        label: Text(
                          gameViewModel.getButtonText(),
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
              if (gameViewModel.gameState == GameState.playing)
                Positioned(
                  top: 50,
                  right: 20,
                  child: IconButton(
                    onPressed: gameViewModel.pauseGame,
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
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
