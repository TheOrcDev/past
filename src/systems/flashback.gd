extends Node
## Flashbacks and the era grade (docs/technical-plan.md §6.1–6.2).
## A vision blooms the room's past out from an anchor point: the then
## background dissolves in over the now one, each era's effects and occluders
## crossfade, the grade turns warm, then the camera drifts while something
## plays, and finally the past drains back into the anchor.

signal vision_started(origin: Vector2)
signal vision_finished(origin: Vector2)

const DISSOLVE := preload("res://src/shaders/memory_dissolve.gdshader")
const GRADE := preload("res://src/shaders/era_grade.gdshader")

## Softens the flare at the start of a vision (an accessibility setting).
var reduce_flashing := false
var transition_seconds := 3.2
var playing := false

var _grade_material: ShaderMaterial
var _flare: Sprite2D


func _ready() -> void:
	var grade_layer := CanvasLayer.new()
	grade_layer.layer = 10
	add_child(grade_layer)
	var grade := ColorRect.new()
	grade.set_anchors_preset(Control.PRESET_FULL_RECT)
	grade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grade_material = ShaderMaterial.new()
	_grade_material.shader = GRADE
	_grade_material.set_shader_parameter(&"noise_tex", Effects.noise_texture(17, 0.9))
	grade.material = _grade_material
	grade_layer.add_child(grade)

	var flare_layer := CanvasLayer.new()
	flare_layer.layer = 11
	add_child(flare_layer)
	_flare = Sprite2D.new()
	_flare.texture = Effects.soft_dot()
	var additive := CanvasItemMaterial.new()
	additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	_flare.material = additive
	_flare.modulate = Color(1.0, 0.95, 0.85, 0.0)
	flare_layer.add_child(_flare)

	Rooms.room_changed.connect(func(room: Room) -> void: set_grade(1.0 if room.era == &"then" else 0.0))
	Rooms.while_black.append(warm_up)
	# Noise textures generate on first use; start the dissolve's now so the first vision has it.
	Effects.noise_texture(23, 0.02)


func _process(_delta: float) -> void:
	_grade_material.set_shader_parameter(&"grain_offset", Vector2(randf(), randf()))


## 0 is the present's grade, 1 the past's.
func set_grade(value: float) -> void:
	_grade_material.set_shader_parameter(&"mix_then", value)


## Film grain strength; 0 turns it off. The default is 0.04.
func set_grain(amount: float) -> void:
	_grade_material.set_shader_parameter(&"grain", amount)


## Draws the room's past once, unseen, so its shaders are compiled before the
## first vision. Browsers compile on first draw, which stalled a vision 141 ms.
func warm_up(room: Node) -> void:
	var then_layer := (room as Room).layers.get_node_or_null("Then") as CanvasItem
	if then_layer == null:
		return
	var shown: Array[CanvasItem] = [then_layer]
	for node in (room as Room).era_nodes():
		if node.is_in_group(&"era_then"):
			shown.append(node)
	var was_visible: Array[bool] = []
	for node in shown:
		was_visible.append(node.visible)
		node.visible = true
	var background := then_layer.get_node_or_null("Background") as Sprite2D
	if background:
		var dissolve := ShaderMaterial.new()
		dissolve.shader = DISSOLVE
		dissolve.set_shader_parameter(&"noise_tex", Effects.noise_texture(23, 0.02))
		dissolve.set_shader_parameter(&"progress", 0.5)
		background.material = dissolve
	# Visible through two whole frames, so both get drawn (headless runs draw nothing
	# and never post a draw, so this waits on process frames instead).
	await get_tree().process_frame
	await get_tree().process_frame
	if not is_instance_valid(room):
		return  # cleared while warming up
	if background:
		background.material = null
	for i in shown.size():
		shown[i].visible = was_visible[i]


## Plays a cinematic flashback in `room`, blooming from `origin` (room pixels).
## `during` is awaited while the past is shown; without it the past holds for
## `hold_seconds`.
func vision(room: Room, origin: Vector2, during := Callable(), hold_seconds := 6.0) -> void:
	playing = true
	Interaction.locked += 1
	_unknown_reacts(true)
	vision_started.emit(origin)
	await _transition(room, origin, true)
	room.set_era(&"then")
	var camera := _start_drift(room, origin)
	if during.is_valid():
		await during.call()
	else:
		await get_tree().create_timer(hold_seconds).timeout
	await _end_drift(camera)
	_unknown_reacts(false)
	await _transition(room, origin, false)
	room.set_era(&"now")
	Interaction.locked -= 1
	playing = false
	vision_finished.emit(origin)


## Unknown's eyes flare as a vision opens and as it closes; as it opens, the
## memory also takes his body (the flare one-shot, if he has it).
func _unknown_reacts(into_past: bool) -> void:
	var player := Rooms.player
	if player == null:
		return
	var body := player.get_node_or_null("Body")
	if body and body.has_method(&"flare"):
		body.flare(1.6 if into_past else 1.0)
	if into_past:
		player.play(&"flare")


func _transition(room: Room, origin: Vector2, into_past: bool) -> void:
	var now_layer := room.layers.get_node("Now") as CanvasItem
	var then_layer := room.layers.get_node("Then") as CanvasItem
	var then_background := then_layer.get_node("Background") as Sprite2D
	now_layer.visible = true
	then_layer.visible = true

	var dissolve := ShaderMaterial.new()
	dissolve.shader = DISSOLVE
	dissolve.set_shader_parameter(&"noise_tex", Effects.noise_texture(23, 0.02))
	dissolve.set_shader_parameter(&"origin", origin / then_background.texture.get_size())
	then_background.material = dissolve

	var now_nodes := _crossfading(room, now_layer, &"era_now")
	var then_nodes := _crossfading(room, then_layer, &"era_then")
	var fading_in := then_nodes if into_past else now_nodes
	var fading_out := now_nodes if into_past else then_nodes
	var start := 0.0 if into_past else 1.0
	var end := 1.0 - start
	dissolve.set_shader_parameter(&"progress", start)
	for node in fading_in + fading_out:
		node.visible = true
	for node in fading_in:
		node.modulate.a = 0.0
	if into_past:
		_flash(room, origin)

	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(func(value: float) -> void: dissolve.set_shader_parameter(&"progress", value), start, end, transition_seconds)
	tween.tween_method(set_grade, start, end, transition_seconds)
	for node in fading_in:
		tween.tween_property(node, "modulate:a", 1.0, transition_seconds)
	for node in fading_out:
		tween.tween_property(node, "modulate:a", 0.0, transition_seconds)
	await tween.finished

	then_background.material = null
	for node in fading_in + fading_out:
		node.modulate.a = 1.0


## An era's effects (everything in its layer but the background) plus its era-tagged nodes.
func _crossfading(room: Room, layer: Node, group: StringName) -> Array[CanvasItem]:
	var nodes: Array[CanvasItem] = []
	for child in layer.get_children():
		if child is CanvasItem and child.name != &"Background":
			nodes.append(child)
	for node in room.era_nodes():
		if node.is_in_group(group):
			nodes.append(node)
	return nodes


func _flash(room: Room, origin: Vector2) -> void:
	_flare.position = room.get_global_transform_with_canvas() * origin
	_flare.scale = Vector2.ONE * 4.0
	var peak := 0.35 if reduce_flashing else 0.9
	var tween := create_tween().set_parallel(true)
	tween.tween_property(_flare, "scale", Vector2.ONE * 60.0, 1.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_flare, "modulate:a", peak, 0.25)
	tween.chain().tween_property(_flare, "modulate:a", 0.0, 0.85)


func _start_drift(room: Room, origin: Vector2) -> Camera2D:
	var camera := Camera2D.new()
	camera.position = Vector2(960, 540)
	room.add_child(camera)
	camera.make_current()
	var toward := Vector2(960, 540).lerp(origin, 0.08)
	var tween := camera.create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2.ONE * 1.05, 10.0)
	tween.tween_property(camera, "position", toward, 10.0)
	camera.set_meta(&"drift", tween)
	return camera


func _end_drift(camera: Camera2D) -> void:
	(camera.get_meta(&"drift") as Tween).kill()
	var tween := camera.create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2.ONE, 1.0)
	tween.tween_property(camera, "position", Vector2(960, 540), 1.0)
	await tween.finished
	camera.queue_free()
