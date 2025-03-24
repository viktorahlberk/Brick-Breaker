#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec4 uColor;  
uniform float uTime;  
uniform vec2 uSize;

out vec4 fragColor;

void main() {
// Эмулируем текстурные координаты (0.0 - 1.0)
    vec2 texCoord = FlutterFragCoord()/uSize;

    // Центр платформы
    vec2 center = vec2(0.5, 0.5);

    // Расстояние от текущей точки до центра
    float dist = distance(texCoord, center);

    // Glow-эффект по краям
    float glow = smoothstep(0.4, 0.6, dist);

    // Анимация свечения (пульсация)
    float animatedGlow = glow * (0.8 + 0.2 * sin(uTime*3 * 6.28318));

    // Итоговый цвет
    fragColor = uColor + vec4(1.0, 0.8, 0.2, 1.0) * animatedGlow;


    // vec2 uv = FlutterFragCoord()/uSize;
    // // vec4 white = vec4(1.0);
    // fragColor = vec4(pixel.x * uColor,alpha);
    // fragColor = vec4(sin(pixel).x,pixel.y,0.0,1.0);
}