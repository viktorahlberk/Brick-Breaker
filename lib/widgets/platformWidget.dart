import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<PlatformWidgetController>(
      builder: (context, platform, _) {
        // Convert platform's Cartesian coordinates to a position in the Stack
        return Positioned(
          left: platform.x - (platform.width / 2),
          top: platform.y - (platform.height / 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              width: platform.width,
              height: platform.height,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
