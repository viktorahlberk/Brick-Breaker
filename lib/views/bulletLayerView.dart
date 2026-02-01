import 'dart:developer';

import 'package:bouncer/models/bulletModel.dart';
import 'package:bouncer/viewModels/gunViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BulletLayerView extends StatelessWidget {
  const BulletLayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GunViewModel>(
      builder: (context, gvmodel, child) {
        return CustomPaint(
          painter: BulletPainter(gvmodel.bulletsList),
        );
      },
    );
  }
}

class BulletPainter extends CustomPainter {
  final List<BulletModel> bullets;

  BulletPainter(this.bullets);

  @override
  void paint(Canvas canvas, Size size) {
    for (final bullet in bullets) {
      canvas.drawCircle(
        bullet.position,
        bullet.radius,
        Paint()..color = bullet.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BulletPainter oldDelegate) {
    return true;
    // return oldDelegate.bullets != bullets;
  }
}
