// import 'dart:async';

import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final x;
  final y;

  const Ball({super.key, this.x, this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: Container(
          alignment: Alignment(x, y),
          height: 15,
          width: 15,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
    );
  }
}
