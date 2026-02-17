import 'package:bouncer/features/bosses/architect/presentacion/architect_painter.dart';
import 'package:bouncer/features/bosses/architect/presentacion/architect_viewmodel.dart';
import 'package:flutter/material.dart';

class ArchitectBossWidget extends StatelessWidget {
  final ArchitectViewModel vm;

  const ArchitectBossWidget({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: vm.position.dx,
      top: vm.position.dy,
      child: AnimatedBuilder(
        animation: vm,
        builder: (_, __) {
          return CustomPaint(
            painter: ArchitectPainter(
              hpRatio: vm.hp,
              phase: vm.phase,
            ),
            // size: Size(150, 150),
            size: Size(vm.boss.size, vm.boss.size),
          );
        },
      ),
    );
  }
}
