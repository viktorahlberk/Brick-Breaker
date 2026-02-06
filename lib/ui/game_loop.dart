// import 'package:flutter/scheduler.dart';

// class GameLoop {
//   // final TickerProvider vsync;
//   final void Function(double dt) onUpdate;

//   Ticker? _ticker;
//   Duration _lastElapsed = Duration.zero;
//   bool _isRunning = false;

//   GameLoop({
//     // required this.vsync,
//     required this.onUpdate,
//   });

//   /// Запускает game loop
//   void start() {
//     if (_isRunning) return;

//     _isRunning = true;
//     _lastElapsed = Duration.zero;

//     // _ticker = vsync.createTicker(_tick);
//     _ticker!.start();
//   }

//   /// Останавливает game loop
//   void stop() {
//     if (!_isRunning) return;

//     _isRunning = false;
//     _ticker?.stop();
//     _ticker?.dispose();
//     _ticker = null;
//   }

//   /// Ставит game loop на паузу
//   void pause() {
//     if (!_isRunning) return;
//     _ticker?.stop();
//   }

//   /// Возобновляет game loop после паузы
//   void resume() {
//     if (!_isRunning) return;
//     _ticker?.start();
//   }

//   /// Основной метод, вызываемый каждый кадр
//   void _tick(Duration elapsed) {
//     if (!_isRunning) return;

//     // Вычисляем delta time (время с последнего кадра)
//     final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
//     _lastElapsed = elapsed;

//     // Вызываем callback с delta time
//     onUpdate(dt);
//   }

//   bool get isRunning => _isRunning;
//   bool get isPaused => _isRunning && (_ticker?.isActive == false);
// }
