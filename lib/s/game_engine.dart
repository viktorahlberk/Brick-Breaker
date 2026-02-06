// import 'package:bouncer/coordinators/game_coordinator.dart';
// import 'package:bouncer/core/game_loop_manager.dart';
// // import 'package:bouncer/core/game_loop.dart';
// import 'package:bouncer/ui/game_loop.dart';

// class GameEngine {
//   final GameCoordinator coordinator;
//   late final GameLoopManager _gameLoop;

//   GameEngineState _state = GameEngineState.stopped;

//   GameEngine({
//     required this.coordinator,
//   }) {
//     _gameLoop = GameLoopManager(
//       onUpdate: _onUpdate,
//     );
//   }

//   /// Запуск игры
//   void start() {
//     if (_state == GameEngineState.running) return;

//     _state = GameEngineState.running;
//     // coordinator.start();
//     _gameLoop.start();
//   }

//   /// Остановка игры
//   void stop() {
//     if (_state == GameEngineState.stopped) return;

//     _state = GameEngineState.stopped;
//     _gameLoop.stop();
//     // coordinator.stop();
//   }

//   /// Пауза
//   void pause() {
//     if (_state != GameEngineState.running) return;

//     _state = GameEngineState.paused;
//     // _gameLoop.pause();
//     // coordinator.pause();
//   }

//   /// Возобновление
//   void resume() {
//     if (_state != GameEngineState.paused) return;

//     _state = GameEngineState.running;
//     // _gameLoop.resume();
//     // coordinator.resume();
//   }

//   void _onUpdate(double dt) {
//     if (_state != GameEngineState.running) return;

//     // coordinator.update(dt);
//   }

//   GameEngineState get state => _state;
//   bool get isRunning => _state == GameEngineState.running;
//   bool get isPaused => _state == GameEngineState.paused;
//   bool get isStopped => _state == GameEngineState.stopped;
// }

// enum GameEngineState {
//   stopped,
//   running,
//   paused,
// }
