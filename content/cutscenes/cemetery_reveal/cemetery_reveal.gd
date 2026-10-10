extends Node2D
## The prologue's opening (plan 002, slice 6). The shot opens close on Unknown on
## the cemetery path, then the camera pulls back across the zoom stack to the
## whole vista and the title card shows. It ends on black, ready for the first
## room. A click fast-forwards it, so a skipped opening ends the same way.

signal finished

const FADE_IN := 1.5
const FADE_OUT := 1.0
const SKIP_SPEED := 12.0

@onready var reveal: Reveal = $Reveal
@onready var unknown: UnknownBody = $Reveal/Unknown
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var title: Control = $Title/Card

var letterbox: Letterbox
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


## Plays the whole opening and returns on black.
func play() -> void:
	playing = true
	reveal.camera.make_current()
	letterbox.show_bars(0.0)
	_fade_to(0.0, FADE_IN)
	animation.play(&"reveal")
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


func _unhandled_input(event: InputEvent) -> void:
	if playing and event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
		skip()


func _fade_to(alpha: float, seconds: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, ^"modulate:a", alpha, seconds)
	await tween.finished
