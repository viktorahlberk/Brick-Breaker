// views/ball_widget.dart
import 'dart:collection';

import 'package:bouncer/viewModels/ballViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BallWidget extends StatelessWidget {
  const BallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BallViewModel>(
      builder: (context, viewModel, _) {
        final model = viewModel.model;
        return SizedBox.expand(
          child: CustomPaint(
            painter: BallPainter(
              position: model.position,
              radius: model.radius,
              trail: model.trail,
            ),
          ),
        );
      },
    );
  }
}

class BallPainter extends CustomPainter {
  final Offset position;
  final double radius;
  final Queue<Offset> trail;

  BallPainter({
    required this.position,
    required this.radius,
    required this.trail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < trail.length - 1; i++) {
      final pos = trail.elementAt(i);
      final alpha = 0.2 * (i + 1) / trail.length;
      final paint = Paint()
        ..color = Colors.white.withAlpha((255 * alpha).toInt())
        ..style = PaintingStyle.fill;

      final trailSize = radius * (0.5 + 0.5 * i / trail.length);
      canvas.drawCircle(pos, trailSize, paint);
    }

    final ballPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, radius, ballPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
