extends Node
## Mouse input for play: hover labels, walking and running hotspot verbs
## (docs/game-design.md §8). The verb coin and inventory arrive in plan 004;
## for now a click on a hotspot runs its default verb.

signal interacted(hotspot: Hotspot, verb: StringName)

## Above zero, play input is ignored (transitions, dialogue, cutscenes).
var locked := 0
var hovered: Hotspot

var _label: Label


func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 50
	add_child(layer)
	_label = Label.new()
	_label.add_theme_font_size_override(&"font_size", 30)
	_label.add_theme_color_override(&"font_color", Color(0.95, 0.95, 0.95))
	_label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	_label.add_theme_constant_override(&"outline_size", 10)
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.visible = false
	layer.add_child(_label)


func _unhandled_input(event: InputEvent) -> void:
	var mouse := event as InputEventMouse
	if mouse == null or Rooms.current == null:
		return
	var world := get_viewport().get_canvas_transform().affine_inverse() * mouse.position
	if event is InputEventMouseMotion:
		_set_hovered(hotspot_at(world), mouse.position)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if locked == 0:
			get_viewport().set_input_as_handled()
			click_at(world)


## A left click at a world position: use the hotspot there, or walk.
func click_at(world: Vector2) -> void:
	if locked > 0 or Rooms.current == null or Rooms.player == null:
		return
	var hotspot := hotspot_at(world)
	if hotspot:
		await use(hotspot, hotspot.default_verb)
	else:
		Rooms.player.walk_to(world)


## Walks the player to the hotspot, faces it and runs the verb, or a fallback line.
func use(hotspot: Hotspot, verb: StringName) -> void:
	var player := Rooms.player
	var arrived: bool = await player.walk_to(hotspot.walk_point())
	if not arrived:
		return
	player.face_point(hotspot.focus_point())
	locked += 1
	_label.visible = false
	var handled: bool = await hotspot.handle(verb)
	if not handled:
		await Say.fallback(verb)
	locked -= 1
	interacted.emit(hotspot, verb)


func hotspot_at(world: Vector2) -> Hotspot:
	if Rooms.current == null:
		return null
	var best: Hotspot = null
	for node in Rooms.current.hotspots.get_children():
		var hotspot := node as Hotspot
		if hotspot and hotspot.is_active() and hotspot.contains_point(world):
			if best == null or hotspot.pick_priority > best.pick_priority:
				best = hotspot
	return best


func _set_hovered(hotspot: Hotspot, screen: Vector2) -> void:
	hovered = hotspot
	_label.visible = hotspot != null and locked == 0
	if not _label.visible:
		return
	_label.text = hotspot.display_name
	_label.reset_size()
	var view := get_viewport().get_visible_rect().size
	_label.position = Vector2(
		clampf(screen.x - _label.size.x / 2.0, 10.0, view.x - _label.size.x - 10.0),
		clampf(screen.y - _label.size.y - 40.0, 10.0, view.y - _label.size.y - 10.0))
