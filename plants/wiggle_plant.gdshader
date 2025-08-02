shader_type canvas_item;

uniform float frequency = 5.0;
uniform float amplitude = 0.3;
uniform float speed     = 0.1;

void vertex()
{
	vec2 uv = UV;
	VERTEX.x += sin((uv.y + TIME * speed) * frequency) * amplitude;
}
