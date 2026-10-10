@tool
class_name Effects
extends RefCounted
## Shared, cached textures for the living-painting effects.

static var _noise_cache := {}
static var _dot: Texture2D


## A seamless noise texture, generated once per (seed, frequency).
static func noise_texture(noise_seed: int, frequency: float) -> NoiseTexture2D:
	var key := "%d:%f" % [noise_seed, frequency]
	if _noise_cache.has(key):
		return _noise_cache[key]
	var noise := FastNoiseLite.new()
	noise.seed = noise_seed
	noise.frequency = frequency
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_octaves = 4
	var texture := NoiseTexture2D.new()
	texture.width = 512
	texture.height = 512
	texture.seamless = true
	texture.noise = noise
	_noise_cache[key] = texture
	return texture


## A small soft round dot for particles.
static func soft_dot() -> Texture2D:
	if _dot:
		return _dot
	var gradient := Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))
	gradient.set_color(1, Color(1, 1, 1, 0))
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0.5, 0.0)
	texture.width = 16
	texture.height = 16
	_dot = texture
	return _dot
