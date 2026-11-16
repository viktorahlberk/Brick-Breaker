import 'package:bouncer/features/game/gameCoordinator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GameCoordinator, int>(
        builder: (__, score, _) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      score.toString(),
                      key: ValueKey<int>(score),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        selector: (_, GameCoordinator coordinator) => coordinator.score);
  }
}
