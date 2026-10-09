class_name Actor
extends Node2D
## A character that walks the room's navigation mesh, faces where it goes,
## scales with depth and plays `<anim>_<dir>` animations on its ActorBody
## child. The origin is at the feet.

signal _walk_done(walk_id: int, completed: bool)

## The name this actor speaks under in .dialogue files, for example "Unknown".
@export var speaker_name := ""
## Pixels per second at scale 1. Farther away (smaller) is slower on screen.
@export var walk_speed := 320.0
@export var diagonals := false
@export var subtitle_color := Color(0.92, 0.92, 0.92)
## Where subtitles sit, relative to the feet, at scale 1.
@export var speech_offset := Vector2(0, -440)

var facing: AnimNames.Dir = AnimNames.Dir.D
var is_walking: bool:
	get:
		return not _path.is_empty()

var _body: ActorBody
var _base_anim: StringName = &"idle"
var _path := PackedVector2Array()
var _walk_id := 0


func _ready() -> void:
	for child in get_children():
		if child is ActorBody:
			_body = child
			break
	_apply_animation()


## Walks to the reachable point nearest `target`. Returns true on arrival and
## false if another walk or stop() interrupted it.
func walk_to(target: Vector2) -> bool:
	_interrupt()
	_walk_id += 1
	var my_id := _walk_id
	await _navigation_ready()
	var map := get_world_2d().navigation_map
	var destination := NavigationServer2D.map_get_closest_point(map, target)
	_path = NavigationServer2D.map_get_path(map, global_position, destination, true)
	while not _path.is_empty() and _path[0].distance_to(global_position) < 1.0:
		_path.remove_at(0)
	if _path.is_empty():
		return my_id == _walk_id
	_set_base_animation(&"walk")
	var completed := false
	while true:
		var result: Array = await _walk_done
		if result[0] == my_id:
			completed = result[1]
			break
	return completed


func stop() -> void:
	_interrupt()
	_set_base_animation(&"idle")


func face(dir: AnimNames.Dir) -> void:
	if dir != facing:
		facing = dir
		_apply_animation()


func face_point(point: Vector2) -> void:
	face(AnimNames.dir_from_vector(point - global_position, diagonals))


## Plays a one-shot animation such as `pickup_low` and waits for it. Never use
## it for looping animations; they do not finish.
func play(base: StringName) -> void:
	if _body == null:
		return
	var choice := AnimNames.resolve(base, facing, _body.has_animation)
	if choice.is_empty():
		push_warning("%s has no animation %s" % [name, base])
		return
	_body.play_animation(choice.name, choice.flip)
	await _body.animation_finished
	_apply_animation()


## Where this actor's subtitles sit, in world coordinates.
func speech_position() -> Vector2:
	return to_global(speech_offset)


func _process(_delta: float) -> void:
	var room := Room.of(self)
	var s := room.scale_at(global_position.y) if room else 1.0
	scale = Vector2(s, s)


func _physics_process(delta: float) -> void:
	if _path.is_empty():
		return
	var step := walk_speed * scale.y * delta
	while step > 0.0 and not _path.is_empty():
		var to_next := _path[0] - global_position
		var distance := to_next.length()
		if distance > 0.5:
			face(AnimNames.dir_from_vector(to_next, diagonals))
		if distance <= step:
			global_position = _path[0]
			_path.remove_at(0)
			step -= distance
		else:
			global_position += to_next / distance * step
			step = 0.0
	if _path.is_empty():
		_set_base_animation(&"idle")
		_walk_done.emit(_walk_id, true)


func _interrupt() -> void:
	if not _path.is_empty():
		_path.clear()
		_walk_done.emit(_walk_id, false)


## The navigation map syncs on physics frames; a freshly loaded room needs one.
func _navigation_ready() -> void:
	var map := get_world_2d().navigation_map
	for i in 10:
		if NavigationServer2D.map_get_iteration_id(map) > 0:
			return
		await get_tree().physics_frame


func _set_base_animation(base: StringName) -> void:
	if base != _base_anim:
		_base_anim = base
		_apply_animation()


func _apply_animation() -> void:
	if _body == null:
		return
	var choice := AnimNames.resolve(_base_anim, facing, _body.has_animation)
	if choice.is_empty():
		choice = AnimNames.resolve(&"idle", facing, _body.has_animation)
	if not choice.is_empty():
		_body.play_animation(choice.name, choice.flip)
