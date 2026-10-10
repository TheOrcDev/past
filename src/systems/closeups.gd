extends Node
## Opens and closes close-up views (plan 007). Opening pushes in: the room's
## camera moves towards the hotspot while the close-up, first framed over the
## hotspot, grows to fill the screen. Closing is the same move reversed. While a
## close-up is open, Interaction sends clicks to its hotspots; a right-click,
## Esc or the back glyph closes it.

signal opened(closeup: Closeup)
signal closed(closeup_id: StringName)

const PATH := "res://content/closeups/%s/%s.tscn"
const SECONDS := 0.9
## How far the room's camera pushes in as the close-up takes over.
const PUSH := 1.7

var current: Closeup
var busy := false

var _layer: CanvasLayer
var _back: Label
var _from_rect := Rect2()
var _camera: Camera2D


func _ready() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 30
	add_child(_layer)
	_back = Label.new()
	_back.name = "Back"
	_back.text = "‹"
	_back.add_theme_font_size_override(&"font_size", 72)
	_back.add_theme_color_override(&"font_outline_color", Color.BLACK)
	_back.add_theme_constant_override(&"outline_size", 12)
	_back.position = Vector2(34, 10)
	_back.mouse_filter = Control.MOUSE_FILTER_STOP
	_back.visible = false
	_back.gui_input.connect(func(event: InputEvent) -> void:
		var click := event as InputEventMouseButton
		if click and click.pressed and click.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			close())
	_layer.add_child(_back)


## Opens the close-up `id` from `from` (the hotspot clicked, for the push-in).
func open(id: StringName, from: Hotspot = null) -> void:
	var scene := load(PATH % [id, id]) as PackedScene
	if scene == null:
		push_error("Close-up not found: %s" % id)
		return
	await open_node(scene.instantiate() as Closeup, from)


## Opens an already built close-up (tests and generated views).
func open_node(closeup: Closeup, from: Hotspot = null) -> void:
	if current or busy:
		closeup.free()
		return
	busy = true
	Interaction.locked += 1
	var view := get_viewport().get_visible_rect().size
	_from_rect = _screen_rect(from) if from else Rect2(view / 2.0 - view / 8.0, view / 4.0)
	_layer.add_child(closeup)
	current = closeup
	_place(closeup, _from_rect, view, 0.0)
	_camera = _push_camera(from)
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(func(t: float) -> void: _place(closeup, _from_rect, view, t), 0.0, 1.0, SECONDS)
	await tween.finished
	_back.visible = true
	Interaction.locked -= 1
	busy = false
	opened.emit(closeup)


func close() -> void:
	if current == null or busy:
		return
	busy = true
	Interaction.locked += 1
	_back.visible = false
	var closeup := current
	var view := get_viewport().get_visible_rect().size
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(func(t: float) -> void: _place(closeup, _from_rect, view, t), 1.0, 0.0, SECONDS)
	if _camera:
		tween.parallel().tween_property(_camera, ^"zoom", Vector2.ONE, SECONDS)
		tween.parallel().tween_property(_camera, ^"position", view / 2.0, SECONDS)
	await tween.finished
	if is_instance_valid(_camera):
		_camera.queue_free()
	_camera = null
	var id := closeup.closeup_id
	current = null
	closeup.queue_free()
	Interaction.locked -= 1
	busy = false
	closed.emit(id)


func _unhandled_input(event: InputEvent) -> void:
	if current == null or busy:
		return
	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


## Frames the close-up between the hotspot's rect (t = 0, transparent) and the
## whole screen (t = 1, opaque).
func _place(closeup: Closeup, from: Rect2, view: Vector2, t: float) -> void:
	var size := from.size.lerp(view, t)
	closeup.scale = Vector2(size.x / view.x, size.y / view.y)
	closeup.position = from.position.lerp(Vector2.ZERO, t)
	closeup.modulate.a = clampf(t * 1.6, 0.0, 1.0)


## The room's camera eases towards the hotspot while the close-up opens.
func _push_camera(from: Hotspot) -> Camera2D:
	var room := Rooms.current
	if room == null:
		return null
	var view := get_viewport().get_visible_rect().size
	var camera := Camera2D.new()
	camera.position = view / 2.0
	room.add_child(camera)
	camera.make_current()
	var target := from.focus_point() if from else view / 2.0
	var tween := camera.create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, ^"zoom", Vector2.ONE * PUSH, SECONDS)
	tween.tween_property(camera, ^"position", target, SECONDS)
	return camera


## Where the close-up starts: a screen rectangle with the screen's shape that
## covers the hotspot's outline, so the image grows out of the thing clicked.
func _screen_rect(hotspot: Hotspot) -> Rect2:
	var canvas := hotspot.get_viewport().get_canvas_transform()
	var rect := Rect2(canvas * hotspot.focus_point(), Vector2.ZERO)
	for child in hotspot.get_children():
		var shape := child as CollisionPolygon2D
		if shape:
			for point in shape.polygon:
				rect = rect.expand(canvas * shape.to_global(point))
	var view := get_viewport().get_visible_rect().size
	var aspect := view.x / view.y
	var width := maxf(maxf(rect.size.x, rect.size.y * aspect), 160.0)
	var size := Vector2(width, width / aspect)
	return Rect2(rect.get_center() - size / 2.0, size)
