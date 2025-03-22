import 'package:bouncer/controllers/ballWidgetController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BallWidget extends StatelessWidget {
  const BallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BallWidgetController>(
      builder: (context, ball, _) {
        return SizedBox.expand(
          child: CustomPaint(
            painter: BallPainter(
              x: ball.x,
              y: ball.y,
              radius: ball.radius,
              positions: ball.lastBallPositions,
            ),
          ),
        );
      },
    );
  }
}

class BallPainter extends CustomPainter {
  final double x;
  final double y;
  final double radius;
  final List<Offset> positions;

  BallPainter({
    required this.x,
    required this.y,
    required this.radius,
    required this.positions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем хвост мяча
    for (int i = 0; i < positions.length - 1; i++) {
      final pos = positions[i];

      final alpha = 0.2 * (i + 1) / positions.length;
      final trailPaint = Paint()
        ..color = Colors.white.withAlpha((255 * alpha).toInt())
        ..style = PaintingStyle.fill;

      final trailSize = radius * (0.5 + 0.5 * i / positions.length);
      canvas.drawCircle(pos, trailSize, trailPaint);
    }

    // Рисуем сам мяч
    final ballPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), radius, ballPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
