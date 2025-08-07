shader_type canvas_item;

uniform int steps : hint_range(1, 256) = 8;
uniform float size : hint_range(0.0, 1.0) = 0.5;
uniform float center_size : hint_range(0.0, 1.0) = 0.0;

uniform vec4 start_color : source_color;
uniform vec4 end_color : source_color;

uniform float wave_strength : hint_range(0.0, 0.2) = 0.05;
uniform int wave_freq1 : hint_range(1, 20) = 6;
uniform int wave_freq2 : hint_range(1, 40) = 14;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = UV - center;
    float dist = length(dir);

    // Get angle in range [0, 1] instead of [-π, π]
    float angle = atan(dir.y, dir.x);
    float normalized_angle = (angle + PI) / (2.0 * PI);

    // Seamless ripple using angle in [0,1]
    float ripple =
        sin(normalized_angle * float(wave_freq1) * 2.0 * PI) +
        sin(normalized_angle * float(wave_freq2) * 2.0 * PI);

    dist += ripple * wave_strength;

    if (dist > size) {
        COLOR = end_color;
    } else if (dist < center_size) {
        COLOR = start_color;
    } else {
        float norm_dist = (dist - center_size) / (size - center_size);
        float stepped = floor(norm_dist * float(steps)) / float(steps);
        COLOR = mix(start_color, end_color, stepped);
    }
}
