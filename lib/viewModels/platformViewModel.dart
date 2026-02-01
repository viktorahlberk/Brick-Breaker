import 'package:bouncer/models/platformModel.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  final PlatformModel _model;
  Offset _position;
  bool _scaleChanged = false;

  /// Максимальная скорость платформы (px/sec)
  final double speed = 600;

  /// Текущая горизонтальная скорость
  double velocityX = 0;

  PlatformViewModel(Size screenSize)
      : _model = PlatformModel(screenSize: screenSize),
        _position = Offset(screenSize.width / 2, screenSize.height * 0.9);

  // ====== getters ======

  double get width => _model.width;
  double get height => _model.height;
  Offset get position => _position;
  Rect get rect =>
      Rect.fromCenter(center: position, width: width, height: height);

  // ====== input ======

  /// axis ∈ [-1 .. 1]
  /// -1 — влево
  ///  0 — стоим
  ///  1 — вправо
  void setInput(double axis) {
    velocityX = axis.clamp(-1.0, 1.0) * speed;
  }

  void moveCenterTo(targetX, dt) {
    if (targetX == null) {
      return;
    }
    final centerX = _position.dx;
    final delta = targetX - centerX;

    if (delta.abs() < 1) return;

    final step = speed * dt;
    final move = delta.clamp(-step, step);

    _position = Offset(_position.dx + move, _position.dy);
    _clampToScreen(_model.screenSize.width);
    notifyListeners();
  }

  void setScale(double value) {
    if (_scaleChanged) return;
    _scaleChanged = true;
    _model.width = width * value;
  }

  void normalizeScale() {
    if (!_scaleChanged) return;
    _scaleChanged = false;
    _model.width = _model.initialWidth;
  }
  // ====== update ======

  void update(double dt) {
    _position = Offset(
      _position.dx + velocityX * dt,
      _position.dy,
    );

    _clampToScreen(_model.screenSize.width);
    notifyListeners();
  }

  // ====== helpers ======

  void _clampToScreen(double screenWidth) {
    final halfWidth = width / 2;

    _position = Offset(
      _position.dx.clamp(
        halfWidth,
        screenWidth - halfWidth,
      ),
      _position.dy,
    );
  }
}
