import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/presentacion/increasePlatformSizeWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GameViewModel, GameState>(
      selector: (_, vm) => vm.gameState,
      builder: (context, state, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child: state == GameState.levelCompleted
              ? _OverlayContent(
                  key: const ValueKey('level_complete'),
                )
              : const SizedBox(
                  key: ValueKey('empty'),
                ),
        );
      },
    );
  }
}

class _OverlayContent extends StatelessWidget {
  const _OverlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha((255 * 0.2).floor()),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "LEVEL COMPLETE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Choose upgrade",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              IncreasePlatformSizeWidget()
              // IconButton(
              //   onPressed: () {
              //     context.read<GameViewModel>().startNextLevel();
              //   },
              //   icon: const Icon(
              //     Icons.fast_forward,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
