import 'package:bouncer/models/bonusModel.dart';
import 'package:bouncer/viewModels/bonusViewModel.dart';
import 'package:flutter/material.dart';

class BonusWidget extends StatelessWidget {
  final BonusViewModel bonus;

  const BonusWidget({super.key, required this.bonus});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bonus.model.position.dx,
      top: bonus.model.position.dy,
      child: Icon(
        _iconByType(bonus.model.type),
        color: Colors.yellow,
        size: 28,
      ),
    );
  }

  IconData _iconByType(BonusType type) {
    switch (type) {
      case BonusType.gun:
        return Icons.gps_fixed;
      // case BonusType.slowMotion:
      //   return Icons.timer;
      case BonusType.bigPlatform:
        return Icons.swap_horiz;
    }
  }
}
