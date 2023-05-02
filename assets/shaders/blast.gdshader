shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform vec4 color:source_color = vec4(1.0);
uniform float limit = 1.;

void fragment() {
	vec2 uv = UV;
	uv.x -= mod(TIME * 5., 256.);
	uv.x /= 3.;
	uv.y = ((UV.y - 0.5) * 1.0/(UV.x) + 0.5);
	
	vec4 tex = texture(noise, uv);
	vec4 final_color = color;
	
	final_color.a = tex.r;
	
	final_color.a = mix(final_color.a, 0., smoothstep(UV.x, 1., uv.y));
	final_color.a = mix(final_color.a, 0., smoothstep(1.-UV.x, 0., uv.y));
	final_color.a = mix(final_color.a, 0., smoothstep(0., limit, length(UV - vec2(0., 0.5))));
	
	final_color.a *= 4.;
	
//	final_color.a = mix(0., 1., smoothstep(0.1, 0.2, final_color.a));

	COLOR = final_color;
}
