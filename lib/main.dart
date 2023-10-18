import 'package:bouncer/screens/game_screen.dart';
import 'package:flutter/material.dart';
// import 'widgets/player.dart';
// import 'widgets/ball.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
// SystemChrome.setEnabledSystemUIOverlays([]);
  // SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
    // );
    // );
  }
}
