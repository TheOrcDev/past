extends Node
## Entry point: plays the opening cutscene, then starts the game in
## `start_room`: Unknown's grave (plan 007).

## A cutscene scene with play() that returns on black; empty for none.
@export_file("*.tscn") var opening := "res://content/cutscenes/cemetery_reveal/cemetery_reveal.tscn"
@export var start_room: StringName = &"cemetery_grave"
@export var start_entry: StringName = &"default"


func _ready() -> void:
	_start.call_deferred()


func _start() -> void:
	if not opening.is_empty() and not Qa.skips_opening():
		var cutscene: Node = (load(opening) as PackedScene).instantiate()
		add_child(cutscene)
		await cutscene.play()
		cutscene.queue_free()
	Saves.autosave = true
	Rooms.goto(start_room, start_entry, &"fade")
