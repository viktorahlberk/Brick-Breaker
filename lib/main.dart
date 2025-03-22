import 'package:bouncer/controllers/gameController.dart';
import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:bouncer/controllers/ballWidgetController.dart'; // Make sure to import this
import 'package:bouncer/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen dimensions from the LayoutBuilder
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => PlatformWidgetController(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => BallWidgetController(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => GameController(),
              ),
            ],
            child: GameScreen(),
          );
        },
      ),
    );
  }
}
