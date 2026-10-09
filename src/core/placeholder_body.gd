class_name PlaceholderBody
extends ActorBody
## A drawn stand-in for Unknown until the rendered sprites exist (plan 002):
## a black silhouette with two eye dots that breathes when idle and bobs when
## walking. The origin is at the feet.

const ANIMATIONS: Array[StringName] = [&"idle_r", &"idle_u", &"idle_d", &"walk_r", &"walk_u", &"walk_d"]

@export var height := 400.0

var _anim: StringName = &"idle_d"
var _time := 0.0


func has_animation(anim: StringName) -> bool:
	return anim in ANIMATIONS


func play_animation(anim: StringName, flip: bool) -> void:
	_anim = anim
	scale.x = -1.0 if flip else 1.0
	queue_redraw()


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var walking := String(_anim).begins_with("walk")
	var bob := -absf(sin(_time * 8.0)) * 8.0 if walking else sin(_time * 2.0) * 2.0
	var h := height
	var w := h * 0.22
	var body := PackedVector2Array([
		Vector2(-w * 0.35, 0.0), Vector2(w * 0.35, 0.0),
		Vector2(w * 0.5, -h * 0.72 + bob), Vector2(w * 0.32, -h * 0.8 + bob),
		Vector2(-w * 0.32, -h * 0.8 + bob), Vector2(-w * 0.5, -h * 0.72 + bob),
	])
	draw_colored_polygon(body, Color.BLACK)
	var head := Vector2(0.0, -h * 0.88 + bob)
	draw_circle(head, h * 0.075, Color.BLACK)
	var eye_y := head.y - h * 0.005
	var eye_r := h * 0.011
	match String(_anim).get_slice("_", 1):
		"d":
			draw_circle(Vector2(-h * 0.025, eye_y), eye_r, Color.WHITE)
			draw_circle(Vector2(h * 0.025, eye_y), eye_r, Color.WHITE)
		"r":
			draw_circle(Vector2(h * 0.03, eye_y), eye_r, Color.WHITE)
			draw_circle(Vector2(h * 0.06, eye_y), eye_r * 0.8, Color.WHITE)
