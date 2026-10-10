class_name Tendrils
extends Node2D
## Unknown's smoke (docs/technical-plan.md §6.4), after the IMG-0003 concept:
## a dozen wisps streaming back and out from behind his shoulders and spine.
## They are verlet chains simulated in world space, so they trail his motion; a
## slow wave runs down each one and noise sways them, both wilder with
## `agitation` and `pulse`. Each is drawn as a thin tapering Line2D plus strands
## that fray away toward the tip, through a shader that breaks them into
## translucent smoke with lit fibrous edges, and smoke rises off his shoulders.
## The SpriteBody decides whether they draw behind or in front.

const SMOKE := preload("res://src/shaders/smoke_tendril.gdshader")
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
const STRANDS := 2
const STRAND_SPREAD := 30.0
const STRAND_WIDTH := 0.5
## A root farther than this (at scale 1) from where it was means a teleport.
const TELEPORT := 150.0
## The wisps stream backwards, so facing the camera (d) or away (u) shows them
## foreshortened: their rest length per view.
const VIEW_LENGTH := {"r": 1.0, "d": 0.55, "u": 0.7}

## Per chain: the anchor it grows from and how far down the body its root sits
## (pixels at scale 1), its points, segment length and widest width at scale 1,
## and its rest direction in the body's space for each view. "side" faces right
## (behind him is -x); "front" faces the camera; "back" faces away. In front and
## back views a shoulder chain's x points away from the head, whichever side
## that shoulder is on.
const CHAINS: Array[Dictionary] = [
	{"anchor": &"shoulder_l", "drop": 0.0, "points": 15, "segment": 21.0, "width": 18.0,
		"side": Vector2(-0.9, 0.15), "front": Vector2(0.55, 0.83), "back": Vector2(0.55, 0.83)},
	{"anchor": &"shoulder_r", "drop": 6.0, "points": 15, "segment": 21.0, "width": 18.0,
		"side": Vector2(-0.95, -0.05), "front": Vector2(0.55, 0.83), "back": Vector2(0.55, 0.83)},
	{"anchor": &"shoulder_l", "drop": 20.0, "points": 13, "segment": 20.0, "width": 14.0,
		"side": Vector2(-0.8, 0.45), "front": Vector2(0.35, 0.94), "back": Vector2(0.35, 0.94)},
	{"anchor": &"shoulder_r", "drop": 30.0, "points": 13, "segment": 20.0, "width": 14.0,
		"side": Vector2(-0.85, 0.3), "front": Vector2(0.35, 0.94), "back": Vector2(0.35, 0.94)},
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
var _wisps: CPUParticles2D
var _time := 0.0
var _accumulator := 0.0
var _started := false


func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_noise.frequency = 1.0
	for index in CHAINS.size():
		var spec: Dictionary = CHAINS[index]
		var lines: Array[Line2D] = []
		for strand in STRANDS + 1:
			var line := _make_line(index * 0.137 + strand * 0.291)
			line.name = "Tendril%d_%d" % [index, strand]
			line.width = spec["width"] * (1.0 if strand == 0 else STRAND_WIDTH)
			add_child(line)
			lines.append(line)
		var points := PackedVector2Array()
		points.resize(spec["points"])
		_chains.append({"lines": lines, "spec": spec, "points": points, "previous": points.duplicate(), "root": Vector2.ZERO})
	_setup_wisps()


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
	_wisps.position = body.anchor(&"back")


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
	return body.global_transform.basis_xform(dir).normalized()


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
	var spread := STRAND_SPREAD * _body_scale()
	for c in _chains.size():
		var chain := _chains[c]
		var world: PackedVector2Array = chain["points"]
		var lines: Array = chain["lines"]
		var n := world.size()
		var to_line := (lines[0] as Line2D).get_global_transform().affine_inverse()
		for strand in lines.size():
			# Strands leave the chain on alternating sides and fan out toward the tip.
			var side := 0.0 if strand == 0 else (1.0 if strand % 2 == 1 else -1.0) * (0.6 + 0.4 * sin(_time * 0.7 + c + strand))
			var local := PackedVector2Array()
			local.resize(n)
			for i in n:
				var tangent := world[mini(i + 1, n - 1)] - world[maxi(i - 1, 0)]
				var normal := Vector2(-tangent.y, tangent.x).normalized()
				var along := float(i) / (n - 1)
				local[i] = to_line * (world[i] + normal * side * spread * pow(along, 1.3))
			(lines[strand] as Line2D).points = local


func _make_line(seed: float) -> Line2D:
	var material := ShaderMaterial.new()
	material.shader = SMOKE
	material.set_shader_parameter(&"noise_tex", Effects.noise_texture(11, 0.012))
	material.set_shader_parameter(&"seed", seed)
	material.set_shader_parameter(&"edge_light", 0.45)
	material.set_shader_parameter(&"softness", 0.85)
	material.set_shader_parameter(&"fray", 0.8)
	var line := Line2D.new()
	line.width_curve = _taper()
	line.gradient = _fade()
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.material = material
	return line


func _setup_wisps() -> void:
	_wisps = CPUParticles2D.new()
	_wisps.name = "Wisps"
	_wisps.amount = 28
	_wisps.lifetime = 2.8
	_wisps.local_coords = false
	_wisps.texture = Effects.soft_dot()
	_wisps.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_wisps.emission_rect_extents = Vector2(45.0, 70.0)
	_wisps.direction = Vector2(-0.4, -1.0)
	_wisps.spread = 40.0
	_wisps.gravity = Vector2(0.0, -10.0)
	_wisps.initial_velocity_min = 15.0
	_wisps.initial_velocity_max = 45.0
	_wisps.damping_min = 3.0
	_wisps.damping_max = 6.0
	_wisps.scale_amount_min = 2.0
	_wisps.scale_amount_max = 5.5
	var ramp := Gradient.new()
	ramp.set_color(0, Color(0.02, 0.02, 0.03, 0.0))
	ramp.set_color(1, Color(0.02, 0.02, 0.03, 0.0))
	ramp.add_point(0.25, Color(0.03, 0.03, 0.04, 0.3))
	_wisps.color_ramp = ramp
	add_child(_wisps)


static func _taper() -> Curve:
	var curve := Curve.new()
	curve.add_point(Vector2(0.0, 0.3))
	curve.add_point(Vector2(0.25, 1.0))
	curve.add_point(Vector2(1.0, 0.0))
	return curve


static func _fade() -> Gradient:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.03, 0.03, 0.04, 0.6))
	gradient.set_color(1, Color(0.1, 0.1, 0.11, 0.04))
	return gradient
