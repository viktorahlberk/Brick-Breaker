import 'package:bouncer/features/game/managers/game_loop_manager.dart';

class GameCoordinator {
  GameCoordinator();

  var _gameLoop;

  initNewGame() {
    // Создаём игровой цикл с callback'ом
    // _gameLoop = GameLoopManager(onUpdate: _onUpdate)..start();

    // Инициализируем уровень
    // levelManager.resetLevel();
  }
}
