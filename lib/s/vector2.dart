import 'dart:math';

class Vector2 {
  final double x;
  final double y;

  const Vector2(this.x, this.y);

  double get length => sqrt(x * x + y * y);

  Vector2 normalized(double targetLength) {
    final len = length;
    if (len == 0) return const Vector2(0, 0);
    return Vector2(
      x / len * targetLength,
      y / len * targetLength,
    );
  }

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);

  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);
}

