import 'package:bouncer/features/bonuses/domain/bonusType.dart';
import 'package:bouncer/features/bonuses/presentacion/bonusPickupVmModel.dart';
import 'package:flutter/material.dart';

class BonusWidget extends StatelessWidget {
  final BonusPickupViewModel bonusViewModel;

  const BonusWidget(this.bonusViewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bonusViewModel.model.position.dx,
      top: bonusViewModel.model.position.dy,
      child: _iconByType(
        bonusViewModel.model.type,
      ),
    );
  }

  Icon _iconByType(BonusType type) {
    switch (type) {
      case BonusType.platformGun:
        return Icon(
          Icons.gps_fixed,
          color: Colors.red,
          size: 28,
        );
      case BonusType.bigPlatform:
        return Icon(
          Icons.swap_horiz,
          color: Colors.yellow,
          size: 28,
        );
    }
  }
}
