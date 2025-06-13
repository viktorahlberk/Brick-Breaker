import 'dart:ui';

class BrickModel {
  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;

  BrickModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });

  Rect toPixelRect(Size screenSize) {
    final pixelX = (x + 1) * 0.5 * screenSize.width;
    final pixelY = (y + 1) * 0.5 * screenSize.height;
    final pixelWidth = width * screenSize.width * 0.5;
    final pixelHeight = height * screenSize.height * 0.5;
    return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
  }
}
