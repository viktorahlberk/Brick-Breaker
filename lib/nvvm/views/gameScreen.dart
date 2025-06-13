import 'package:bouncer/nvvm/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/nvvm/views/ballWidget.dart';
import 'package:bouncer/nvvm/views/platformWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameViewModel = context.watch<GameViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          final keyLabel = event.logicalKey.keyLabel.toLowerCase();
          if (event is KeyDownEvent) {
            gameViewModel.onKeyDown(keyLabel);
            return KeyEventResult.handled;
          } else if (event is KeyUpEvent) {
            gameViewModel.onKeyUp(keyLabel);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            const BallWidget(),
            const PlatformWidget(),

            // Основная кнопка действия
            if (gameViewModel.gameState != GameState.playing)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Показываем сообщение о состоянии игры
                    if (gameViewModel.gameState == GameState.gameOver)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          // myBricks.isEmpty ?
                          // 'ПОБЕДА!' :
                          'ИГРА ОКОНЧЕНА',
                          style: TextStyle(
                            color:
                                // myBricks.isEmpty ?
                                // Colors.green
                                // :
                                Colors.red,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // ElevatedButton.icon(
                    //   onPressed: onActionButtonPressed,
                    //   icon: Icon(getButtonIcon(), size: 30),
                    //   label: Text(
                    //     getButtonText(),
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 30,
                    //       vertical: 15,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

            // Кнопка паузы во время игры
            if (gameViewModel.gameState == GameState.playing)
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

            // Индикатор состояния для отладки
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'State: ${gameViewModel.gameState}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Row(
            //       children: [
            //         IconButton(
            //             icon: const Icon(Icons.arrow_left, color: Colors.white),
            //             onPressed: () =>
            //                 gameViewModel.platformViewModel.moveLeft()),
            //         // gameViewModel.onKeyDown('a')),
            //         IconButton(
            //           icon: const Icon(Icons.arrow_right, color: Colors.white),
            //           onPressed: () =>
            //               gameViewModel.platformViewModel.moveRight(),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
