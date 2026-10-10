shader_type canvas_item;
// An inner ring of a pull-back reveal (docs/technical-plan.md §6.3): its edges
// fade out so it melts into the ring outside it. Matches the feather of
// tools/art past_art.rings: a smoothstep over `feather` of the shorter side.

uniform float feather = 0.08;

void fragment() {
	vec2 size = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 px = UV * size;
	float edge = min(min(px.x, size.x - px.x), min(px.y, size.y - px.y));
	COLOR.a *= smoothstep(0.0, feather * min(size.x, size.y), edge);
}
