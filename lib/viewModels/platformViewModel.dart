import 'package:bouncer/models/platformModel.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  late PlatformModel _model;

  PlatformViewModel(Size screenSize) {
    _model = PlatformModel(screenSize: screenSize);
  }

  double get x => _model.x;
  double get y => _model.y;
  double get width => _model.width;
  double get height => _model.height;
  Rect get rect => _model.rect;

  void moveLeft() {
    _model.moveLeft();
    notifyListeners();
  }

  void moveRight() {
    _model.moveRight();
    notifyListeners();
  }
}
