shader_type canvas_item;
// Unknown's body (docs/technical-plan.md §6.4). The sprite is a one-byte alpha
// mask (read from the red channel), drawn as a black silhouette with a light
// rim along the edges that face the light. Over dark backgrounds the rim
// brightens so he stays readable; over bright ones it fades.

uniform vec4 body_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 rim_color : source_color = vec4(0.80, 0.84, 0.95, 1.0);
// Rim width in texels of the render frame.
uniform float rim_width = 2.5;
// Where the light comes from, in screen space (y down).
uniform vec2 light_dir = vec2(-0.45, -1.0);
// The body is mirrored to face left, so texture space is mirrored too.
uniform bool mirrored = false;
// Rim strength over a black background and over a bright one.
uniform float rim_over_dark = 0.9;
uniform float rim_over_light = 0.22;
// Read what is behind him to pick the rim strength; off uses the average.
uniform bool adaptive = true;
uniform sampler2D screen : hint_screen_texture, filter_linear;

void fragment() {
	float m = texture(TEXTURE, UV).r;
	vec2 texel = TEXTURE_PIXEL_SIZE * rim_width;
	vec2 light = normalize(light_dir);
	if (mirrored) {
		light.x = -light.x;
	}
	// Lit edge: inside the silhouette, with nothing between it and the light.
	float lit = clamp(m - texture(TEXTURE, UV + light * texel).r, 0.0, 1.0);
	// A thinner rim all round, so the outline never disappears.
	float around = min(
		min(texture(TEXTURE, UV + vec2(texel.x, 0.0)).r, texture(TEXTURE, UV - vec2(texel.x, 0.0)).r),
		min(texture(TEXTURE, UV + vec2(0.0, texel.y)).r, texture(TEXTURE, UV - vec2(0.0, texel.y)).r));
	float edge = clamp(m - around, 0.0, 1.0);
	float rim = clamp(lit * 0.9 + edge * 0.3, 0.0, 1.0);
	float strength = mix(rim_over_dark, rim_over_light, 0.5);
	if (adaptive) {
		vec3 behind = texture(screen, SCREEN_UV).rgb;
		float luma = dot(behind, vec3(0.2126, 0.7152, 0.0722));
		strength = mix(rim_over_dark, rim_over_light, smoothstep(0.08, 0.55, luma));
	}
	COLOR = vec4(mix(body_color.rgb, rim_color.rgb, rim * strength), m * COLOR.a);
}
