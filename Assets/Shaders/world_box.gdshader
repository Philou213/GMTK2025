shader_type canvas_item;

uniform sampler2D alt_texture;
uniform sampler2D noise_texture;
uniform sampler2D edge_gradient;

uniform float threshold : hint_range(0.0, 1.0);
uniform float edge_thickness : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    vec4 base_col = texture(TEXTURE, UV);
    vec4 result_col = base_col;

    if (base_col.a > 0.0) {
        vec4 alt_col = texture(alt_texture, UV);
        float noise_val = texture(noise_texture, UV).r;
        float dist_before = threshold - noise_val;

        if (threshold < 1.0 && dist_before > 0.0 && dist_before < edge_thickness) {
            // Only draw edge if threshold is below max
            float t = dist_before / edge_thickness;
            vec4 edge_col = texture(edge_gradient, vec2(t, 0.5));
            result_col.rgb = mix(result_col.rgb, edge_col.rgb, edge_col.a);
            result_col.a = max(result_col.a, edge_col.a);

        } else if (noise_val < threshold - edge_thickness) {
            // Far below threshold → base texture
            result_col = base_col;

        } else if (noise_val >= threshold) {
            // At or above threshold → alt texture
            result_col = alt_col;
        }
    }

    COLOR = result_col;
}
