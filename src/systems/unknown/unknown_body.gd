class_name UnknownBody
extends SpriteBody
## Unknown as the player sees him (docs/technical-plan.md §6.4): the rendered
## silhouette drawn black with a rim light, two glowing eyes that blink and
## act, and smoke tendrils streaming from his shoulders and back.

enum EyeState { IDLE, NARROW, WIDE, FLARE }

const SILHOUETTE := preload("res://src/shaders/silhouette.gdshader")
## Per state: glow strength and eye shape (width, height).
const EYE_STATES := {
	EyeState.IDLE: [1.0, Vector2(1.0, 1.0)],
	EyeState.NARROW: [0.8, Vector2(1.1, 0.45)],
	EyeState.WIDE: [1.25, Vector2(1.05, 1.4)],
	EyeState.FLARE: [2.6, Vector2(1.35, 1.35)],
}
## Eye sprite scale in the IDLE state, before the actor's depth scale: slits on
## the rendered body, round dots like the painted ones on the painted body.
const EYE_SIZE := Vector2(0.34, 0.2)
const PAINTED_EYE_SIZE := Vector2(0.36, 0.36)
## A side view shows each eye this much narrower.
const SIDE_WIDTH := 0.6
const PAINTED_SIDE_WIDTH := 0.85
const BLINK_SECONDS := 0.16
## The painted body's breathing on a held drawing: how much he grows and
## sways (around his feet) and the periods in seconds.
const BREATH := 0.007
const BREATH_SECONDS := 3.8
const SWAY := 0.005
const SWAY_SECONDS := 6.1
## The light-absorbing aura behind him: its size in his own pixels, where it
## centres, and how dark it is at the middle.
const AURA_SIZE := Vector2(560.0, 720.0)
const AURA_CENTER := Vector2(0.0, -250.0)
const AURA_DARKNESS := 0.32

@export var eye_state := EyeState.IDLE
## 0 calm, 1 agitated: wilder smoke.
@export_range(0.0, 1.0) var agitation := 0.0
## How loud his voice is, 0–1: the playing line's envelope (Voice), or a
## stand-in flicker while he speaks a line that has no audio yet.
var voice_level := 0.0

var tendrils: Tendrils
var aura: Sprite2D

var _eyes: Array[Sprite2D] = []
var _glow := 1.0
var _shape := Vector2.ONE
var _openness := 1.0
var _blink_in := 3.0
var _blink_time := -1.0
var _speaking := false
var _time := 0.0
var _flare_id := 0
var _before_flare := EyeState.IDLE


func _ready() -> void:
	super()
	var material := ShaderMaterial.new()
	material.shader = SILHOUETTE
	material.set_shader_parameter(&"noise_tex", Effects.noise_texture(31, 0.02))
	material.set_shader_parameter(&"shaded", sprites.shaded)
	material.set_shader_parameter(&"painted", sprites.painted)
	if sprites.painted:
		material.set_shader_parameter(&"contrast", 1.2)
		material.set_shader_parameter(&"brightness", 1.0)
		material.set_shader_parameter(&"haze_strength", 0.3)
		material.set_shader_parameter(&"rim_over_dark", 0.35)
		material.set_shader_parameter(&"rim_over_light", 0.0)
	sprite.material = material
	aura = Sprite2D.new()
	aura.name = "Aura"
	aura.texture = Effects.soft_dot()
	aura.scale = AURA_SIZE / aura.texture.get_size()
	aura.position = AURA_CENTER
	aura.modulate = Color(0.0, 0.0, 0.0, AURA_DARKNESS)
	add_child(aura)
	tendrils = Tendrils.new()
	tendrils.name = "Tendrils"
	tendrils.body = self
	# The painted coat frays into ink of its own (plan 010).
	tendrils.visible = not sprites.painted
	add_child(tendrils)
	for side in ["L", "R"]:
		var eye := Sprite2D.new()
		eye.name = "Eye" + side
		eye.texture = Effects.painted_eye() if sprites.painted else Effects.eye_glow()
		var additive := CanvasItemMaterial.new()
		additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		eye.material = additive
		add_child(eye)
		_eyes.append(eye)
	frame_shown.connect(_place_eyes)
	_place_eyes()
	_order_layers()


func play_animation(anim: StringName, flip: bool) -> void:
	super(anim, flip)
	(sprite.material as ShaderMaterial).set_shader_parameter(&"mirrored", flip)
	_order_layers()


func set_speaking(on: bool) -> void:
	_speaking = on


func blink() -> void:
	_blink_time = 0.0


## Flares the eyes for `seconds`, then returns them to the state they had.
func flare(seconds := 1.2) -> void:
	_flare_id += 1
	if eye_state != EyeState.FLARE:
		_before_flare = eye_state
	eye_state = EyeState.FLARE
	get_tree().create_timer(seconds).timeout.connect(_end_flare.bind(_flare_id))


func _end_flare(id: int) -> void:
	if id == _flare_id:
		eye_state = _before_flare


func _process(delta: float) -> void:
	_time += delta
	# By path, so the scaffolds that build him still compile without autoloads.
	var voice := get_node_or_null(^"/root/Voice")
	if _speaking and voice and voice.is_playing():
		voice_level = move_toward(voice_level, voice.level(), delta * 12.0)
	elif _speaking:
		# No audio for this line yet: a syllable-rate flicker stands in.
		var target := 0.35 + 0.65 * absf(sin(_time * 9.0) * sin(_time * 3.7 + 1.3))
		voice_level = move_toward(voice_level, target, delta * 6.0)
	else:
		voice_level = move_toward(voice_level, 0.0, delta * 3.0)
	var state: Array = EYE_STATES[eye_state]
	var ease_in := 1.0 - exp(-delta * 10.0)
	_glow = lerpf(_glow, state[0] * (1.0 + 0.45 * voice_level), ease_in)
	_shape = _shape.lerp(state[1], ease_in)
	_update_blink(delta)
	var width := (PAINTED_SIDE_WIDTH if sprites.painted else SIDE_WIDTH) if view() == "r" else 1.0
	var size := PAINTED_EYE_SIZE if sprites.painted else EYE_SIZE
	for eye in _eyes:
		eye.scale = size * _shape * Vector2(width, _openness)
		eye.modulate = Color(_glow, _glow, _glow)
	tendrils.agitation = agitation
	tendrils.pulse = voice_level
	if sprites.painted:
		_breathe()
	aura.modulate.a = AURA_DARKNESS * (1.0 + 0.25 * voice_level + 0.35 * agitation)


## A held drawing breathes: he swells and sways a little around his feet, so
## limited animation never looks frozen. Walks move on their own.
func _breathe() -> void:
	var held := not String(sprite.animation).begins_with("walk")
	var breath := sin(_time * TAU / BREATH_SECONDS) if held else 0.0
	sprite.scale = Vector2(1.0 - BREATH * 0.4 * breath, 1.0 + BREATH * breath)
	sprite.skew = SWAY * sin(_time * TAU / SWAY_SECONDS) if held else 0.0


## Back to front: the aura, then the smoke behind the body, or the body first
## when he faces away and his back and its smoke face the camera.
func _order_layers() -> void:
	if aura == null or tendrils == null:
		return
	var order: Array[Node] = [aura, tendrils, sprite]
	if view() == "u":
		order = [aura, sprite, tendrils]
	for i in order.size():
		move_child(order[i], i)
	_place_held()


func _place_eyes() -> void:
	for i in _eyes.size():
		_eyes[i].visible = eye_visible(i)
		_eyes[i].position = anchor(&"eye_l" if i == 0 else &"eye_r")


func _update_blink(delta: float) -> void:
	if _blink_time < 0.0:
		_openness = 1.0
		_blink_in -= delta
		if _blink_in <= 0.0 and eye_state != EyeState.FLARE:
			_blink_time = 0.0
		return
	_blink_time += delta
	if _blink_time >= BLINK_SECONDS:
		_blink_time = -1.0
		_blink_in = randf_range(2.5, 6.5)
		_openness = 1.0
	else:
		_openness = lerpf(1.0, 0.08, sin(_blink_time / BLINK_SECONDS * PI))
