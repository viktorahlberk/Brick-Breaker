import 'dart:ui';

import 'package:flutter/material.dart';

enum BrickType {
  normal,
  special,
  hard,
}

class BrickModel {
  final double x;
  final double y;
  final double width;
  final double height;
  BrickType type;
  Color color;

  BrickModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.type,
  }) : color = type == BrickType.normal
            ? Colors.white
            : type == BrickType.special
                ? const Color(0xFFFF0000) // Red for special bricks
                : Colors.grey; // Blue for hard bricks

  Rect toPixelRect(Size screenSize) {
    final pixelX = (x + 1) * 0.5 * screenSize.width;
    final pixelY = (y + 1) * 0.5 * screenSize.height;
    final pixelWidth = width * screenSize.width * 0.5;
    final pixelHeight = height * screenSize.height * 0.5;
    return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
  }

  getBrickColor(BrickType t) {
    switch (t) {
      case BrickType.normal:
        return Colors.white;
      case BrickType.special:
        return const Color(0xFFFF0000);
      case BrickType.hard:
        return Colors.grey;
    }
  }
}
