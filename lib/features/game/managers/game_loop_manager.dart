// lib/core/game_loop_manager.dart

import 'package:flutter/scheduler.dart';

/// Менеджер игрового цикла
///
/// Отвечает за:
/// - Создание и управление Ticker'ом
/// - Вычисление delta time
/// - Вызов callback'ов каждый кадр
class GameLoopManager {
  final void Function(double dt) onUpdate;

  late final Ticker _ticker;
  Duration? _lastTick;
  bool _isRunning = false;

  GameLoopManager({required this.onUpdate}) {
    _ticker = Ticker(_onTick);
  }

  bool get isRunning => _isRunning;

  void start() {
    if (!_isRunning) {
      _lastTick = null; // Сброс для правильного первого кадра
      _ticker.start();
      _isRunning = true;
    }
  }

  void stop() {
    if (_isRunning) {
      _ticker.stop();
      _isRunning = false;
    }
  }

  void _onTick(Duration elapsed) {
    final dt = _calculateDelta(elapsed);
    onUpdate(dt);
  }

  double _calculateDelta(Duration elapsed) {
    final dt = _lastTick == null
        ? 1 / 60
        : (elapsed - _lastTick!).inMicroseconds / 1e6;
    _lastTick = elapsed;
    return dt.clamp(0.0, 0.033); // Максимум 33ms (30 FPS минимум)
  }

  void dispose() {
    _ticker.dispose();
  }
}
