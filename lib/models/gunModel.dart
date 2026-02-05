import 'dart:developer';

import 'package:bouncer/models/bulletModel.dart';
import 'package:flutter/material.dart';

class GunModel {
  double width = 6.0;
  double height = 30.0;
  // Color color = Colors.red;
  double shootingSpeed = 1.0;
  double firerateDelay = 1;
  double _elapsed = 0;
  final List<BulletModel> activeBullets = [];

  void update(double dt, Offset shootingPoint) {
    tryShoot(dt, shootingPoint);
    for (BulletModel b in activeBullets) {
      b.move();
    }
  }

  void tryShoot(double dt, Offset shootingPoint) {
    _elapsed += dt;
    if (_elapsed > firerateDelay) {
      _shoot(shootingPoint);
    }
  }

  void _shoot(Offset shootingPoint) {
    _elapsed = 0;
    activeBullets.add(BulletModel(shootingPoint));
  }
}

