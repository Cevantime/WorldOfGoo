shader_type canvas_item;

uniform vec4 outline_color :source_color; 
uniform float width = 0.05;

void fragment() {
	vec4 color = COLOR;
	if(color.a >= 0.1) {
		COLOR = color;
	} else {
		bool found_edge = false;
		for(int i = -1; i <= 1; i++) {
			for(int j = -1; j <= 1; j++) {
				vec4 c_neighbour = texture(TEXTURE, UV + vec2(float(i) * width, float(j) * width));
				if(c_neighbour.a > 0.15) {
					found_edge = true;
					break;
				}
			}
			if(found_edge) {
				break;
			}
		}
		if(found_edge) {
			COLOR = outline_color;
		} else {
			COLOR.a = 0.0;
		}
	}
}