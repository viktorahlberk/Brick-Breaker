import 'package:bouncer/core/effects/flashController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenFlashOverlay extends StatelessWidget {
  const ScreenFlashOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashController>(
      builder: (context, flash, _) {
        debugPrint(flash.intensity.toString());
        if (flash.intensity == 0) {
          return const SizedBox();
        }

        return IgnorePointer(
          child: Container(
            color: Colors.white.withOpacity(flash.intensity),
          ),
        );
      },
    );
  }
}
