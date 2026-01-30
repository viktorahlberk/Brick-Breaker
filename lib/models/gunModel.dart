import 'dart:developer';

import 'package:bouncer/models/bulletModel.dart';
import 'package:flutter/material.dart';

class GunModel {
  double width = 3.0;
  double height = 30.0;
  Color color = Colors.red;
  double shootingSpeed = 1.0;
  double firerateDelay = 1;
  double elapsed = 0;
  List<BulletModel> activeBullets = [];

  update(dt, shootingPoint) {
    tryShoot(dt, shootingPoint);
    for (var b in activeBullets) {
      b.move();
    }
  }

  tryShoot(dt, shootingPoint) {
    elapsed += dt;
    if (elapsed > firerateDelay) {
      shoot(shootingPoint);
    }
  }

  shoot(shootingPoint) {
    elapsed = 0;
    activeBullets.add(BulletModel(shootingPoint));
  }
}
