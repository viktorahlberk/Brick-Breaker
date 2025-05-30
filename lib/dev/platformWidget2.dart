import 'dart:ui';

import 'package:bouncer/controllers/platformWidgetController.dart';
import 'package:bouncer/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlatformWidget2 extends StatefulWidget {
  const PlatformWidget2({
    super.key,
  });

  @override
  _PlatformWidget2State createState() => _PlatformWidget2State();
}

class _PlatformWidget2State extends State<PlatformWidget2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Создаем контроллер анимации для обновления времени шейдера
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Зацикливаем анимацию
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Building PlatformWidget2, animation value: ${_controller.value}");
    return Consumer<PlatformWidgetController>(
        builder: (BuildContext context, PlatformWidgetController platform, _) =>
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // print(
                //     "Building PlatformWidget2, animation value: ${_controller.value}");
                return CustomPaint(
                  painter: ShaderPainter(
                      platform.x - platform.width / 2,
                      platform.y,
                      fragmentProgram.fragmentShader(),
                      platform.color,
                      _controller,
                      MediaQuery.sizeOf(context).width,
                      MediaQuery.sizeOf(context).height),
                  size: Size(platform.width, platform.height),
                );
              },
            ));
  }
}

// Специальный класс для рисования с использованием шейдера
class ShaderPainter extends CustomPainter {
  double x;
  double y;
  FragmentShader shader;
  Color color;
  AnimationController controller;
  double w;
  double h;

  ShaderPainter(
      this.x, this.y, this.shader, this.color, this.controller, this.w, this.h);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    ///insert uColor to shader
    shader.setFloat(0, color.r);
    shader.setFloat(1, color.g);
    shader.setFloat(2, color.b);
    shader.setFloat(3, color.a);

    ///insert uTime into shader
    shader.setFloat(4, controller.value);

    ///insert uSize into the shader
    shader.setFloat(5, size.width);
    shader.setFloat(6, size.height);

    final rect = Rect.fromLTWH(x, y, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(8.0),
    );

    // Создаем Paint с нашим шейдером
    final shaderPaint = Paint()..shader = shader;

    // Рисуем платформу с закругленными углами
    canvas.drawRRect(rrect, shaderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
