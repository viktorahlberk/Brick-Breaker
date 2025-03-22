#version 460 core

precision mediump float;

// Uniforms
uniform float centerX;   // X-координата мяча (в пикселях)
uniform float centerY;   // Y-координата мяча (в пикселях)
uniform float radius;    // Радиус мяча (в пикселях)
uniform float width;     // Ширина канвы (в пикселях)
uniform float height;    // Высота канвы (в пикселях)
uniform int positionCount;  // Количество позиций в следе

// След (макс. 10 позиций), координаты уже в пикселях
uniform vec2 positions[10];

// Выходной цвет
out vec4 fragColor;

void main() {
    // Координаты текущего пикселя (в пикселях)
    vec2 fragCoord = vec2(gl_FragCoord.x, gl_FragCoord.y);

    // Изначально прозрачный цвет
    fragColor = vec4(0.0, 0.0, 0.0, 0.0);

    // Отрисовка следа
    for (int i = 0; i < min(positionCount, 10); i++) {
        vec2 pos = positions[i]; // Позиция следа уже в пикселях
        float dist = distance(fragCoord, pos);
        float trailRadius = radius * (0.8 - 0.4 * float(i) / float(positionCount));

        if (dist < trailRadius) {
            float alpha = (1.0 - dist / trailRadius) * (0.7 - 0.6 * float(i) / float(positionCount));
            vec3 color = vec3(0.9, 0.9, 1.0); // Голубовато-белый

            fragColor.rgb = fragColor.rgb * (1.0 - alpha) + color * alpha;
            fragColor.a = fragColor.a + alpha * (1.0 - fragColor.a);
        }
    }
}
