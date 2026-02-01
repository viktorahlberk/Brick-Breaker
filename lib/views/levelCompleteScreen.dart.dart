import 'package:flutter/material.dart';

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
              onPressed: () => {},
              icon: Icon(Icons.fast_forward_rounded),
            ),
          ],
        )));
  }
}
