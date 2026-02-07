import 'package:flutter/material.dart';
import 'package:bouncer/core/enums/game_state.dart';

/// UI-состояние для игры
///
/// ТЕОРИЯ: Separation of Concerns
/// Отделяем UI-логику от бизнес-логики
///
/// GameViewModel управляет игровым состоянием (GameState)
/// GameUIState преобразует игровое состояние в UI-элементы
///
/// ИСПОЛЬЗОВАНИЕ:
/// ```dart
/// final uiState = gameViewModel.uiState;
///
/// if (uiState.shouldShowActionButton) {
///   ElevatedButton(
///     child: Text(uiState.buttonText),
///     icon: Icon(uiState.buttonIcon),
///   )
/// }
/// ```
class GameUIState {
  final GameState gameState;

  GameUIState(this.gameState);

  // ========================================
  // ВИДИМОСТЬ ЭЛЕМЕНТОВ
  // ========================================

  /// Показывать кнопку действия?
  /// Кнопка скрыта во время игры и при завершении уровня
  bool get shouldShowActionButton =>
      gameState != GameState.playing && gameState != GameState.levelCompleted;

  /// Показывать кнопку паузы?
  bool get shouldShowPauseButton => gameState == GameState.playing;

  /// Показывать счёт?
  bool get shouldShowScore => true;

  /// Показывать жизни?
  bool get shouldShowLives => gameState != GameState.initial;

  /// Показывать оверлей паузы?
  bool get shouldShowPauseOverlay => gameState == GameState.paused;

  /// Показывать оверлей game over?
  bool get shouldShowGameOverOverlay => gameState == GameState.gameOver;

  /// Показывать оверлей завершения уровня?
  bool get shouldShowLevelCompleteOverlay =>
      gameState == GameState.levelCompleted;

  // ========================================
  // КНОПКА ДЕЙСТВИЯ
  // ========================================

  /// Иконка кнопки действия
  IconData get buttonIcon {
    switch (gameState) {
      case GameState.initial:
      case GameState.paused:
      case GameState.levelCompleted:
        return Icons.play_arrow;

      case GameState.gameOver:
        return Icons.refresh;

      case GameState.playing:
        return Icons.play_arrow; // Не используется (кнопка скрыта)
    }
  }

  /// Текст кнопки действия
  String get buttonText {
    switch (gameState) {
      case GameState.initial:
        return 'ИГРАТЬ';

      case GameState.paused:
        return 'ПРОДОЛЖИТЬ';

      case GameState.gameOver:
        return 'ИГРАТЬ СНОВА';

      case GameState.levelCompleted:
        return 'СЛЕДУЮЩИЙ УРОВЕНЬ';

      case GameState.playing:
        return ''; // Не используется (кнопка скрыта)
    }
  }

  /// Цвет кнопки действия
  Color get buttonColor {
    switch (gameState) {
      case GameState.gameOver:
        return Colors.red;

      case GameState.levelCompleted:
        return Colors.amber;

      default:
        return Colors.green;
    }
  }

  // ========================================
  // ОВЕРЛЕИ
  // ========================================

  /// Заголовок оверлея
  String get overlayTitle {
    switch (gameState) {
      case GameState.paused:
        return 'ПАУЗА';

      case GameState.gameOver:
        return 'ИГРА ОКОНЧЕНА';

      case GameState.levelCompleted:
        return 'УРОВЕНЬ ПРОЙДЕН!';

      default:
        return '';
    }
  }

  /// Подзаголовок оверлея
  String get overlaySubtitle {
    switch (gameState) {
      case GameState.paused:
        return 'Нажмите для продолжения';

      case GameState.gameOver:
        return 'Попробуйте ещё раз';

      case GameState.levelCompleted:
        return 'Отличная работа!';

      default:
        return '';
    }
  }

  /// Цвет оверлея
  Color get overlayColor {
    switch (gameState) {
      case GameState.paused:
        return Colors.blue.withOpacity(0.8);

      case GameState.gameOver:
        return Colors.red.withOpacity(0.8);

      case GameState.levelCompleted:
        return Colors.green.withOpacity(0.8);

      default:
        return Colors.black.withOpacity(0.5);
    }
  }

  // ========================================
  // АНИМАЦИИ
  // ========================================

  /// Длительность fade-in анимации для оверлея
  Duration get overlayFadeInDuration {
    switch (gameState) {
      case GameState.levelCompleted:
        return const Duration(milliseconds: 800);

      default:
        return const Duration(milliseconds: 300);
    }
  }

  /// Должна ли быть анимация конфетти?
  bool get shouldShowConfetti => gameState == GameState.levelCompleted;

  // ========================================
  // ДОПОЛНИТЕЛЬНЫЕ СВОЙСТВА
  // ========================================

  /// Игра активна? (идёт геймплей)
  bool get isGameActive => gameState == GameState.playing;

  /// Игра завершена?
  bool get isGameEnded =>
      gameState == GameState.gameOver || gameState == GameState.levelCompleted;

  /// Можно ли взаимодействовать с игровым полем?
  bool get canInteract => gameState == GameState.playing;

  /// Показывать FPS счётчик? (только в debug)
  bool get shouldShowFPS => false; // Можно включить для дебага
}

// ========================================
// EXTENSION ДЛЯ УДОБСТВА
// ========================================

extension GameStateUIExtension on GameState {
  /// Создать UIState из GameState
  GameUIState get toUIState => GameUIState(this);
}
