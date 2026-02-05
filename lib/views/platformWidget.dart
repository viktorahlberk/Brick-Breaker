import 'package:bouncer/viewModels/platformViewModel.dart';
import 'package:bouncer/views/gunWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlatformViewModel>(
      builder: (__, platform, _) {
        return Positioned(
          left: platform.position.x - (platform.width / 2),
          top: platform.position.y - (platform.height / 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              width: platform.width,
              height: platform.height,
              color: Colors.white,
              // child: platform.isGunActive ? GunWidget() : Container(),
            ),
          ),
        );
      },
    );
  }
}
