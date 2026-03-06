import 'package:bouncer/composition_root.dart';
import 'package:bouncer/features/game/presentacion/screens/gameScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MainApp());
}

/// Корневой Widget приложения
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppInitializer(),
    );
  }
}

/// Widget для инициализации Composition Root
///
/// ТЕОРИЯ: Почему отдельный Widget?
///
/// 1. LayoutBuilder даёт нам размер экрана (constraints)
/// 2. Размер экрана нужен для создания ViewModels (например, BallViewModel)
/// 3. Инициализация должна произойти ОДИН раз, не при каждом rebuild
/// 4. StatefulWidget позволяет контролировать lifecycle (_isInitialized флаг)
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  AppCompositionRoot? _compositionRoot;

  bool _isInitialized = false;

  @override
  void dispose() {
    _compositionRoot?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = Size(constraints.maxWidth, constraints.maxHeight);

        if (!_isInitialized) {
          print('🚀 Инициализация Composition Root...');
          _compositionRoot = AppCompositionRoot();
          _compositionRoot!.initialize(screenSize);
          _isInitialized = true;
          print('✅ Composition Root инициализирован');
        }

        return _buildProvidersTree(_compositionRoot!);
      },
    );
  }

  Widget _buildProvidersTree(AppCompositionRoot root) {
    return MultiProvider(
      providers: [
        // Core services
        ChangeNotifierProvider.value(value: root.inputController),
        ChangeNotifierProvider.value(value: root.flashController),
        // ChangeNotifierProvider.value(value: root.bonusManager),

        // ViewModels - порядок не важен, т.к. объекты уже созданы
        // ChangeNotifierProvider.value(value: root.ballViewModel),
        ChangeNotifierProvider.value(value: root.ballManager),
        ChangeNotifierProvider.value(value: root.platformViewModel),
        ChangeNotifierProvider.value(value: root.brickViewModel),
        ChangeNotifierProvider.value(value: root.gunViewModel),

        // Root ViewModel - главный ViewModel игры
        // ChangeNotifierProvider.value(value: root.gameViewModel),
        ChangeNotifierProvider.value(value: root.gameCoordinator),
      ],
      child: const GameScreen(),
    );
  }
}
