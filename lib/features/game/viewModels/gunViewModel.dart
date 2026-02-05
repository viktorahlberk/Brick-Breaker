import 'dart:developer';

import 'package:bouncer/models/bulletModel.dart';
import 'package:bouncer/models/gunModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';

class GunViewModel extends ChangeNotifier {
  late GunModel _gunModel;
  late final PlatformViewModel _pvm;

  GunViewModel(this._pvm) {
    _gunModel = GunModel();
  }

  double get width => _gunModel.width;
  double get height => _gunModel.height;
  // Color get color => _gunModel.color;
  Offset get shootingPoint => Offset(_pvm.position.x, _pvm.position.y);
  List<BulletModel> get bulletsList => _gunModel.activeBullets;

  // shoot() {
  //   _gunModel.activeBullets.add(BulletModel(shootingPoint));
  // }

  update(dt) {
    if (_pvm.isGunActive) {
      _gunModel.update(dt, shootingPoint);
      notifyListeners();
    }
  }

  // removeBullet() {}
}

