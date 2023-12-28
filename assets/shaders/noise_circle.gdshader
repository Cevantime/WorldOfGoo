shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0, 0, 0, 1.0);
uniform float radius = 0.5;
uniform float fade = 0.01;
uniform sampler2D noise: repeat_enable;
uniform float thickness = 0.05;
uniform float speed = 1.0;

void fragment() {
	vec4 c = color;
	vec2 uv = UV - 0.5;
	float dist = length(uv);
	vec4 n = texture(noise,  vec2((atan(uv.y / uv.x) / PI), TIME * 0.1 * speed));
	float n_v = length(n.rgb) * 0.5574;
	n_v -= 0.5;
	n_v *= 0.1;
	//n_v = 0.;
	c.a = smoothstep(thickness + fade, thickness - fade, abs(dist - radius + n_v));
	COLOR = c;
}

