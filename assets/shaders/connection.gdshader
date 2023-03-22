shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);

void fragment()
{
	vec2 uv = vec2(UV.x - 0.5, UV.y - 0.5) * 2.;
	float limit = pow(uv.x * 0.8, 2) + 0.5;
	float alpha = smoothstep(limit, limit - 0.2, abs(uv.y));
	COLOR.xyz = color.xyz;
	COLOR.a = mix(0, color.a, alpha);
}