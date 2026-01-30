import 'dart:developer';

import 'package:bouncer/models/bulletModel.dart';
import 'package:bouncer/models/gunModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';

class GunViewModel extends ChangeNotifier {
  late GunModel _model;
  late PlatformViewModel _pvm;

  GunViewModel(PlatformViewModel pvm) {
    _model = GunModel();
    _pvm = pvm;
  }

  double get width => _model.width;
  double get height => _model.height;
  Color get color => _model.color;
  Offset get shootingPoint =>
      Offset(_pvm.position.dx - width, _pvm.position.dy);
  List<BulletModel> get bulletsList => _model.activeBullets;

  shoot() {
    _model.activeBullets.add(BulletModel(shootingPoint));
  }

  update(dt) {
    _model.update(dt, shootingPoint);
    notifyListeners();
  }

  removeBullet() {}
}
