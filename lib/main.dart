import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/game/managers/collisionManager.dart';
import 'package:bouncer/core/inputController.dart';
import 'package:bouncer/features/game/level/levelManager.dart';
import 'package:bouncer/core/timeManager.dart';
import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/views/gameScreen.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:bouncer/features/game/viewModels/brickViewModel.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/core/particles.dart';
// import 'package:bouncer/features/game/views/levelCompleteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // debugPrintRebuildDirtyWidgets = true;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        ParticleSystem ps = ParticleSystem();
        BallViewModel ball = BallViewModel(screenSize: size);
        PlatformViewModel platform = PlatformViewModel(size);
        BrickViewModel bricks =
            BrickViewModel(particleSystem: ps, screenSize: size);
        GunViewModel gun = GunViewModel(platform);
        InputController input = InputController();
        BonusManager bonusManager = BonusManager();
        TimeManager timeManager = TimeManager(input);
        LevelManager levelManager = LevelManager(
          brickViewModel: bricks,
          ballViewModel: ball,
          timeManager: timeManager,
          platformViewModel: platform,
        );
        CollisionManager collisionManager = CollisionManager(
            brickViewModel: bricks,
            particleSystem: ps,
            gunViewModel: gun,
            bonusManager: bonusManager,
            ballViewModel: ball);

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ball),
            ChangeNotifierProvider(create: (_) => platform),
            ChangeNotifierProvider(create: (_) => bricks),
            ChangeNotifierProvider(create: (_) => gun),
            ChangeNotifierProvider(create: (_) => input),
            ChangeNotifierProxyProvider3(
              create: (_) {
                return GameViewModel(
                  ballViewModel: ball,
                  platformViewModel: platform,
                  brickViewModel: bricks,
                  particleSystem: ps,
                  gunViewModel: gun,
                  input: input,
                  collisionManager: collisionManager,
                  levelManager: levelManager,
                  bonusManager: bonusManager,
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
                    particleSystem: ps,
                    gunViewModel: gun);
                return gameViewModel;
              },
            ),
          ],
          child: MaterialApp(
            // showPerformanceOverlay: true,
            // routes: ['complete',()=>LevelCompleteScreen()],
            // initialRoute: LevelCompleteScreen(),
            home: GameScreen(),
          ),
        );
      },
    );
  }
}

