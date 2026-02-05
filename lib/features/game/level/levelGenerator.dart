// data/level/procedural_level_generator.dart
import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:bouncer/models/brickModel.dart';
import 'package:flutter/material.dart';

// import '../../domain/entities/brick.dart';
// import '../../domain/level/level_difficulty.dart';

class ProceduralLevelGenerator {
  final Random _rng;

  ProceduralLevelGenerator({int? seed}) : _rng = Random(seed);

  List<BrickModel> generate({
    required LevelDifficulty difficulty,
    required Size screenSize,
    double topOffset = 80,
    double padding = 6,
  }) {
    final bricks = <BrickModel>[];

    final cols = difficulty.cols;
    final rows = difficulty.rows;
    // final cols = 7;
    // final rows = 3;

    final brickWidthPx = (screenSize.width - padding * (cols + 1)) / cols;
    final brickHeightPx = 22.0;

    double normalizeChance(double value) {
      if (value <= 1) return value;
      return (value / 100).clamp(0.0, 1.0);
    }

    final emptyChance = normalizeChance(difficulty.emptyChance);
    final strongChance = normalizeChance(difficulty.strongBrickChance);

    // int id = 0;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (_rng.nextDouble() < emptyChance) continue;

        final type = _pickType(strongChance);

        final positionPx = Offset(
          padding + col * (brickWidthPx + padding),
          topOffset + row * (brickHeightPx + padding),
        );

        // Convert pixel rect to normalized [-1, 1] space.
        final normalizedX = (positionPx.dx / screenSize.width) * 2 - 1;
        final normalizedY = (positionPx.dy / screenSize.height) * 2 - 1;
        final normalizedWidth = (brickWidthPx / screenSize.width) * 2;
        final normalizedHeight = (brickHeightPx / screenSize.height) * 2;

        bricks.add(
          BrickModel(
            x: normalizedX,
            y: normalizedY,
            width: normalizedWidth,
            height: normalizedHeight,
            type: type,
          ),
        );
        // inspect(BrickModel(
        //   x: position.dx,
        //   y: position.dy,
        //   width: brickWidth,
        //   height: brickHeight,
        //   type: type,
        // ));
      }
    }

    // if (difficulty.mirrorHorizontal) {
    //   return _mirror(bricks, screenSize.width);
    // }

    return bricks;
  }

  BrickType _pickType(double strongChance) {
    final roll = _rng.nextDouble();

    if (roll < strongChance) {
      return BrickType.strong;
    }

    // if (roll < d.strongBrickChance + d.bonusChance) {
    //   return BrickType.bonus;
    // }

    return BrickType.normal;
  }

//   List<BrickModel> _mirror(List<BrickModel> source, double screenWidth) {
//     final mirrored = <BrickModel>[];
//     int id = source.length;

//     for (final brick in source) {
//       final mirroredX = screenWidth - brick.position.dx - brick.size.width;

//       if ((mirroredX - brick.position.dx).abs() < 1) continue;

//       mirrored.add(
//         BrickModel(
//           // id: id++,
//             // position: position,
//             // size: Size(brickWidth, brickHeight),
//             // hitPoints: type.hitPoints,
//             // hasBonus: type.hasBonus,
//             x: position.dx, y: position.dy, width: brickWidth,
//             height: brickHeight, type: BrickType.normal,
//         ),
//       );
//     }

//     return [...source, ...mirrored];
//   }
}

enum _BrickType {
  normal(1, false),
  strong(2, false),
  bonus(1, true);

  final int hitPoints;
  final bool hasBonus;

  const _BrickType(this.hitPoints, this.hasBonus);
}

class LevelDifficulty {
  final int rows;
  final int cols;
  final double emptyChance;
  final double strongBrickChance;
  final double bonusChance;
  // final bool mirrorHorizontal;

  const LevelDifficulty({
    required this.rows,
    required this.cols,
    required this.emptyChance,
    required this.strongBrickChance,
    required this.bonusChance,
    // this.mirrorHorizontal = true,
  });
}

