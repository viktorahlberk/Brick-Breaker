import 'dart:developer';

import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/game/presentacion/widgets/ballWidget.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/brickWidget.dart';
import 'package:bouncer/features/game/presentacion/screens/bulletLayerView.dart';
import 'package:bouncer/features/game/presentacion/widgets/gunWidget.dart';
import 'package:bouncer/features/game/presentacion/screens/levelCompleteScreen.dart';
import 'package:bouncer/features/game/presentacion/widgets/platformWidget.dart';
import 'package:bouncer/core/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // GameEngine? _engine;
  bool _initialized = false;
  // void _initialize() {
  //   final size = MediaQuery.of(context).size;
  //   // final coordinator = GameCompositionRoot.create(size);

  //   // ✅ Просто создаём и запускаем движок
  //   // _engine = GameEngine(coordinator: coordinator);
  //   _engine!.start();
  // }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameViewModel>();
    final input = context.watch<InputController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (game.gameState == GameState.levelCompleted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<GameViewModel>(),
              child: const LevelCompleteScreen(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) {
          input.setTarget(details.localPosition.dx);
        },
        onPanEnd: (_) {
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

              if (game.uiState.shouldShowActionButton)
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
                        icon: Icon(game.uiState.buttonIcon, size: 30),
                        label: Text(
                          game.uiState.buttonText,
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
                  top: 20,
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
                top: 20,
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
