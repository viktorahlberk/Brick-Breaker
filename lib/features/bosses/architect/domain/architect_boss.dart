// // import 'package:bouncer/core/enums/game_state.dart';
// import 'package:bouncer/features/bosses/architect/domain/architect_ai.dart';
// // import 'package:bouncer/features/bosses/architect/domain/architect_config.dart';
// import 'package:bouncer/features/bosses/architect/domain/architect_phase.dart';
// import 'package:bouncer/features/bosses/architect/domain/architect_state.dart';
// import 'package:bouncer/features/bosses/boss.dart';
// import 'package:bouncer/features/game/viewModels/gameScreenViewModel.dart';

// class ArchitectBoss implements Boss {
//   final ArchitectState _state;
//   final ArchitectAI _ai;
//   final double size = 150;
//   // final ArchitectConfig _config;

//   double get hp => _state.hp / 100;
//   // double get maxHp => _state.maxHp;
//   ArchitectState get state => _state;
//   // bool get isDefeated => _state.hp <= 0;

//   ArchitectBoss(this._state, this._ai);

//   @override
//   void update(double dt, GameViewModel state) {
//     _ai.update(_state, dt, state);
//   }

//   @override
//   void onBallHit(double damage, GameViewModel state) {
//     if (_state.phase == ArchitectPhase.adaptiveShield) {
//       damage *= 0.6; // damage cap
//     }

//     _state.hp -= damage;
//   }

//   @override
//   bool get isDefeated => _state.hp <= 0;
// }
