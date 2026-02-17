import 'package:bouncer/features/bosses/architect/domain/architect_boss.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';

class ArchitectViewModel extends ChangeNotifier {
  final ArchitectBoss boss;
  final Size screenSize;
  Offset position;

  ArchitectViewModel({required this.boss, required this.screenSize})
      : position = Offset((screenSize.width / 2) - (boss.size / 2), 90);

  double get hp => boss.hp;
  // double get maxHp => boss.maxHp;
  get phase => boss.state.phase;
  bool get isDead => boss.isDefeated;

  void update(double dt, GameViewModel state) {
    boss.update(dt, state);
    notifyListeners();
  }
}
