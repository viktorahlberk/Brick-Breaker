import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  final bool isGameStarted;
  const CoverScreen({super.key, required this.isGameStarted});

  @override
  Widget build(BuildContext context) {
    return isGameStarted
        ? Container()
        : Container(
            alignment: const Alignment(0, -0.2),
            child: const Text('Tap to play',
                style: TextStyle(color: Colors.white)),
          );
  }
}
