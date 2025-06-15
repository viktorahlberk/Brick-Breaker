import 'package:bouncer/models/brickModel.dart';
import 'package:flutter/material.dart';

class BrickWidget extends StatelessWidget {
  final BrickModel model;

  const BrickWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Высота и ширина в пикселях
    final pixelHeight = screenSize.height * model.height / 2;
    final pixelWidth = screenSize.width * model.width / 2;

    // Преобразуем нормализованные координаты в alignment
    final alignmentX = (2 * model.x + model.width) / (2 - model.width);
    final alignmentY = model.y;

    return Container(
      alignment: Alignment(alignmentX, alignmentY),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: pixelHeight,
          width: pixelWidth,
          color: model.color,
        ),
      ),
    );
  }
}
