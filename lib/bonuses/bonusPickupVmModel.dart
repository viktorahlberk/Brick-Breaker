import 'dart:ui';

import 'package:bouncer/bonuses/bonusModel.dart';

class BonusPickupViewModel {
  BonusPickupViewModel({required this.model});
  final BonusModel model;
  late Rect rect;
  double fallingSpeed = 2;
  bool collected = false;

  void update(double dt) {
    model.position =
        Offset(model.position.dx, model.position.dy + fallingSpeed + dt);
  }
}
