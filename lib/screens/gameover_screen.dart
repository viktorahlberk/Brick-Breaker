import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final bool state;
  final f;
  const GameOverScreen({super.key, required this.state, required this.f});
  @override
  Widget build(BuildContext context) {
    return state  
        ? Center(
            child: Container(
              alignment: const Alignment(0, -0.3),
              child: Column(
                children: [
                  const Text('G A M E  O V E R',
                      style: TextStyle(color: Colors.white)),
                  ElevatedButton(
                    onPressed: () {
                      f();
                    },
                    child: const Text('Play again'),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
