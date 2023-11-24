shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D grass_texture : filter_nearest, source_color;

void vertex(){
	NORMAL = vec3(0.0, 1.0, 0.0);
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * 2.25 + UV.y) * ( 1.0 - UV.y) * 0.15;
	VERTEX.z += cos(NODE_POSITION_WORLD.z + TIME * 1.45 + UV.y) * ( 1.0 - UV.y) * 0.3;
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);

}

void fragment(){
	ALBEDO = texture(grass_texture, UV).rgb;
	ALPHA = texture(grass_texture, UV).a;
}