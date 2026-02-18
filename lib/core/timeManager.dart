// import 'package:bouncer/core/inputController.dart';w

class TimeManager {
  // final InputController input;
  bool _hitStopActive = false;

  TimeManager();

  // time
  double _timeScale = 1;
  double get timeScale => _timeScale;

  Future<void> hitStop({double duration = 0.06}) async {
    if (_hitStopActive) return;
    _hitStopActive = true;

    final prevScale = timeScale;
    _setSlowMotion(0.0001);

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

    _setSlowMotion(prevScale);
    _hitStopActive = false;
  }

  void slowMotion(double factor, {int milliseconds = 1000}) {
    _setSlowMotion(factor);
    Future.delayed(
        Duration(milliseconds: milliseconds), () => _resetTimeScale());
  }

  void _setSlowMotion(double scale) {
    _timeScale = scale.clamp(0.05, 1.0);
  }

  void _resetTimeScale() {
    _timeScale = 1.0;
    // notifyListeners();
  }
}
