import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/core/particles.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusWidget.dart';
// import 'package:bouncer/features/bosses/architect/domain/architect_boss.dart';
import 'package:bouncer/features/bosses/architect/presentacion/architect_boss_widget.dart';
import 'package:bouncer/features/game/gameCoordinator.dart';
// import 'package:bouncer/features/bosses/architect/presentacion/architect_viewmodel.dart';
import 'package:bouncer/features/game/presentacion/screens/bulletLayerView.dart';
import 'package:bouncer/features/game/presentacion/screens/levelCompleteScreen.dart';
import 'package:bouncer/features/game/presentacion/widgets/ballWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/brickWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/gunWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/levelCompleteOverlay.dart';
import 'package:bouncer/features/game/presentacion/widgets/platformWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/scoreWidget.dart';
import 'package:bouncer/features/game/presentacion/widgets/screenFlashOverlay.dart';
import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // bool _levelCompleteRouteOpen = false;

  // void _maybeOpenLevelComplete(GameState state) {
  //   if (state != GameState.levelCompleted) {
  //     _levelCompleteRouteOpen = false;
  //     return;
  //   }

  //   if (_levelCompleteRouteOpen || !mounted) return;
  //   _levelCompleteRouteOpen = true;

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     Navigator.of(context)
  //         .push(
  //       MaterialPageRoute(
  //         builder: (_) => ChangeNotifierProvider.value(
  //           value: context.read<GameViewModel>(),
  //           child: const LevelCompleteScreen(),
  //         ),
  //       ),
  //     )
  //         .then((_) {
  //       if (mounted) {
  //         _levelCompleteRouteOpen = false;
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final input = context.read<InputController>();
    // final architectViewModel =
    //     context.select((GameViewModel vm) => vm.architectViewModel);

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
              ScoreWidget(),
              GunWidget(),
              BallWidget(),
              PlatformWidget(),
              BulletLayerView(),
              _BricksLayer(),
              _BonusesLayer(),
              _ParticlesLayer(),
              LevelCompleteOverlay(),
              _OverlayLayer(),
              _PauseButton(),
              // _SettingsButton(),
              ScreenFlashOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BricksLayer extends StatelessWidget {
  const _BricksLayer();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameCoordinator>(
      builder: (_, game, __) => Stack(
        children:
            game.bricks.map((brick) => BrickWidget(model: brick)).toList(),
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
                  icon: Icon(uiState.buttonIcon, size: 30),
                  label: Text(
                    uiState.buttonText,
                    style: const TextStyle(fontSize: 18),
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
