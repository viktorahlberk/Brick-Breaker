import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusWidget.dart';
import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:bouncer/features/game/presentacion/screens/bulletLayerView.dart';
import 'package:bouncer/features/game/presentacion/widgets/ballLayer.dart';
import 'package:bouncer/features/game/presentacion/widgets/brickWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/gunWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/levelCompleteOverlay.dart';
import 'package:bouncer/features/game/presentacion/widgets/platformWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/scoreWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/screenFlashOverlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final input = context.read<InputController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (details) => input.setTarget(details.localPosition.dx),
        onPanEnd: (_) => input.resetTarget(),
        child: Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            final key = event.logicalKey.keyLabel.toLowerCase();

            if (event is KeyDownEvent) {
              if (key == 'a' || key == 'arrowleft') {
                input.pressLeft();
              } else if (key == 'd' || key == 'arrowright') {
                input.pressRight();
              }
              return KeyEventResult.handled;
            }

            if (event is KeyUpEvent) {
              if (key == 'a' || key == 'arrowleft') {
                input.releaseLeft();
              } else if (key == 'd' || key == 'arrowright') {
                input.releaseRight();
              }
              return KeyEventResult.handled;
            }

            return KeyEventResult.handled;
          },
          child: Stack(
            children: [
              // ArchitectBossWidget(vm: architectViewModel),
              _LevelWidget(),
              ScoreWidget(),
              GunWidget(),
              BallLayer(),
              PlatformWidget(),
              BulletLayerView(),
              _BricksLayer(),
              // _BonusesLayer(),
              _ParticlesLayer(),
              LevelCompleteOverlay(),
              _OverlayLayer(),
              _PauseButton(),
              _BonusesSideDrawer(),
              // _SettingsButton(),
              ScreenFlashOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelWidget extends StatelessWidget {
  const _LevelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        'Level ${context.read<GameCoordinator>().level}',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _BricksLayer extends StatefulWidget {
  const _BricksLayer();

  @override
  State<_BricksLayer> createState() => _BricksLayerState();
}

class _BricksLayerState extends State<_BricksLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  GameState? state;
  final delayStep = 0.07;
  final brickDuration = 0.7;
  late double totalAnimationTime;

  @override
  void initState() {
    super.initState();
    final bricksCount = context.read<GameCoordinator>().bricks.length;
    totalAnimationTime = (bricksCount - 1) * delayStep + brickDuration;

    controller = AnimationController(
      duration: Duration(milliseconds: (totalAnimationTime * 1000).toInt()),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    GameState? prevState;
    return Consumer<GameCoordinator>(
      builder: (_, game, __) => AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          if (prevState != game.gameState) {
            prevState = game.gameState;

            if (game.gameState == GameState.initial) {
              controller
                ..reset()
                ..forward();
            }
          }
          return Stack(
              children: game.bricks.asMap().entries.map((entry) {
            final index = entry.key;
            final brick = entry.value;
            final time = controller.value * totalAnimationTime;
            final delay = index * delayStep;
            double progress = ((time - delay) / brickDuration).clamp(0.0, 1.0);
            final curve = Curves.easeOutCubic.transform(progress);

            /// offset сверху
            final offsetY = -screenHeight * (1 - curve);

            return Transform.translate(
              offset: Offset(0, offsetY),
              child: Opacity(
                opacity: progress,
                child: BrickWidget(model: brick),
              ),
            );
          }).toList());
        },
      ),
    );
  }
}

class _BonusesLayer extends StatelessWidget {
  const _BonusesLayer();

  @override
  Widget build(BuildContext context) {
    // return Consumer<GameViewModel>(
    //   builder: (_, game, __) => Stack(
    //     children:
    //         game.bonusManager.pickups.map((vm) => BonusWidget(vm)).toList(),
    //   ),
    // );
    var pickups = context.read<GameCoordinator>().bonusesToPickup;
    return Stack(
      children: [
        ...pickups.map((vm) => BonusWidget(vm)),
      ],
    );
  }
}

class _ParticlesLayer extends StatelessWidget {
  const _ParticlesLayer();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameCoordinator>(
      builder: (_, game, __) => CustomPaint(
        painter: ParticlePainter(game.particleSystem),
        size: Size.infinite,
      ),
    );
  }
}

class _OverlayLayer extends StatelessWidget {
  const _OverlayLayer();

  @override
  Widget build(BuildContext context) {
    return Selector<GameCoordinator, GameState>(
      selector: (_, game) => game.gameState,
      builder: (_, state, __) {
        final game = context.read<GameCoordinator>();
        final uiState = game.uiState;

        if (!uiState.shouldShowActionButton) {
          return const SizedBox.shrink();
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state == GameState.gameOver)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Game over.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: game.onActionButtonPressed,
                  icon: Icon(
                    uiState.buttonIcon,
                    size: 30,
                    color: Colors.black,
                  ),
                  label: Text(
                    uiState.buttonText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton();

  @override
  Widget build(BuildContext context) {
    return Selector<GameCoordinator, GameState>(
      selector: (_, game) => game.gameState,
      builder: (_, state, __) {
        if (state != GameState.playing) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            onPressed: () => context.read<GameCoordinator>().pauseGame(),
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

class _BonusesSideDrawer extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
    onPressed: () {},
    icon: const Icon(
      Icons.star,
      color: Colors.white,
      size: 30,
    ),
  );;
  }
}

// class _SettingsButton extends StatelessWidget {
//   const _SettingsButton();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 20,
//       left: 20,
//       child: IconButton(
//         onPressed: () {},
//         icon: const Icon(
//           Icons.settings,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }
