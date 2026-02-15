import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (BuildContext context, value, Widget? child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              value.scoreManager.score.toString(),
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        );
      },
    );
  }
}
