import 'package:bouncer/features/game/viewModels/platformViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlatformViewModel screen boundaries', () {
    test('keyboard movement keeps the platform inside the screen', () {
      final platform = PlatformViewModel(const Size(200, 400));

      platform.setInput(1);
      platform.update(1);

      expect(platform.position.x + platform.width / 2, 200);
    });

    test('touch movement keeps the platform inside the screen', () {
      final platform = PlatformViewModel(const Size(200, 400));

      platform.moveCenterTo(-100, 1);

      expect(platform.position.x - platform.width / 2, 0);
    });

    test('increasing platform width keeps it inside the screen', () {
      final platform = PlatformViewModel(const Size(200, 400));

      platform.moveCenterTo(200, 1);
      platform.increaseWidth(platform.baseWidth);

      expect(platform.position.x + platform.width / 2, 200);
    });
  });
}
