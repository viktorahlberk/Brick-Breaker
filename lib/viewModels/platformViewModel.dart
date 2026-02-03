import 'package:bouncer/models/platformModel.dart';
import 'package:flutter/material.dart';

class PlatformViewModel extends ChangeNotifier {
  final PlatformModel _platformModel;
  Size screenSize;
  Offset _position;
  double baseWidth;
  double width;
  double scale = 1;
  bool scaled = false;
  bool isGunActive = false;

  /// Максимальная скорость платформы (px/sec)
  final double speed = 600;

  /// Текущая горизонтальная скорость
  double velocityX = 0;

  PlatformViewModel(this.screenSize)
      : _platformModel = PlatformModel(),
        _position = Offset(screenSize.width / 2, screenSize.height * 0.9),
        baseWidth = screenSize.width * 0.2,
        width = screenSize.width * 0.2;

  // ====== getters ======

  // double get baseWidth => _model.baseWidth;
  double get height => _platformModel.height;
  Offset get position => _position;
  Rect get rect => Rect.fromCenter(
        center: position,
        width: baseWidth * scale,
        height: height,
      );

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
    _clampToScreen(screenSize.width);
    notifyListeners();
  }

  void setScale(double value) {
    scale = value;
    width = baseWidth * value;
  }

  void normalizeScale() {
    width = baseWidth;
    scale = 1;
    scaled = false;
  }
  // ====== update ======

  void update(double dt) {
    _position = Offset(
      _position.dx + velocityX * dt,
      _position.dy,
    );

    _clampToScreen(screenSize.width);
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
