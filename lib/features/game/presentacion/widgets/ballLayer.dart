import 'package:bouncer/features/game/managers/ballManager.dart';
import 'package:bouncer/features/game/viewModels/ballViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BallLayer extends StatelessWidget {
  const BallLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BallManager>(
      builder: (_, ballManager, __) {
        return SizedBox.expand(
          child: CustomPaint(
            painter: BallPainter(balls: ballManager.ballPool),
          ),
        );
      },
    );
  }
}

class BallPainter extends CustomPainter {
  final List<BallViewModel> balls;

  BallPainter({required this.balls});

  void _drawBall(Canvas canvas, BallViewModel ball) {
    final paint = Paint()..color = Colors.white;

    canvas.drawCircle(ball.position, ball.model.radius, paint);
  }

  void _drawTrail(Canvas canvas, BallViewModel ball) {
    final trail = ball.model.trail;

    for (int i = 0; i < trail.length; i++) {
      final pos = trail.elementAt(i);

      final alpha = 0.2 * (i + 1) / trail.length;

      final paint = Paint()
        ..color = Colors.white.withAlpha((255 * alpha).toInt());

      final trailSize = ball.model.radius * (0.5 + 0.5 * i / trail.length);

      canvas.drawCircle(pos, trailSize, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final ball in balls) {
      _drawTrail(canvas, ball);
      _drawBall(canvas, ball);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
