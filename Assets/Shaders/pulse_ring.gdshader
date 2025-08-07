shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float intensity = 25.0;      // Vertical displacement strength
uniform float ring_radius = 0.5;     // Radius of the shockwave ring (0 to 0.5)
uniform float ring_thickness = 0.2;  // Thickness of the shockwave ring (0 to 0.5)

void fragment() {
    vec2 screen_uv = SCREEN_UV;

    // Distance from the center of sprite (0.5, 0.5)
    float dist_to_center = distance(UV, vec2(0.5));

    // Define inner and outer radius of shockwave ring based on ring_radius
    float outer_radius = ring_radius;
    float inner_radius = max(0.0, ring_radius - ring_thickness);

    // Calculate distortion strength based on pixel position within ring
    float distortion = 0.0;
    if (dist_to_center >= inner_radius && dist_to_center <= outer_radius) {
        float ring_pos = (dist_to_center - inner_radius) / (outer_radius - inner_radius);
        distortion = sin(ring_pos * PI) * -intensity;
    }

    // Apply vertical distortion
    screen_uv.y -= distortion * SCREEN_PIXEL_SIZE.y;

    COLOR = texture(SCREEN_TEXTURE, screen_uv);
}
