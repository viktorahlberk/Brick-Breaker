import 'package:bouncer/features/game/viewModels/gunViewModel.dart';
import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GunWidget extends StatelessWidget {
  const GunWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GunViewModel, PlatformViewModel>(
        builder: (__, gvmodel, pvmodel, _) {
      // gvmodel.startShooting(pvmodel.x - gvmodel.width);
      return pvmodel.isGunActive
          ? Positioned(
              left: pvmodel.position.x - gvmodel.width / 2,
              top: pvmodel.position.y - gvmodel.height,
              child: Container(
                width: gvmodel.width,
                height: gvmodel.height,
                color: Colors.blueGrey,
              ),
            )
          : Container();
    });
  }
}

