import 'package:bouncer/models/platformModel.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  late PlatformModel _model;

  PlatformViewModel(Size screenSize) {
    _model = PlatformModel(screenSize: screenSize);
  }

  Offset get position => _model.position;
  double get width => _model.width;
  double get height => _model.height;
  double velocityX = 0;
  Rect get rect => _model.rect;
  bool isMovingLeft = false;
  bool isMovingRight = false;

  void moveLeft() {
    _model.moveLeft();
    notifyListeners();
  }

  void moveRight() {
    _model.moveRight();
    notifyListeners();
  }
}
