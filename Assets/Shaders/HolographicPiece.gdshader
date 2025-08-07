shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D override_texture : filter_nearest;
uniform vec4 modulate : source_color = vec4(1.0);

// Hologram settings
uniform vec4 hologram_color : source_color = vec4(0.0, 0.211, 0.403, 0.622);
uniform float hologram_intensity : hint_range(0.0,1.0)=1.0;
uniform float hologram_brightness : hint_range(0.0,15.0)=4.76;

// Scanlines & distortion
uniform float scanline_frequency : hint_range(50.0,500.0)=89.423;
uniform float scanline_intensity : hint_range(0.0,1.0)=0.351;
uniform float distortion_strength : hint_range(0.0,50.0)=8.0;
uniform float glitch_frequency = 4.0;   
uniform float glitch_speed = 1.0;        

uniform float flicker_speed : hint_range(0.0,10.0)=1.397;
uniform float flicker_intensity : hint_range(0.0,1.0)=0.174;

uniform float grid_local_size = 32.0;
uniform float flicker_offset_strength = 6.715;

varying vec2 local_pos;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void vertex() {
    // ✅ No velocity deformation, just pass through the original vertex
    local_pos = VERTEX;
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    float time = TIME * 2.0;
    vec2 local_effect_uv = local_pos * 0.01;

    // ✅ GLITCHY BREAKLINES DISTORTION
    float band = floor(local_effect_uv.y * glitch_frequency + time * glitch_speed);
    float band_random = hash(vec2(band, 0.0));
    float glitch_active = step(0.7, band_random); 
    vec2 distortion_offset = vec2(0.0);
    distortion_offset.x = glitch_active * (band_random - 0.5) * (distortion_strength * 0.002 * hologram_intensity);

    vec4 texColor = texture(override_texture, UV + distortion_offset) * modulate;
    vec4 normalColor = texture(override_texture, UV) * modulate;

    float gray = dot(texColor.rgb, vec3(0.299,0.587,0.114));
    vec4 holo = vec4(hologram_color.rgb * gray, 1.0);

    float scan_val = sin(local_effect_uv.y * scanline_frequency) * 0.5 + 0.5;
    float scanline_effect = mix(1.0 - scanline_intensity, 1.0, scan_val);
    holo.rgb *= scanline_effect;

    vec2 shifted_local = local_pos + vec2(grid_local_size * 0.5);
    vec2 cell = floor(shifted_local / grid_local_size);
    float flicker_offset = hash(cell) * flicker_offset_strength;
    float flicker = 1.0 + sin((time + flicker_offset) * flicker_speed + local_effect_uv.y * 10.0) * flicker_intensity;
    holo.rgb *= flicker;

    holo.rgb *= hologram_brightness;

    vec3 finalColor = mix(normalColor.rgb, holo.rgb, hologram_intensity);
    COLOR = vec4(finalColor, mix(1.0, hologram_color.a, hologram_intensity));
}
