import 'package:bouncer/inputController.dart';
import 'package:bouncer/particles.dart';
import 'package:bouncer/viewModels/gameViewModel.dart';
import 'package:bouncer/views/ballWidget.dart';
import 'package:bouncer/views/bonusWidget.dart';
import 'package:bouncer/views/brickWidget.dart';
import 'package:bouncer/views/bulletLayerView.dart';
import 'package:bouncer/views/gunWidget.dart';
import 'package:bouncer/views/platformWidget.dart';
import 'package:bouncer/views/upperPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameViewModel>();
    final input = context.watch<InputController>();

    final size = MediaQuery.of(context).size;

    final hudHeight = size.height * 0.1;
    final platformZoneHeight = size.height * 0.15;
    final inputZoneHeight = size.height * 0.12;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ================= GAME FIELD =================
          Positioned(
            top: hudHeight,
            left: 0,
            right: 0,
            bottom: inputZoneHeight,
            child: Stack(
              children: [
                const BallWidget(),
                const BulletLayerView(),
                const PlatformWidget(),
                ...game.brickViewModel.bricks.map((b) => BrickWidget(model: b)),
                ...game.bonusManager.bonuses.map((b) => BonusWidget(bonus: b)),
                CustomPaint(
                  painter: ParticlePainter(game.particleSystem),
                  size: Size.infinite,
                ),
              ],
            ),
          ),

          // ================= HUD =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: hudHeight,
            child: UpperPanel(g: game),
          ),

          // ================= PLATFORM ZONE =================
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: inputZoneHeight,
          //   height: platformZoneHeight,
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: const [
          //       PlatformWidget(),
          //       GunWidget(),
          //     ],
          //   ),
          // ),

          // ================= INPUT ZONE =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: inputZoneHeight,
            child: _InputLayer(input: input),
          ),

          // ================= OVERLAY =================
          // if (game.shouldShowActionButton) Center(child: _Overlay(game)),
        ],
      ),
    );
  }
}

class _InputLayer extends StatelessWidget {
  final InputController input;

  const _InputLayer({required this.input});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) {
        final key = event.logicalKey.keyLabel.toLowerCase();

        if (event is KeyDownEvent) {
          if (key == 'a' || key == 'arrowleft') input.pressLeft();
          if (key == 'd' || key == 'arrowright') input.pressRight();
        }

        if (event is KeyUpEvent) {
          if (key == 'a' || key == 'arrowleft') input.releaseLeft();
          if (key == 'd' || key == 'arrowright') input.releaseRight();
        }

        return KeyEventResult.handled;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (d) {
          if (d.delta.dx < 0) {
            input.pressLeft();
          } else {
            input.pressRight();
          }
        },
        onPanEnd: (_) {
          input.releaseLeft();
          input.releaseRight();
        },
      ),
    );
  }
}
