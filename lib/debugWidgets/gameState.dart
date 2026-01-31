import 'package:bouncer/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';

class GameStateWidget extends StatelessWidget {
  const GameStateWidget({
    super.key,
    required this.gameViewModel,
  });

  final GameViewModel gameViewModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'State: ${gameViewModel.gameState}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
