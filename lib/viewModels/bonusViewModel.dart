import 'dart:ui';

import 'package:bouncer/models/bonusModel.dart';

class BonusViewModel {
  final BonusModel model;
  bool collected = false;

  BonusViewModel(this.model);

//TODO Check width and height again. (hardcoded).
  get rect => Rect.fromCenter(center: model.position, width: 30, height: 30);

  void update(double dt) {
    model.position = Offset(
      model.position.dx,
      model.position.dy + model.fallSpeed * dt,
    );
  }
}
