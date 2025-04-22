shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float bend_strength : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Keep UV safe before distortion
    float safe_y = clamp(uv.y, 0.0, 1.0);
    float curve = pow(1.0 - safe_y, 2.0) * bend_strength;

    vec2 warped_uv = vec2(uv.x, uv.y - curve);
    warped_uv = clamp(warped_uv, vec2(0.001), vec2(0.999)); // extra margin

    // Optional fade at screen edges to hide artifacts
    float fade = smoothstep(0.0, 0.05, warped_uv.y) * smoothstep(1.0, 0.95, warped_uv.y);
	
    COLOR = texture(SCREEN_TEXTURE, warped_uv) * fade;
}
