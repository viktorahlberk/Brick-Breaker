import 'package:flutter/material.dart';

class FlashController extends ChangeNotifier {
  double _intensity = 0.0;
  double get intensity => _intensity;

  bool _isActive = false;

  Future<void> trigger({
    Duration duration = const Duration(milliseconds: 350),
    double peak = 0.8,
  }) async {
    if (_isActive) return;
    _isActive = true;

    const int steps = 12;
    final stepDuration = duration ~/ steps;

    for (int i = 0; i < steps; i++) {
      final progress = i / steps;

      // ease out
      _intensity = peak * (1 - progress);
      notifyListeners();

      await Future.delayed(stepDuration);
    }

    _intensity = 0;
    notifyListeners();
    _isActive = false;
  }
}
