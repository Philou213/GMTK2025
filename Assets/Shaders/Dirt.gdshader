shader_type canvas_item;

uniform sampler2D emissive_texture : filter_nearest;
uniform float highlight_strength : hint_range(1.0, 3.0, 0.1);

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 albedo = texture(TEXTURE, UV);
	vec4 emissive = texture(emissive_texture, UV);

	if (emissive.a != 0.0){
		albedo *= highlight_strength;
	}

	COLOR = albedo * modulate;
}
