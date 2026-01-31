import 'package:bouncer/models/platformModel.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  final PlatformModel _model;
  bool _scaleChanged = false;

  /// Максимальная скорость платформы (px/sec)
  final double speed = 600;

  /// Текущая горизонтальная скорость
  double velocityX = 0;

  PlatformViewModel(Size screenSize)
      : _model = PlatformModel(screenSize: screenSize);

  // ====== getters ======

  Offset get position => _model.position;
  double get width => _model.width;
  double get height => _model.height;
  Rect get rect => _model.rect;

  // ====== input ======

  /// axis ∈ [-1 .. 1]
  /// -1 — влево
  ///  0 — стоим
  ///  1 — вправо
  void setInput(double axis) {
    velocityX = axis.clamp(-1.0, 1.0) * speed;
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
    _model.position = Offset(
      _model.position.dx + velocityX * dt,
      _model.position.dy,
    );

    _clampToScreen(_model.screenSize.width);
    notifyListeners();
  }

  // ====== helpers ======

  void _clampToScreen(double screenWidth) {
    final halfWidth = width / 2;

    _model.position = Offset(
      _model.position.dx.clamp(
        halfWidth,
        screenWidth - halfWidth,
      ),
      _model.position.dy,
    );
  }
}
