// adapted from:
// https://www.shadertoy.com/view/Ms3XWH

shader_type canvas_item;
uniform float shake: hint_range(0, 10) = 0.1;
uniform float noiseQuality: hint_range(0.1, 250,0.1) = 50.;
uniform float noiseIntensity: hint_range(0, 0.05,0.001) = 0.02;
uniform float offsetIntensity: hint_range(0, 0.05,0.0001) = 2.;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float rand(float co)
{
    return fract(sin(dot(vec2(co) ,vec2(12.9898,78.233))) * 43758.5453);
}


void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
    for (float i = 0.0; i < 0.71; i += 0.1313)
    {
        float d = TIME * i;
        float o = sin(1.0 - tan(TIME * 0.24 * i));
    	o *= offsetIntensity;
    }
    float noise = sin(uv.y * noiseQuality + TIME * 1.5) + sin(rand(uv.y + TIME * 0.13) * 0.5) * 0.2;
    uv.x += noise * noiseIntensity;
	
	
	vec4 tex = texture(screen_texture, uv);
    COLOR = tex;
}