import 'dart:io';
import 'package:flutter/foundation.dart';

/// Типы платформ
enum PlatformType {
  android,
  iOS,
  web,
  windows,
  macOS,
  linux,
}

/// Детектор платформы
///
/// ТЕОРИЯ: Single Source of Truth
/// Все проверки платформы в одном месте
///
/// ИСПОЛЬЗОВАНИЕ:
/// ```dart
/// if (PlatformDetector.isMobile) {
///   // Мобильная логика
/// }
///
/// final inputType = PlatformDetector.defaultInputType;
/// ```
class PlatformDetector {
  PlatformDetector._(); // Private constructor - нельзя создать экземпляр

  /// Текущая платформа
  static PlatformType get current {
    if (kIsWeb) return PlatformType.web;

    switch (Platform.operatingSystem) {
      case 'android':
        return PlatformType.android;
      case 'ios':
        return PlatformType.iOS;
      case 'windows':
        return PlatformType.windows;
      case 'macos':
        return PlatformType.macOS;
      case 'linux':
        return PlatformType.linux;
      default:
        return PlatformType.linux; // Fallback
    }
  }

  /// Мобильная платформа?
  static bool get isMobile =>
      current == PlatformType.android || current == PlatformType.iOS;

  /// Desktop платформа?
  static bool get isDesktop =>
      current == PlatformType.windows ||
      current == PlatformType.macOS ||
      current == PlatformType.linux;

  /// Web платформа?
  static bool get isWeb => current == PlatformType.web;

  /// Android?
  static bool get isAndroid => current == PlatformType.android;

  /// iOS?
  static bool get isIOS => current == PlatformType.iOS;

  /// Тип ввода по умолчанию для текущей платформы
  ///
  /// Мобильные -> touch
  /// Desktop/Web -> keyboard
  static InputType get defaultInputType {
    return isMobile ? InputType.touch : InputType.key;
  }

  /// Название платформы (для логов)
  static String get platformName {
    switch (current) {
      case PlatformType.android:
        return 'Android';
      case PlatformType.iOS:
        return 'iOS';
      case PlatformType.web:
        return 'Web';
      case PlatformType.windows:
        return 'Windows';
      case PlatformType.macOS:
        return 'macOS';
      case PlatformType.linux:
        return 'Linux';
    }
  }

  /// Поддерживает ли платформа вибрацию?
  static bool get supportsVibration => isMobile;

  /// Поддерживает ли платформа клавиатуру?
  static bool get hasPhysicalKeyboard => isDesktop || isWeb;

  /// Поддерживает ли платформа touch?
  static bool get hasTouch => isMobile || isWeb;
}

/// Типы ввода (должны быть определены в вашем InputController)
/// Я добавил их здесь для примера
enum InputType {
  touch,
  key,
}
