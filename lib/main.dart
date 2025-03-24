import 'dart:ui';

import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:bouncer/controllers/ballWidgetController.dart'; // Make sure to import this
import 'package:bouncer/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

late FragmentProgram fragmentProgram;
Future<void> makeFragmentProgram() async {
  fragmentProgram =
      await FragmentProgram.fromAsset('assets/shaders/platform_shader.frag');
}

void main() async {
  makeFragmentProgram();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
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
            ],
            child: GameScreen(),
          );
        },
      ),
    );
  }
}
