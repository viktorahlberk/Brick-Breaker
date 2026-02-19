import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<GameViewModel, int>(
      builder: (__, score, _) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'Score',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  score.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
      selector: (_, GameViewModel vm) {
        return vm.scoreManager.score;
      },
    );
  }
}
