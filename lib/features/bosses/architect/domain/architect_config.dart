import 'package:provider/provider.dart';

class ArchitectConfig {
  final double maxHp;
  final double phase2Threshold;
  final double phase3Threshold;

  final double gridSpawnInterval;
  final int antiMultiballThreshold;

  const ArchitectConfig({
    required this.maxHp,
    required this.phase2Threshold,
    required this.phase3Threshold,
    required this.gridSpawnInterval,
    required this.antiMultiballThreshold,
  });
  static create() => ArchitectConfig(
      maxHp: 1000,
      phase2Threshold: 600,
      phase3Threshold: 300,
      gridSpawnInterval: 10,
      antiMultiballThreshold: 10);
}
