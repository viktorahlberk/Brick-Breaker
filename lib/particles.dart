import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  Offset acceleration;
  Color color;
  double size;
  double life;
  double maxLife;
  ParticleShape shape;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.position,
    required this.velocity,
    this.acceleration = const Offset(0, 200), // гравитация
    required this.color,
    this.size = 3.0,
    this.life = 1.0,
    this.shape = ParticleShape.circle,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  }) : maxLife = life;

  void update(double dt) {
    // Физика
    velocity += acceleration * dt;
    position += velocity * dt;

    // Вращение
    rotation += rotationSpeed * dt;

    // Время жизни
    life -= dt;

    // Добавляем сопротивление воздуха
    velocity = Offset(
      velocity.dx * 0.99,
      velocity.dy * 0.99,
    );
  }

  bool get isDead => life <= 0;

  double get opacity => (life / maxLife).clamp(0.0, 1.0);
  double get currentSize => size * (life / maxLife).clamp(0.2, 1.0);
}

enum ParticleShape { circle, square, triangle, line, star }

class ParticleSystem {
  List<Particle> particles = [];
  final Random _random = Random();

  void addBrickExplosion(
    Offset position,
    Color baseColor, {
    int count = 15,
    double intensity = 1.0,
  }) {
    // Основные частицы кирпича
    for (int i = 0; i < count; i++) {
      particles.add(Particle(
        position: position +
            Offset(
              (_random.nextDouble() - 0.5) * 10,
              (_random.nextDouble() - 0.5) * 10,
            ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 400 * intensity,
          (_random.nextDouble() - 0.8) * 300 * intensity,
        ),
        acceleration: Offset(0, 150 + _random.nextDouble() * 100),
        color: _randomizeColor(baseColor),
        size: _random.nextDouble() * 6 + 2,
        life: _random.nextDouble() * 1.5 + 0.5,
        shape: _randomShape(),
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      ));
    }

    // Искры
    _addSparks(position, intensity);

    // Дым (опционально)
    if (intensity > 0.8) {
      _addSmoke(position);
    }
  }

  void _addSparks(Offset position, double intensity) {
    for (int i = 0; i < 8; i++) {
      particles.add(Particle(
        position: position,
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 500 * intensity,
          (_random.nextDouble() - 0.5) * 400 * intensity,
        ),
        acceleration: const Offset(0, 100),
        color: _sparkColor(),
        size: _random.nextDouble() * 2 + 1,
        life: _random.nextDouble() * 0.5 + 0.2,
        shape: ParticleShape.line,
      ));
    }
  }

  void _addSmoke(Offset position) {
    for (int i = 0; i < 3; i++) {
      particles.add(Particle(
        position: position +
            Offset(
              (_random.nextDouble() - 0.5) * 20,
              _random.nextDouble() * 10,
            ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 50,
          -_random.nextDouble() * 30 - 20,
        ),
        acceleration: const Offset(0, -10),
        color: Colors.grey.withValues(alpha: 0.4),
        size: _random.nextDouble() * 8 + 4,
        life: _random.nextDouble() * 2 + 1,
        shape: ParticleShape.circle,
      ));
    }
  }

  Color _randomizeColor(Color baseColor) {
    return Color.fromARGB(
      255,
      (baseColor.red + _random.nextInt(60) - 30).clamp(0, 255),
      (baseColor.green + _random.nextInt(60) - 30).clamp(0, 255),
      (baseColor.blue + _random.nextInt(60) - 30).clamp(0, 255),
    );
  }

  Color _sparkColor() {
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.white,
      const Color(0xFFFFD700),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  ParticleShape _randomShape() {
    final shapes = [
      ParticleShape.circle,
      ParticleShape.square,
      ParticleShape.triangle,
    ];
    return shapes[_random.nextInt(shapes.length)];
  }

  void update(double dt) {
    // Обновляем все частицы
    for (var particle in particles) {
      particle.update(dt);
    }

    // Удаляем мертвые частицы
    particles.removeWhere((particle) => particle.isDead);
  }

  void clear() {
    particles.clear();
  }
}

class ParticlePainter extends CustomPainter {
  final ParticleSystem particleSystem;

  ParticlePainter(this.particleSystem);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particleSystem.particles) {
      if (particle.life > 0) {
        final paint = Paint()
          ..color = particle.color.withValues(alpha: particle.opacity)
          ..style = PaintingStyle.fill;

        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);

        switch (particle.shape) {
          case ParticleShape.circle:
            canvas.drawCircle(Offset.zero, particle.currentSize, paint);
            break;

          case ParticleShape.square:
            final rect = Rect.fromCenter(
              center: Offset.zero,
              width: particle.currentSize * 2,
              height: particle.currentSize * 2,
            );
            canvas.drawRect(rect, paint);
            break;

          case ParticleShape.triangle:
            _drawTriangle(canvas, particle.currentSize, paint);
            break;

          case ParticleShape.line:
            paint.strokeWidth = particle.currentSize;
            paint.style = PaintingStyle.stroke;
            canvas.drawLine(
              Offset(-particle.currentSize, 0),
              Offset(particle.currentSize, 0),
              paint,
            );
            break;

          case ParticleShape.star:
            _drawStar(canvas, particle.currentSize, paint);
            break;
        }

        canvas.restore();
      }
    }
  }

  void _drawTriangle(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, -size);
    path.lineTo(-size, size);
    path.lineTo(size, size);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    const int points = 5;
    const double angle = pi / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? size : size * 0.5;
      final x = radius * cos(i * angle - pi / 2);
      final y = radius * sin(i * angle - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) => false;
}
