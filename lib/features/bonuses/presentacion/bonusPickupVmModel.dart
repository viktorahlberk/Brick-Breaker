import 'dart:ui';

import 'package:bouncer/features/bonuses/domain/bonusModel.dart';

class BonusPickupViewModel {
  BonusPickupViewModel({required this.model});
  final BonusModel model;
  double fallingSpeed = 2;
  bool collected = false;

  Rect get rect => Rect.fromCenter(
        center: model.position,
        width: 40, // ширина бонуса
        height: 40, // высота бонуса
      );

  void update(double dt) {
    model.position =
        Offset(model.position.dx, model.position.dy + fallingSpeed + dt);
  }
}
