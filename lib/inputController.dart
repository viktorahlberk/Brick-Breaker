import 'package:flutter/material.dart';

class InputController extends ChangeNotifier {
  // input
  bool _leftPressed = false;
  bool _rightPressed = false;

  double _axis = 0;
  double get axis => _axis;

  // time
  double _timeScale = 0.5;
  double get timeScale => _timeScale;

  bool _paused = false;
  bool get paused => _paused;

  // ===== input =====
  void pressLeft() {
    _leftPressed = true;
    _recalcAxis();
  }

  void releaseLeft() {
    _leftPressed = false;
    _recalcAxis();
  }

  void pressRight() {
    _rightPressed = true;
    _recalcAxis();
  }

  void releaseRight() {
    _rightPressed = false;
    _recalcAxis();
  }

  void _recalcAxis() {
    if (_leftPressed && !_rightPressed)
      _axis = -1;
    else if (_rightPressed && !_leftPressed)
      _axis = 1;
    else
      _axis = 0;
    notifyListeners();
  }

  // ===== time =====
  void setSlowMotion(double scale) {
    _timeScale = scale.clamp(0.05, 1.0);
    notifyListeners();
  }

  void resetTimeScale() {
    _timeScale = 1.0;
    notifyListeners();
  }

  void togglePause() {
    _paused = !_paused;
    notifyListeners();
  }
}
