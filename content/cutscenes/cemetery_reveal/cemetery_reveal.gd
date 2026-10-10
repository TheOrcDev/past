extends Node2D
## The prologue's opening (plan 002, slice 6). The shot opens close on Unknown on
## the cemetery path, then the camera pulls back across the zoom stack to the
## whole vista and the title card shows. It ends on black, ready for the first
## room. Holding the Skip button (or Esc) fast-forwards it, so a skipped opening
## ends the same way. With Reduce camera motion the pull-back becomes one
## crossfade to the vista.

signal finished

const FADE_IN := 1.5
const FADE_OUT := 1.0
const SKIP_SPEED := 12.0
## Reduce camera motion: when, on the animation's clock, the close shot
## crossfades to the vista (the middle of the pull-back), and for how long.
const CUT_AT := 6.0
const CROSSFADE := 1.6

@onready var reveal: Reveal = $Reveal
@onready var unknown: UnknownBody = $Reveal/Unknown
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var title: Control = $Title/Card

var letterbox: Letterbox
var skip_button: SkipButton
var playing := false

var _fade: ColorRect
var _skipping := false


func _ready() -> void:
	letterbox = Letterbox.new()
	letterbox.name = "Letterbox"
	add_child(letterbox)
	var fade_layer := CanvasLayer.new()
	fade_layer.layer = 99
	add_child(fade_layer)
	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_layer.add_child(_fade)
	title.modulate.a = 0.0
	unknown.play_animation(&"idle_r", false)
	skip_button = SkipButton.new()
	skip_button.name = "SkipButton"
	skip_button.skipped.connect(skip)
	add_child(skip_button)


## Plays the whole opening and returns on black.
func play() -> void:
	playing = true
	reveal.camera.make_current()
	letterbox.show_bars(0.0)
	_fade_to(0.0, FADE_IN)
	reveal.hold = Settings.reduce_camera_motion
	animation.play(&"reveal")
	if reveal.hold:
		_crossfade_to_vista()
	await animation.animation_finished
	await _fade_to(1.0, FADE_OUT / animation.speed_scale)
	playing = false
	finished.emit()


func skip() -> void:
	if playing and not _skipping:
		_skipping = true
		animation.speed_scale = SKIP_SPEED


## Called from the animation.
func show_title() -> void:
	var tween := create_tween()
	tween.set_speed_scale(animation.speed_scale)
	tween.tween_property(title, ^"modulate:a", 1.0, 1.4)


## Called from the animation.
func hide_title() -> void:
	var tween := create_tween()
	tween.set_speed_scale(animation.speed_scale)
	tween.tween_property(title, ^"modulate:a", 0.0, 1.0)


func _crossfade_to_vista() -> void:
	while playing and animation.current_animation_position < CUT_AT:
		await get_tree().process_frame
	if not playing:
		return
	var still := _snapshot()
	reveal.show_at(1.0)
	if still:
		var tween := create_tween()
		tween.set_speed_scale(animation.speed_scale)
		tween.tween_property(still, ^"modulate:a", 0.0, CROSSFADE)
		await tween.finished
		still.get_parent().queue_free()


## The screen as it is now, held on top of everything but the fade.
func _snapshot() -> TextureRect:
	if DisplayServer.get_name() == "headless":
		return null
	var image := get_viewport().get_texture().get_image()
	if image == null or image.is_empty():
		return null
	var layer := CanvasLayer.new()
	layer.layer = 98
	add_child(layer)
	var still := TextureRect.new()
	still.texture = ImageTexture.create_from_image(image)
	still.set_anchors_preset(Control.PRESET_FULL_RECT)
	still.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	still.stretch_mode = TextureRect.STRETCH_SCALE
	still.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(still)
	return still


func _fade_to(alpha: float, seconds: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, ^"modulate:a", alpha, seconds)
	await tween.finished
