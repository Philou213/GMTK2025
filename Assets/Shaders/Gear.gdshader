shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_thickness = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a > 0.1) {
		COLOR = tex;
	} else {
		float alpha_sum = 0.0;
		for (int x = -1; x <= 1; x++) {
			for (int y = -1; y <= 1; y++) {
				if (x == 0 && y == 0) continue;
				vec2 offset = vec2(float(x), float(y)) * outline_thickness * TEXTURE_PIXEL_SIZE;
				alpha_sum += texture(TEXTURE, UV + offset).a;
			}
		}
		if (alpha_sum > 0.0) {
			COLOR = outline_color;
		} else {
			discard;
		}
	}
}
