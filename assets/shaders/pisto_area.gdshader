shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float l = length(UV - vec2(0.5));
	color.a = l * (1.-step(0.5, l)) * 0.6;
	COLOR = color;
}

