shader_type canvas_item;

// Stretch parameter (X = horizontal stretch, Y = vertical stretch)
uniform vec2 stretch = vec2(1.0, 1.0);

void vertex() {
    // Scale the vertex position by the stretch factor
    // vec2(VERTEX) is the original vertex position
    VERTEX.xy *= stretch;
}

void fragment() {
    // Fragment remains unchanged for now
}
