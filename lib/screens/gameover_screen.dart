import 'package:bouncer/controllers/ballWidgetController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key, required this.onRestart});
  final VoidCallback onRestart;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: const Alignment(0, -0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('G A M E  O V E R',
                    style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    onRestart();
                  },
                  child: const Text('Play again'),
                )
              ],
            ),
          )),
    );
  }
}
