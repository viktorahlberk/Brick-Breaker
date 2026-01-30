import 'package:bouncer/viewModels/gunViewModel.dart';
import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Gunwidget extends StatelessWidget {
  const Gunwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GunViewModel, PlatformViewModel>(
        builder: (__, gvmodel, pvmodel, _) {
      // gvmodel.startShooting(pvmodel.x - gvmodel.width);
      return Positioned(
        left: pvmodel.x - gvmodel.width,
        top: pvmodel.y - gvmodel.height,
        child: Container(
          width: gvmodel.width,
          height: gvmodel.height,
          color: gvmodel.color,
        ),
      );
    });
  }
}
