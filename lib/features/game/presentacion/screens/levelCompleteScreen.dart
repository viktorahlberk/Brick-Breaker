import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level done!',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                context.read<GameViewModel>().startNextLevel();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.fast_forward_rounded),
            ),
          ],
        )));
  }
}
