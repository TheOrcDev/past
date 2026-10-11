class_name Tendrils
extends CanvasGroup
## Unknown's ink (docs/technical-plan.md §6.4), after IMG-0003 v1: fine threads
## pouring back and out from his shoulders and spine like ink let into water.
## They are verlet chains simulated in world space, so they trail his motion; a
## slow wave runs down each one and noise sways them, both wilder with
## `agitation` and `pulse`. Each is drawn as a tapering Line2D plus threads that
## part from it toward the tip, all wavering with a fine ripple that flows to
## the tips. They land in this CanvasGroup as amounts of ink, and liquid.gdshader
## turns that into one dark film: thin threads translucent, crowded ones a sheet.
## The SpriteBody decides whether they draw behind or in front.

const STREAM := preload("res://src/shaders/liquid_stream.gdshader")
const LIQUID := preload("res://src/shaders/liquid.gdshader")
## The film's softening at scale 1, in screen pixels.
const SOFTEN := 2.5
const STEP := 1.0 / 60.0
const ITERATIONS := 3
## Velocity kept per step; the rest is lost to the air, which makes them trail.
const DAMPING := 0.965
## Pull toward the rest shape, per second squared.
const STIFFNESS := 6.0
## Noise push at the tip, in pixels per second squared at scale 1.
const WIND := 700.0
## The wave running down each chain: sideways reach at the tip (pixels at
## scale 1), phase step per point and speed in radians per second.
const WAVE := 42.0
const WAVE_STEP := 0.7
const WAVE_SPEED := 1.8
## Frayed strands per chain, how far their tips spread from it (pixels at
## scale 1) and their width relative to the chain.
const STRANDS := 4
const STRAND_SPREAD := 40.0
const STRAND_WIDTH := 0.4
## Threads are drawn at this fraction of their chain's `width`.
const WIDTH_SCALE := 0.55
## The fine ripple along every thread: waves along its length, reach at the
## tip (pixels at scale 1) and speed in radians per second.
const RIPPLE_WAVES := 6.0
const RIPPLE := 6.0
const RIPPLE_SPEED := 3.0
## Drawn points per simulated segment, so the ripple stays smooth.
const SUBDIVIDE := 4
## A root farther than this (at scale 1) from where it was means a teleport.
const TELEPORT := 150.0
## The wisps stream backwards, so facing the camera (d) or away (u) shows them
## foreshortened: their rest length per view.
const VIEW_LENGTH := {"r": 1.0, "d": 0.8, "u": 0.75}
## Ink is heavy: every rest direction leans this much further down, so the
## cloak pours off his back instead of standing out like wings.
const HANG := 0.35

## Per chain: the anchor it grows from and how far down the body its root sits
## (pixels at scale 1), its points, segment length and widest width at scale 1,
## and its rest direction in the body's space for each view. "side" faces right
## (behind him is -x); "front" faces the camera; "back" faces away. In front and
## back views a shoulder chain's x points away from the head, whichever side
## that shoulder is on.
const CHAINS: Array[Dictionary] = [
	{"anchor": &"shoulder_l", "drop": 0.0, "points": 15, "segment": 21.0, "width": 18.0,
		"side": Vector2(-0.9, 0.15), "front": Vector2(0.8, 0.6), "back": Vector2(0.55, 0.83)},
	{"anchor": &"shoulder_r", "drop": 6.0, "points": 15, "segment": 21.0, "width": 18.0,
		"side": Vector2(-0.95, -0.05), "front": Vector2(0.8, 0.6), "back": Vector2(0.55, 0.83)},
	{"anchor": &"shoulder_l", "drop": 20.0, "points": 13, "segment": 20.0, "width": 14.0,
		"side": Vector2(-0.8, 0.45), "front": Vector2(0.65, 0.76), "back": Vector2(0.35, 0.94)},
	{"anchor": &"shoulder_r", "drop": 30.0, "points": 13, "segment": 20.0, "width": 14.0,
		"side": Vector2(-0.85, 0.3), "front": Vector2(0.65, 0.76), "back": Vector2(0.35, 0.94)},
	{"anchor": &"back", "drop": 0.0, "points": 16, "segment": 22.0, "width": 20.0,
		"side": Vector2(-0.9, 0.1), "front": Vector2(-0.65, 0.76), "back": Vector2(-0.25, 0.97)},
	{"anchor": &"back", "drop": 10.0, "points": 15, "segment": 21.0, "width": 17.0,
		"side": Vector2(-0.75, 0.55), "front": Vector2(0.65, 0.76), "back": Vector2(0.25, 0.97)},
	{"anchor": &"back", "drop": 30.0, "points": 14, "segment": 21.0, "width": 15.0,
		"side": Vector2(-0.95, -0.15), "front": Vector2(-0.45, 0.89), "back": Vector2(-0.55, 0.83)},
	{"anchor": &"back", "drop": 45.0, "points": 14, "segment": 20.0, "width": 14.0,
		"side": Vector2(-0.6, 0.75), "front": Vector2(0.45, 0.89), "back": Vector2(0.55, 0.83)},
	{"anchor": &"back", "drop": 65.0, "points": 13, "segment": 20.0, "width": 12.0,
		"side": Vector2(-0.85, 0.4), "front": Vector2(-0.75, 0.66), "back": Vector2(-0.7, 0.71)},
	{"anchor": &"back", "drop": 85.0, "points": 12, "segment": 19.0, "width": 11.0,
		"side": Vector2(-0.5, 0.85), "front": Vector2(0.75, 0.66), "back": Vector2(0.7, 0.71)},
	{"anchor": &"shoulder_l", "drop": 45.0, "points": 12, "segment": 19.0, "width": 11.0,
		"side": Vector2(-0.98, -0.2), "front": Vector2(0.7, 0.71), "back": Vector2(0.75, 0.66)},
	{"anchor": &"shoulder_r", "drop": 55.0, "points": 12, "segment": 19.0, "width": 11.0,
		"side": Vector2(-0.7, 0.65), "front": Vector2(0.25, 0.97), "back": Vector2(0.3, 0.95)},
]

var body: SpriteBody
## 0 calm drift, 1 agitated.
var agitation := 0.0
## Extra push from his voice, 0–1.
var pulse := 0.0

var _chains: Array[Dictionary] = []
var _noise := FastNoiseLite.new()
var _time := 0.0
var _accumulator := 0.0
var _started := false


func _ready() -> void:
	var liquid := ShaderMaterial.new()
	liquid.shader = LIQUID
	liquid.set_shader_parameter(&"noise_tex", Effects.noise_texture(23, 0.01))
	material = liquid
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_noise.frequency = 1.0
	for index in CHAINS.size():
		var spec: Dictionary = CHAINS[index]
		var lines: Array[Line2D] = []
		for strand in STRANDS + 1:
			var line := _make_line(index * 0.137 + strand * 0.291)
			line.name = "Tendril%d_%d" % [index, strand]
			line.width = spec["width"] * WIDTH_SCALE * (1.0 if strand == 0 else STRAND_WIDTH)
			add_child(line)
			lines.append(line)
		var points := PackedVector2Array()
		points.resize(spec["points"])
		_chains.append({"lines": lines, "spec": spec, "points": points, "previous": points.duplicate(), "root": Vector2.ZERO})


func _process(delta: float) -> void:
	if body == null or body.sprites == null:
		return
	if not _started or _teleported():
		_reset()
		_started = true
	_accumulator = minf(_accumulator + delta, STEP * 8.0)
	while _accumulator >= STEP:
		_accumulator -= STEP
		_time += STEP
		_simulate()
	_draw_lines()
	_fit_liquid()


## The tendril points in world space, root first, for tests and effects.
func chain_points(index: int) -> PackedVector2Array:
	return _chains[index]["points"]


func chain_count() -> int:
	return _chains.size()


func _root_target(spec: Dictionary) -> Vector2:
	return body.to_global(body.anchor(spec["anchor"]) + Vector2(0.0, spec["drop"]))


func _rest_direction(spec: Dictionary) -> Vector2:
	var view := body.view()
	var dir: Vector2 = spec["side"]
	if view == "d":
		dir = spec["front"]
	elif view == "u":
		dir = spec["back"]
	if (view == "d" or view == "u") and String(spec["anchor"]).begins_with("shoulder"):
		var side := body.anchor(spec["anchor"]).x - body.anchor(&"head").x
		dir.x = absf(dir.x) * (signf(side) if absf(side) > 1.0 else 1.0)
	return body.global_transform.basis_xform((dir + Vector2(0.0, HANG)).normalized()).normalized()


func _body_scale() -> float:
	return absf(body.global_transform.get_scale().y)


func _teleported() -> bool:
	var limit := TELEPORT * _body_scale()
	for chain in _chains:
		if (chain["root"] as Vector2).distance_to(_root_target(chain["spec"])) > limit:
			return true
	return false


## Lays every chain out in its rest shape at the current anchors.
func _reset() -> void:
	var scale_y := _body_scale()
	for chain in _chains:
		var spec: Dictionary = chain["spec"]
		var root := _root_target(spec)
		var rest: Vector2 = _rest_direction(spec) * spec["segment"] * scale_y * VIEW_LENGTH.get(body.view(), 1.0)
		var points: PackedVector2Array = chain["points"]
		for i in points.size():
			points[i] = root + rest * i
		chain["root"] = root
		chain["points"] = points
		chain["previous"] = points.duplicate()


func _simulate() -> void:
	var scale_y := _body_scale()
	var wild := 1.0 + agitation * 1.8 + pulse * 0.8
	for c in _chains.size():
		var chain := _chains[c]
		var spec: Dictionary = chain["spec"]
		# The root eases after the anchor, so stepped walking does not jerk the smoke.
		var root := (chain["root"] as Vector2).lerp(_root_target(spec), 1.0 - exp(-STEP * 30.0))
		var segment: float = spec["segment"] * scale_y * VIEW_LENGTH.get(body.view(), 1.0)
		var rest := _rest_direction(spec)
		var across := Vector2(-rest.y, rest.x)
		var points: PackedVector2Array = chain["points"]
		var previous: PackedVector2Array = chain["previous"]
		var n := points.size()
		points[0] = root
		previous[0] = root
		for i in range(1, n):
			var along := float(i) / (n - 1)
			var p := points[i]
			var wave := sin(i * WAVE_STEP - _time * WAVE_SPEED * wild + c * 1.7) * WAVE * scale_y * along
			var target := root + rest * segment * i + across * wave
			var t := _time * 0.55 * wild - i * 0.12
			var wind := Vector2(_noise.get_noise_2d(t, c * 17.3), _noise.get_noise_2d(t + 50.0, c * 17.3 + 9.1))
			var accel := (target - p) * STIFFNESS + wind * WIND * scale_y * wild * (0.3 + 0.7 * along)
			var velocity := (p - previous[i]) * DAMPING
			previous[i] = p
			points[i] = p + velocity + accel * STEP * STEP
		for iteration in ITERATIONS:
			for i in range(1, n):
				var d := points[i] - points[i - 1]
				var length := d.length()
				if length < 0.0001:
					continue
				var wanted := clampf(length, segment * 0.85, segment * 1.15)
				if wanted == length:
					continue
				var fix := d * (1.0 - wanted / length)
				if i == 1:
					points[i] -= fix
				else:
					points[i - 1] += fix * 0.5
					points[i] -= fix * 0.5
		chain["root"] = root
		chain["points"] = points
		chain["previous"] = previous


func _draw_lines() -> void:
	var scale_y := _body_scale()
	var spread := STRAND_SPREAD * scale_y
	var ripple := RIPPLE * scale_y * (1.0 + agitation * 0.8 + pulse * 0.5)
	for c in _chains.size():
		var chain := _chains[c]
		var world := _smooth(chain["points"])
		var lines: Array = chain["lines"]
		var n := world.size()
		var to_line := (lines[0] as Line2D).get_global_transform().affine_inverse()
		var normals := PackedVector2Array()
		normals.resize(n)
		for i in n:
			var tangent := world[mini(i + 1, n - 1)] - world[maxi(i - 1, 0)]
			normals[i] = Vector2(-tangent.y, tangent.x).normalized()
		for strand in lines.size():
			# Threads leave the chain on alternating sides and fan out toward the tip.
			var side := 0.0 if strand == 0 else (1.0 if strand % 2 == 1 else -1.0) * (0.35 + 0.3 * strand) * (0.7 + 0.3 * sin(_time * 0.7 + c + strand))
			var phase := c * 2.3 + strand * 1.9
			var local := PackedVector2Array()
			local.resize(n)
			for i in n:
				var along := float(i) / (n - 1)
				var wobble := sin(along * RIPPLE_WAVES * TAU - _time * RIPPLE_SPEED + phase) * ripple * pow(along, 0.7)
				local[i] = to_line * (world[i] + normals[i] * (side * spread * pow(along, 1.3) + wobble))
			(lines[strand] as Line2D).points = local


## The chain through Catmull-Rom curves, SUBDIVIDE points per segment.
func _smooth(points: PackedVector2Array) -> PackedVector2Array:
	var n := points.size()
	var out := PackedVector2Array()
	out.resize((n - 1) * SUBDIVIDE + 1)
	for i in n - 1:
		var p0 := points[maxi(i - 1, 0)]
		var p1 := points[i]
		var p2 := points[i + 1]
		var p3 := points[mini(i + 2, n - 1)]
		for k in SUBDIVIDE:
			var t := float(k) / SUBDIVIDE
			out[i * SUBDIVIDE + k] = 0.5 * (2.0 * p1 + (p2 - p0) * t + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t * t + (3.0 * p1 - p0 - 3.0 * p2 + p3) * t * t * t)
	out[out.size() - 1] = points[n - 1]
	return out


func _make_line(seed: float) -> Line2D:
	var stream := ShaderMaterial.new()
	stream.shader = STREAM
	stream.set_shader_parameter(&"noise_tex", Effects.noise_texture(11, 0.012))
	stream.set_shader_parameter(&"seed", seed)
	var line := Line2D.new()
	line.width_curve = _taper()
	line.gradient = _fade()
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.material = stream
	return line


## The softening and ripple are in screen pixels, so they follow his scale on screen.
func _fit_liquid() -> void:
	var screen := get_viewport().get_final_transform() * get_global_transform_with_canvas()
	var radius := SOFTEN * absf(screen.get_scale().y)
	var liquid := material as ShaderMaterial
	liquid.set_shader_parameter(&"radius", radius)
	liquid.set_shader_parameter(&"ripple", radius * 0.6)
	liquid.set_shader_parameter(&"origin", screen.origin)
	fit_margin = radius * 2.0 + 4.0
	clear_margin = fit_margin


static func _taper() -> Curve:
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.5))
	curve.add_point(Vector2(0.15, 1.0))
	curve.add_point(Vector2(1.0, 0.35))
	return curve


static func _fade() -> Gradient:
	var gradient := Gradient.new()
	# Only the alpha matters: it is the amount of ink, thinning out to nothing,
	# so threads dissolve at their ends rather than ending in points.
	gradient.set_color(0, Color(0.0, 0.0, 0.0, 1.0))
	gradient.set_color(1, Color(0.0, 0.0, 0.0, 0.0))
	gradient.add_point(0.4, Color(0.0, 0.0, 0.0, 0.7))
	return gradient
