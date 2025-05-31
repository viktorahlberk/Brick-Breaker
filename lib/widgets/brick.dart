import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class Brick extends StatelessWidget {
  final double brickX;
  final double brickY;
  final double brickHeight;
  final double brickWidth;
  final Color color;

  const Brick(
      this.brickHeight, this.brickWidth, this.brickX, this.brickY, this.color,
      {super.key});

  // Rect get brickRect => Rect.fromLTWH(brickX, brickY, brickWidth, brickHeight);
  Rect getBrickPixelRect(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double pixelX = (brickX + 1) * 0.5 * screenSize.width;
    double pixelY = (brickY + 1) * 0.5 * screenSize.height;
    double pixelWidth = brickWidth * screenSize.width * 0.5;
    double pixelHeight = brickHeight * screenSize.height * 0.5;
    return Rect.fromLTWH(pixelX, pixelY, pixelWidth, pixelHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: MediaQuery.of(context).size.height * brickHeight / 2,
          width: MediaQuery.of(context).size.width * brickWidth / 2,
          color: color,
        ),
      ),
    );
  }
}
