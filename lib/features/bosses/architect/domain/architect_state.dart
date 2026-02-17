import 'package:bouncer/features/bosses/architect/domain/architect_phase.dart';

class ArchitectState {
  double hp;
  ArchitectPhase phase;
  double timeSinceLastGrid;

  ArchitectState({
    required this.hp,
    required this.phase,
    required this.timeSinceLastGrid,
  });
}
