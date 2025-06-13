import 'package:bouncer/nvvm/viewModels/ballViewModel.dart';
import 'package:bouncer/nvvm/viewModels/brickViewModel.dart';
import 'package:bouncer/nvvm/viewModels/gameScreenViewModel.dart';
import 'package:bouncer/nvvm/viewModels/platformViewModel.dart';
// import 'package:bouncer/nvvm/view/game_screen.dart';
import 'package:bouncer/nvvm/views/gameScreen.dart' show GameScreen;
import 'package:bouncer/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          var ps = ParticleSystem();
          var ball = BallViewModel(screenSize: size);
          var platform = PlatformViewModel(size);
          var bricks = BrickViewModel(particleSystem: ps);

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ball),
              ChangeNotifierProvider(create: (_) => platform),
              ChangeNotifierProvider(create: (_) => bricks),
              ChangeNotifierProxyProvider3(
                create: (_) {
                  return GameViewModel(
                    ballViewModel: ball,
                    platformViewModel: platform,
                    brickViewModel: bricks,
                    particleSystem: ps,
                  );
                },
                update: (BuildContext context,
                    BallViewModel ball,
                    PlatformViewModel platform,
                    BrickViewModel bricks,
                    gameViewModel) {
                  gameViewModel!.updateDependencies(
                    ballViewModel: ball,
                    platformViewModel: platform,
                    brickViewModel: bricks,
                  );
                  return gameViewModel;
                },
              ),
            ],
            child: GameScreen(),
          );
        },
      ),
    );
  }
}
