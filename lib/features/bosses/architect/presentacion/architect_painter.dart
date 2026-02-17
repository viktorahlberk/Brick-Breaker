import 'dart:math';

import 'package:bouncer/features/bosses/architect/domain/architect_phase.dart';
import 'package:flutter/material.dart';

class ArchitectPainter extends CustomPainter {
  final double hpRatio;
  final ArchitectPhase phase;

  ArchitectPainter({
    required this.hpRatio,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final color = _phaseColor();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    _drawHexagon(canvas, center, size.width / 2, paint);
    _drawCore(canvas, center, hpRatio, size);
  }

  Color _phaseColor() {
    switch (phase) {
      case ArchitectPhase.gridLock:
        return Colors.blueAccent;
      case ArchitectPhase.adaptiveShield:
        return Colors.deepPurpleAccent;
      case ArchitectPhase.collapse:
        return Colors.redAccent;
    }
  }

  void _drawHexagon(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * 3.14159 / 180;
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCore(Canvas canvas, Offset center, double hpRatio, Size s) {
    final paint = Paint()..color = Colors.white.withOpacity(hpRatio);

    canvas.drawCircle(center, s.width / 5, paint);
  }

  @override
  bool shouldRepaint(covariant ArchitectPainter oldDelegate) {
    return oldDelegate.hpRatio != hpRatio || oldDelegate.phase != phase;
  }
}
