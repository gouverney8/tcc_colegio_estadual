shader_type canvas_item;

uniform vec4 color_deep : source_color = vec4(0.12, 0.48, 0.50, 1.0);
uniform vec4 color_mid : source_color = vec4(0.38, 0.82, 0.76, 1.0);
uniform vec4 color_surface : source_color = vec4(0.72, 0.97, 0.90, 1.0);
uniform vec4 color_foam : source_color = vec4(0.98, 0.97, 0.78, 0.90);
uniform vec4 heat_gold : source_color = vec4(1.0, 0.88, 0.45, 1.0);
uniform float heat : hint_range(0.0, 1.0) = 0.0;
uniform float time_scale = 2.1;

void fragment() {
	float t = TIME * time_scale;
	vec2 uv = UV;
	float wave = sin(uv.y * 16.0 + t * 2.4) * 0.018 + sin(uv.y * 8.0 - t * 1.6) * 0.028;
	float swirl = 0.55 + 0.25 * sin(uv.x * 9.0 + t * 1.8 + uv.y * 4.0) + 0.15 * sin(uv.x * 4.0 - t);
	vec4 body = mix(color_deep, color_mid, clamp(swirl, 0.0, 1.0));
	body = mix(body, color_surface, clamp(uv.y * 0.35 + 0.12 * sin(t + uv.x * 6.0), 0.0, 0.55));
	body = mix(body, heat_gold, heat * 0.82);
	float highlight = smoothstep(0.16, 0.0, abs(uv.y - 0.26 - 0.05 * sin(t * 1.3 + uv.x * 10.0)));
	body.rgb += highlight * (0.18 + heat * 0.12);
	float meniscus = smoothstep(0.78 + wave, 1.0, uv.x);
	body = mix(body, mix(color_foam, heat_gold, heat), meniscus * 0.62);
	float pad = 0.18;
	float round_y = min(smoothstep(0.0, pad, uv.y), smoothstep(1.0, 1.0 - pad, uv.y));
	float round_x = smoothstep(0.0, 0.07, uv.x);
	body.a *= round_y * round_x;
	COLOR = body;
}
