shader_type canvas_item;

uniform sampler2D cloud_texture: source_color;
uniform float cloudiness = 0.5;
uniform float uv_scale = 0.5;
uniform vec2 speed = vec2(0.01, 0.0);
uniform float contrast = 1.5;
uniform vec4 cloud_color = vec4(1.0, 1.0, 1.0, 0.9);
uniform vec4 sky_color = vec4(0.4, 0.6, 0.9, 1.0);
uniform float amount = 40.;



float apply_contrast(float v, float c) {
    return mix(0.5, v, c);
}

void fragment() {
	vec2 grid_uv = round(UV * float(amount)) / float(amount);
    vec2 uv = fract(grid_uv * uv_scale + speed * TIME);
    float t = texture(cloud_texture, uv).r;
    //float contrasted = apply_contrast(t, contrast);
    float mask = smoothstep(1.0 - cloudiness, 1.0, t);
    vec4 col = mix(sky_color, cloud_color, mask);
    COLOR = col;
}