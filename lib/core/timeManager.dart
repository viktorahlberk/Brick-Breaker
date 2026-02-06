import 'package:bouncer/core/inputController.dart';

class TimeManager {
  final InputController input;
  bool _hitStopActive = false;

  TimeManager(this.input);

  Future<void> hitStop({double duration = 0.06}) async {
    if (_hitStopActive) return;
    _hitStopActive = true;

    final prevScale = input.timeScale;
    input.setSlowMotion(0.0001);

    await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

    input.setSlowMotion(prevScale);
    _hitStopActive = false;
  }

  void slowMotion(double factor, {int milliseconds = 1000}) {
    input.setSlowMotion(factor);
    Future.delayed(
        Duration(milliseconds: milliseconds), () => input.resetTimeScale());
  }
}
