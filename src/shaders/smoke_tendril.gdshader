shader_type canvas_item;
// Unknown's smoke tendrils (docs/technical-plan.md §6.4). Drawn on a Line2D
// with texture_mode STRETCH, so UV.x runs from the root (0) to the tip (1) and
// UV.y across the line. Noise stretched along the line frays the edges into
// strands that flow toward the tip, and the tip dissolves.

uniform sampler2D noise_tex : repeat_enable, filter_linear;
uniform float seed = 0.0;
// How fast the smoke runs toward the tip.
uniform float flow = 0.22;
// 0 keeps the tendril solid, 1 breaks it into separate strands.
uniform float fray = 0.6;

void fragment() {
	float across = abs(UV.y - 0.5) * 2.0;
	float along = UV.x;
	float n = texture(noise_tex, vec2(along * 0.9 - TIME * flow + seed, UV.y * 0.35 + seed * 0.37)).r;
	float strands = texture(noise_tex, vec2(along * 0.22 - TIME * flow * 0.5 + seed * 0.61, UV.y * 2.4 + seed)).r;
	float body = 1.0 - smoothstep(0.2 + 0.55 * n, 1.0, across);
	body *= mix(1.0, smoothstep(0.38, 0.72, strands), fray * (0.25 + 0.75 * along));
	float tip = 1.0 - smoothstep(0.55, 1.0, along + (n - 0.5) * 0.35);
	COLOR.a *= clamp(body * tip, 0.0, 1.0);
}
