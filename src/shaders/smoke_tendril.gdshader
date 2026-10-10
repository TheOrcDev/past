shader_type canvas_item;
// Unknown's smoke cloak (docs/technical-plan.md §6.4). Drawn on a Line2D with
// texture_mode STRETCH, so UV.x runs from the root (0) to the tip (1) and UV.y
// across the line. Each strand is soft smoke rather than a ribbon: a soft
// profile across, eaten at the edges by billowing noise that flows toward the
// tip, opening into holes as it thins, with a faint backlight on its edges so
// it still reads over dark stone. `fray` 0 draws the soft volume under the
// strands; higher values tear the smoke apart.

uniform sampler2D noise_tex : repeat_enable, filter_linear;
uniform float seed = 0.0;
// How fast the smoke flows toward the tip.
uniform float flow = 0.18;
uniform float fray = 0.6;
// How far in from each side the smoke fades (0 hard edge, 1 soft to the spine).
uniform float softness = 0.7;
uniform vec4 edge_color : source_color = vec4(0.80, 0.84, 0.95, 1.0);
uniform float edge_light = 0.22;

void fragment() {
	float across = abs(UV.y - 0.5) * 2.0;
	float along = UV.x;
	float big = texture(noise_tex, vec2(along * 0.55 - TIME * flow + seed, UV.y * 0.22 + seed * 0.7)).r;
	float fine = texture(noise_tex, vec2(along * 1.7 - TIME * flow * 1.6 + seed * 1.3, UV.y * 0.8 + seed)).r;
	float n = big * 0.7 + fine * 0.3;
	float edge = 1.0 - smoothstep(1.0 - softness, 1.0, across + (n - 0.5) * fray * (0.5 + 0.9 * along));
	float holes = smoothstep(0.2 + 0.3 * (1.0 - along), 0.7, n + 0.2);
	float tip = 1.0 - smoothstep(0.55, 1.0, along + (n - 0.5) * 0.45);
	float alpha = clamp(edge * mix(1.0, holes, fray * along) * tip, 0.0, 1.0);
	float rim = clamp(alpha * (1.0 - alpha) * 4.0, 0.0, 1.0);
	COLOR.rgb = mix(COLOR.rgb, edge_color.rgb, rim * edge_light * fray);
	COLOR.a *= alpha;
}
