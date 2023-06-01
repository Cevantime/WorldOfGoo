shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);
uniform vec4 signal_color: source_color = vec4(1.0);
uniform float signal_ratio = -1.3;
uniform bool backwards = false;
uniform bool display_tex = false;

void fragment()
{
	vec2 uv = vec2(UV.x - 0.5, UV.y - 0.5) * 2.;
	float limit = pow(uv.x * 0.8, 2) + 0.5;
	float alpha = 1.;
	vec4 connection_color = vec4(1.0);
	vec4 c = color;
	if(display_tex) {
		vec2 uv_tex = UV;
		uv_tex.x *= 4.;
		c = texture(TEXTURE, uv_tex);
	}
	connection_color.xyz = c.xyz;
	COLOR = mix(connection_color, signal_color, smoothstep(0.3, 0.1, abs(uv.x - signal_ratio)));
	if((uv.x < signal_ratio && !backwards) || uv.x > signal_ratio && backwards) {
		alpha = smoothstep(limit + 0.2, limit, abs(uv.y));
		COLOR = mix(vec4(1.0), COLOR, smoothstep(limit, limit - 0.2, abs(uv.y)));
	} else {
		alpha = smoothstep(limit, limit - 0.2, abs(uv.y));
	}
	COLOR.a = mix(0, c.a, alpha);
	
}