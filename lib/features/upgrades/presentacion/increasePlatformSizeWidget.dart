import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/upgrades/effects/increasePlatformSizeEffect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncreasePlatformSizeWidget extends StatelessWidget {
  const IncreasePlatformSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var vm = Provider.of<GameViewModel>(context, listen: false);

        vm.addUpgrade(IncreasePlatformSizeEffect(0.2));
        vm.startNextLevel();
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Icon(
          Icons.swap_horiz,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
