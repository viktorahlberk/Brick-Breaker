import 'package:bouncer/features/bonuses/bonusEffect.dart';
import 'package:bouncer/features/bonuses/bonusType.dart';
import 'package:bouncer/features/bonuses/bonusManager.dart';
import 'package:bouncer/features/bonuses/effects/bigPlatformEffect.dart';
import 'package:bouncer/features/bonuses/effects/platformGunEffect.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';

/// Активатор бонусов
///
/// ТЕОРИЯ: Single Responsibility Principle
/// Этот класс отвечает ТОЛЬКО за:
/// - Создание эффектов бонусов
/// - Применение эффектов
/// - Регистрацию эффектов в BonusManager
///
/// ПРЕИМУЩЕСТВА:
/// ✅ GameViewModel не знает о конкретных бонусах
/// ✅ Легко добавлять новые бонусы
/// ✅ Вся логика активации в одном месте
/// ✅ Легко тестировать
///
/// ИСПОЛЬЗОВАНИЕ:
/// ```dart
/// bonusManager.checkCollect(
///   platformViewModel,
///   bonusActivator.activate, // ← Просто передаём метод
/// );
/// ```
class BonusActivator {
  final PlatformViewModel platformViewModel;
  final BonusManager bonusManager;

  BonusActivator({
    required this.platformViewModel,
    required this.bonusManager,
  });

  /// Активировать бонус
  ///
  /// Создаёт эффект, применяет его и регистрирует в менеджере
  ///
  /// @param type - тип бонуса для активации
  void activate(BonusType type) {
    final effect = _createEffect(type);

    if (effect != null) {
      effect.onApply();
      bonusManager.registerActiveEffect(effect);
    }
  }

  /// Создать эффект для бонуса
  ///
  /// Factory метод для создания конкретных эффектов
  ///
  /// ДОБАВЛЕНИЕ НОВОГО БОНУСА:
  /// 1. Добавьте новый case в switch
  /// 2. Создайте и верните новый эффект
  /// 3. Всё! Не нужно менять GameViewModel
  ///
  /// @param type - тип бонуса
  /// @return эффект или null если бонус не поддерживается
  BonusEffect? _createEffect(BonusType type) {
    switch (type) {
      // Увеличение платформы
      case BonusType.bigPlatform:
        return BigPlatformEffect(platformViewModel: platformViewModel);

      // Пушка на платформе
      case BonusType.platformGun:
        return PlatformGunEffect(platformViewModel: platformViewModel);

      // Замедление времени
      // case BonusType.slowMotion:
      //   return SlowMotionEffect(timeScale: 0.5, duration: 5.0);

      // Несколько мячей
      // case BonusType.multiball:
      //   return MultiballEffect(ballViewModel: ballViewModel, count: 2);

      // Магнитная платформа
      // case BonusType.magneticPlatform:
      //   return MagneticPlatformEffect(platformViewModel: platformViewModel);

      // Огненный мяч (проходит сквозь кирпичи)
      // case BonusType.fireball:
      //   return FireballEffect(ballViewModel: ballViewModel);

      // Лазер (стреляет через всё поле)
      // case BonusType.laser:
      //   return LaserEffect(platformViewModel: platformViewModel);

      // Неизвестный тип бонуса
      default:
        return null;
    }
  }
}

// ========================================
// ПРИМЕРЫ ДОПОЛНИТЕЛЬНЫХ ЭФФЕКТОВ
// ========================================

// Пример: SlowMotionEffect
/*
class SlowMotionEffect implements BonusEffect {
  final InputController inputController;
  final double timeScale;
  final double duration;
  
  SlowMotionEffect({
    required this.inputController,
    required this.timeScale,
    required this.duration,
  });
  
  @override
  void onApply() {
    inputController.setSlowMotion(timeScale);
    
    Future.delayed(Duration(seconds: duration.toInt()), () {
      inputController.setSlowMotion(1.0);
    });
  }
  
  @override
  void onExpire() {
    inputController.setSlowMotion(1.0);
  }
}
*/

// Пример: MultiballEffect
/*
class MultiballEffect implements BonusEffect {
  final BallViewModel ballViewModel;
  final int count;
  
  MultiballEffect({
    required this.ballViewModel,
    required this.count,
  });
  
  @override
  void onApply() {
    for (int i = 0; i < count; i++) {
      ballViewModel.spawnExtraBall();
    }
  }
  
  @override
  void onExpire() {
    // Multiball не истекает
  }
}
*/

// ========================================
// ИНТЕРФЕЙС ДЛЯ ЭФФЕКТОВ
// ========================================

/// Базовый интерфейс для эффектов бонусов
/// 
/// Все эффекты должны имплементировать этот интерфейс
// abstract class BonusEffect {
//   /// Применить эффект
//   void onApply();
  
//   /// Эффект истёк (опционально)
//   void onExpire() {}
// }