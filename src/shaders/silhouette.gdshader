shader_type canvas_item;
// Unknown's body (docs/technical-plan.md §6.4). Shaded frames carry his lit,
// near-black skin in grey and his coverage in alpha (LA8); flat frames are a
// one-byte alpha mask (L8, read from red). He is drawn as living shadow:
// - his skin is the render's shading pushed darker by a contrast curve, and the
//   edges of the silhouette dissolve into smoke that rises;
// - a dark haze drifts around him;
// - a cold rim light runs along the edges facing the light, brighter over dark
//   backgrounds so he stays readable.
// Sprite frames keep a transparent border (tools/art pack.py BORDER) wide enough
// for the haze.

uniform vec4 body_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform bool shaded = false;
// The shading curve: higher contrast sinks the mid-tones towards black and keeps
// the rim highlights; brightness scales what is left.
uniform float contrast = 2.4;
uniform float brightness = 0.9;
uniform vec4 rim_color : source_color = vec4(0.80, 0.84, 0.95, 1.0);
uniform sampler2D noise_tex : repeat_enable, filter_linear;
// Rim width in texels of the render frame.
uniform float rim_width = 2.5;
// Where the light comes from, in screen space (y down).
uniform vec2 light_dir = vec2(-0.45, -1.0);
// The body is mirrored to face left, so texture space is mirrored too.
uniform bool mirrored = false;
uniform float rim_over_dark = 0.5;
uniform float rim_over_light = 0.06;
uniform bool adaptive = true;
// How deep the smoke eats into his edges, and how far the haze reaches (texels).
uniform float dissolve = 0.55;
uniform float haze_reach = 16.0;
uniform float haze_strength = 0.55;
// How fast the smoke rises, in noise tiles per second.
uniform float rise = 0.12;
uniform sampler2D screen : hint_screen_texture, filter_linear;

varying vec2 local_pos;

void vertex() {
	// The sprite's own space (feet at the origin), so the smoke pattern stays put
	// as frames change instead of jumping with each frame's place in the atlas.
	local_pos = VERTEX;
}

// Coverage at `uv`: alpha for shaded frames, red for alpha masks.
float cover(sampler2D tex, vec2 uv, bool is_shaded) {
	vec4 t = texture(tex, uv);
	return is_shaded ? t.a : t.r;
}

// Mean coverage on a ring of 8 taps `radius` texels around `uv`.
float ring(sampler2D tex, vec2 uv, vec2 texel, float radius, bool is_shaded) {
	float sum = 0.0;
	for (int i = 0; i < 8; i++) {
		float a = float(i) * 0.785398;
		sum += cover(tex, uv + vec2(cos(a), sin(a)) * texel * radius, is_shaded);
	}
	return sum / 8.0;
}

void fragment() {
	vec2 texel = TEXTURE_PIXEL_SIZE;
	vec4 tex = texture(TEXTURE, UV);
	float m = shaded ? tex.a : tex.r;
	vec3 skin = shaded ? vec3(pow(clamp(tex.r, 0.0, 1.0), contrast) * brightness) : body_color.rgb;
	// How deep inside the silhouette this point is: about 1 deep inside, 0.5 at the edge.
	float near = (m + ring(TEXTURE, UV, texel, 2.0, shaded) + ring(TEXTURE, UV, texel, 4.0, shaded)) / 3.0;
	float far = (ring(TEXTURE, UV, texel, haze_reach * 0.5, shaded) + ring(TEXTURE, UV, texel, haze_reach, shaded)) * 0.5;

	vec2 smoke_uv = local_pos / 260.0 + vec2(0.0, TIME * rise);
	float n1 = texture(noise_tex, smoke_uv).r;
	float n2 = texture(noise_tex, smoke_uv * 2.3 + vec2(0.37, TIME * rise * 0.8)).r;
	float n = n1 * 0.65 + n2 * 0.35;

	// Edges dissolve: the shallower the point, the more the smoke can take it.
	float body = m * smoothstep(0.35, 0.6, near + (n - 0.5) * dissolve);
	// Haze outside him: wisps where the noise is thick, fading with distance.
	float haze = (1.0 - m) * far * smoothstep(0.35, 0.85, n) * haze_strength;

	vec2 light = normalize(light_dir);
	if (mirrored) {
		light.x = -light.x;
	}
	float lit = clamp(m - cover(TEXTURE, UV + light * texel * rim_width, shaded), 0.0, 1.0);
	float rim = lit * smoothstep(0.45, 0.75, near + (n - 0.5) * 0.3);
	float strength = mix(rim_over_dark, rim_over_light, 0.5);
	if (adaptive) {
		vec3 behind = texture(screen, SCREEN_UV).rgb;
		float luma = dot(behind, vec3(0.2126, 0.7152, 0.0722));
		strength = mix(rim_over_dark, rim_over_light, smoothstep(0.08, 0.55, luma));
	}
	float alpha = max(body, haze);
	vec3 color = mix(skin, rim_color.rgb, rim * strength * step(0.5, body));
	COLOR = vec4(color, alpha * COLOR.a);
}
