extends Node
## Entry point: starts the game in `start_room` (the sandbox until the
## prologue exists).

@export var start_room: StringName = &"sandbox"
@export var start_entry: StringName = &"default"


func _ready() -> void:
	Rooms.goto.call_deferred(start_room, start_entry, &"fade")
