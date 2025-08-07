shader_type canvas_item;

uniform float noise_scale = 200.0; // Controls size of noise grains
uniform float speed = 10.0;        // Controls animation speed/intensity

void fragment() {
    // Compute UV scaled by noise_scale to adjust grain size
    vec2 scaled_uv = UV * noise_scale;

    // Add time component to animate noise
    float t = TIME * speed;

    // Simple pseudo-random function
    float noise = fract(sin(dot(scaled_uv + t, vec2(12.9898, 78.233))) * 43758.5453);

    COLOR = vec4(vec3(noise), 1.0);
}
