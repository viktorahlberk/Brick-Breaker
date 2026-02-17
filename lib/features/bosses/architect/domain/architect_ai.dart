import 'package:bouncer/core/enums/game_state.dart';
import 'package:bouncer/features/bosses/architect/domain/architect_config.dart';
import 'package:bouncer/features/bosses/architect/domain/architect_phase.dart';
import 'package:bouncer/features/bosses/architect/domain/architect_state.dart';
import 'package:bouncer/features/game/viewModels/gameViewModel.dart';
import 'package:flutter/material.dart';

class ArchitectAI {
  final ArchitectConfig config;

  ArchitectAI(this.config);

  void update(
    ArchitectState boss,
    double dt,
    GameViewModel state,
  ) {
    boss.timeSinceLastGrid += dt;

    _handlePhaseTransition(boss);
    _handlePhaseLogic(boss, state, dt);
  }

  void _handlePhaseTransition(ArchitectState boss) {
    final hpRatio = boss.hp / config.maxHp;

    if (hpRatio <= config.phase3Threshold) {
      boss.phase = ArchitectPhase.collapse;
    } else if (hpRatio <= config.phase2Threshold) {
      boss.phase = ArchitectPhase.adaptiveShield;
    }
  }

  void _handlePhaseLogic(
    ArchitectState boss,
    GameViewModel state,
    double dt,
  ) {
    switch (boss.phase) {
      case ArchitectPhase.gridLock:
        _gridLock(boss, state);
        break;

      // case ArchitectPhase.adaptiveShield:
      //   _adaptiveShield(state);
      //   break;

      // case ArchitectPhase.collapse:
      //   _collapse(state, dt);
      //   break;
    }
  }

  void _gridLock(ArchitectState boss, GameViewModel state) {
    if (boss.timeSinceLastGrid >= config.gridSpawnInterval) {
      // state.spawnStructuralBarrier();
      debugPrint('spawnStructuralBarrier');
      boss.timeSinceLastGrid = 0;
    }
  }

  // void _adaptiveShield(GameState state) {
  //   if (state.ball.activeBalls > config.antiMultiballThreshold) {
  //     state.ball.removeExtraBalls();
  //   }

  //   if (state.ball.hasPierce) {
  //     state.ball.disablePierceTemporarily();
  //   }
  // }

  // void _collapse(GameState state, double dt) {
  //   state.shrinkPlayfield(dt);
  // }
}
