import 'package:flutter/material.dart';

enum InputType { touch, key, sensor }

class InputController extends ChangeNotifier {
  // input
  InputType inputType = InputType.touch;
  bool _leftPressed = false;
  bool _rightPressed = false;

  double _axis = 0;
  double get axis => _axis;

  double? _tapTarget;
  double? get tapTarget => _tapTarget;

  // time
  double _timeScale = 1;
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

  void setTarget(double value) {
    // debugPrint(value.toString());
    _tapTarget = value;
    // notifyListeners();
  }

  void resetTarget() {
    if (_tapTarget == null) return;
    _tapTarget = null;
    // notifyListeners();
  }

  // ===== time =====
  //TODO Make Time Service class.
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

  void reset() {
    _leftPressed = false;
    _rightPressed = false;
    _axis = 0;
    _tapTarget = null;
    _timeScale = 1.0;
    _paused = false;
    notifyListeners();
  }
}

