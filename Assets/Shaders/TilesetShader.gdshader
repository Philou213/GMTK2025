shader_type canvas_item;

uniform sampler2D override_texture : filter_nearest;
uniform vec4 modulate : source_color = vec4(1,1,1,1);

void fragment() {
    COLOR = texture(override_texture, UV) * modulate;
}
