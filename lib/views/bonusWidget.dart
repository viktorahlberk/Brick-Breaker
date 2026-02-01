import 'package:bouncer/bonuses/bonusPickupVmModel.dart';
import 'package:bouncer/bonuses/bonusType.dart';
import 'package:bouncer/models/bonusModel.dart';
import 'package:bouncer/viewModels/bonusViewModel.dart';
import 'package:flutter/material.dart';

class BonusWidget extends StatelessWidget {
  final BonusPickupViewModel bonusViewModel;

  const BonusWidget(this.bonusViewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bonusViewModel.model.position.dx,
      top: bonusViewModel.model.position.dy,
      child: Icon(
        _iconByType(bonusViewModel.model.type),
        color: Colors.yellow,
        size: 28,
      ),
    );
  }

  IconData _iconByType(BonusType type) {
    switch (type) {
      case BonusType.platformGun:
        return Icons.gps_fixed;
      // case BonusType.slowMotion:
      //   return Icons.timer;
      case BonusType.bigPlatform:
        return Icons.swap_horiz;
    }
  }
}
