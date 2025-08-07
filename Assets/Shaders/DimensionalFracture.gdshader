shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float split_amount     : hint_range(0.0, 0.5) = 0.1;
uniform float edge_thickness   : hint_range(0.0, 0.1) = 0.03;
uniform float crack_progress   : hint_range(0.0, 2.0) = 1.0;
uniform float crack_x_offset   : hint_range(-0.5, 0.5) = 0.0;

uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // black edge

uniform float jaggedness      : hint_range(1.0, 50.0)  = 25.0;
uniform float fork_jaggedness : hint_range(1.0, 100.0) = 80.0;
uniform float fork_amplitude  : hint_range(0.0, 0.2)   = 0.03;

uniform float vortex_strength     : hint_range(0.0, 2.0) = 0.5;
uniform float core_pulse_speed    : hint_range(0.0, 5.0) = 2.0;

float triangle_wave(float x) {
    return abs(fract(x) - 0.5) * 2.0 - 1.0;
}

vec3 space_vortex(vec2 uv, float time) {
    vec2 p = uv - vec2(0.5);
    float angle = atan(p.y, p.x);
    float radius = length(p);

    float swirl = sin(angle * 10.0 + radius * 40.0 - time * 2.0) * 0.2;
    float pulse = sin(time * core_pulse_speed + radius * 10.0) * 0.1;

    vec3 deep = vec3(0.05, 0.0, 0.1);
    vec3 mid  = vec3(0.3, 0.0, 0.4);
    vec3 core = vec3(0.8, 0.4, 1.0);

    float r = radius + swirl + pulse;
    vec3 col = mix(deep, mid, smoothstep(0.4, 0.2, r));
    col = mix(col, core, smoothstep(0.2, 0.05, r));
    return col;
}

void fragment() {
    vec2 uv = UV;
    vec2 screen_uv = SCREEN_UV;
    float time = TIME;

    float jagged_wave = triangle_wave(uv.y * jaggedness) * 0.05;
    float fork_wave   = triangle_wave(uv.y * fork_jaggedness) * fork_amplitude;

    float total_offset   = jagged_wave + fork_wave;
    float noisy_center_x = 0.5 + crack_x_offset + total_offset;

    float openness      = clamp((crack_progress - uv.y) / crack_progress, 0.0, 1.0);
    float dynamic_split = split_amount * openness;
    float dist_to_crack = abs(uv.x - noisy_center_x);
    float gap           = dynamic_split;

    float uv_to_screen = dFdx(SCREEN_UV.x) / dFdx(UV.x);
    vec2 shift = vec2(dynamic_split * uv_to_screen, 0.0);

    vec4 final_color = vec4(0.0);

    if (uv.y > crack_progress) {
        final_color = texture(screen_texture, screen_uv);
    } else if (dist_to_crack < gap && dist_to_crack > gap - edge_thickness) {
        float t = (dist_to_crack - (gap - edge_thickness)) / edge_thickness;
        t = pow(1.0 - t, 2.0);
        vec2 local_uv = (uv - vec2(noisy_center_x, 0.5)) * 3.0 + vec2(0.5);
        vec3 vortex_color = space_vortex(local_uv, time);
        vec3 edge_darkened = vortex_color * mix(edge_color.rgb, vec3(1.0), t);
        final_color = vec4(edge_darkened, 1.0);
    } else if (dist_to_crack < gap) {
        vec2 local_uv = (uv - vec2(noisy_center_x, 0.5)) * 3.0 + vec2(0.5);
        vec3 vortex_color = space_vortex(local_uv, time);
        final_color = vec4(vortex_color, 1.0);
    } else if (uv.x < noisy_center_x) {
        final_color = texture(screen_texture, screen_uv + shift);
    } else {
        final_color = texture(screen_texture, screen_uv - shift);
    }

    COLOR = final_color;
}