import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:bouncer/features/game/views/gunWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlatformViewModel>(
      builder: (__, platform, _) {
        return Stack(children: [
          Positioned(
            left: platform.position.x - (platform.baseWidth / 2),
            top: platform.position.y - (platform.height / 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Container(
                width: platform.baseWidth,
                height: platform.height,
                color: Colors.white,
              ),
            ),
          ),
          if (platform.scaled) BonusWidth()
        ]);
      },
    );
  }
}

class BonusWidth extends StatefulWidget {
  const BonusWidth({super.key});

  @override
  State<BonusWidth> createState() => _BonusWidthState();
}

class _BonusWidthState extends State<BonusWidth>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _opacity = Tween(
      begin: 1.0,
      end: 0.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  start() {
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlatformViewModel>(
      builder: (context, platform, child) {
        if (platform.isBlinking && !_controller.isAnimating) {
          _controller.repeat(reverse: true);
        }
        if (!platform.isBlinking && _controller.isAnimating) {
          _controller.stop();
        }
        final extra = platform.width - platform.baseWidth;
        if (extra <= 0) {
          return const SizedBox.shrink();
        }
        final wingWidth = extra / 2;
        final left = platform.position.x - (platform.width / 2);
        final right = platform.position.x + platform.baseWidth / 2;
        return Stack(children: [
          Positioned(
              left: left,
              top: (platform.position.y - (platform.height / 2)),
              child: FadeTransition(
                opacity: _opacity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(125),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    width: wingWidth,
                    height: platform.height,
                  ),
                ),
              )),
          Positioned(
              left: right,
              top: (platform.position.y - (platform.height / 2)),
              child: FadeTransition(
                opacity: _opacity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.25),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    width: wingWidth,
                    height: platform.height,
                  ),
                ),
              )),
        ]);
      },
    );
  }
}

