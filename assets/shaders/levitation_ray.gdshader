shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float thickness = 1.0;
uniform vec4 ray_color: source_color;
uniform vec4 outline_color: source_color;
uniform float deformation = 1.0;
uniform int rays = 2;
uniform float speed = 1.0;
uniform float outline_fade = 0.15;
uniform float outline_percent = 0.7;
uniform float outline_transition = 1.;
uniform float noise_scale = 1.0;
uniform float edge_fade = 0.03;

varying float t;
varying float o_t;
varying float d;
varying float o_w;
varying float o_p;

vec4 ray(vec2 uv, float offset) {
	vec4 noise_c = texture(noise, vec2(uv.x * noise_scale + offset, 0.5) + TIME * speed * vec2(0, 1.));
	float noise_value = length(noise_c.rgb) * 0.5774;
	float noise_movement =  d *  (noise_value - 0.5);
	float x_influence = (2.*uv.x - 1.);
	float noise_influence = - (x_influence * x_influence) + 1.0;
	noise_movement *= noise_influence;
	float uv_y_ref = (uv.y - 0.5) / (smoothstep(0.5, 0.5 - edge_fade, abs(uv.x - 0.5))) - noise_movement;
	float alpha = smoothstep(- t -o_w, - t + o_w, uv_y_ref) * smoothstep(t + o_w, t - o_w, uv_y_ref);
	float percent = smoothstep(o_p - o_t, o_p+o_t, abs(uv_y_ref));
	vec4 c = mix(ray_color, outline_color, percent);
	c.a = alpha;
	return c;
}
void fragment() {
	vec2 uv = UV;
	vec4 c = vec4(0.);
	t = thickness * 0.05;
	o_t = outline_transition * 0.015;
	d = deformation * 0.5;
	o_w = t * outline_fade;
	o_p = t * (1.-outline_percent);
	
	for(int i = 0; i<rays; i++) {
		c = max(ray(uv, float(i) * 0.2), c);
	}
	
	COLOR = c;
}

