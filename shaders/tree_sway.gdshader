shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D texture : filter_nearest, source_color;

void vertex(){
	NORMAL = vec3(0.0, 1.0, 0.0);
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * 8.25 + UV.y) * ( 1.5 - UV.y) * 0.01;
	VERTEX.z += cos(NODE_POSITION_WORLD.z + TIME * 8.45 + UV.y) * ( 0.5 - UV.y) * 0.01;
}

void fragment(){
	ALBEDO = texture(texture, UV).rgb;
	ALPHA = texture(texture, UV).a;
}