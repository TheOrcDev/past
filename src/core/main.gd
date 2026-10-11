extends Node
## Entry point: plays the opening cutscene, then starts the game in
## `start_room`: Unknown's grave (plan 007).

## A Cutscene script, played before the first room, that ends on black; empty
## for none.
@export_file("*.gd") var opening := "res://content/cutscenes/cemetery_reveal/opening.gd"
@export var start_room: StringName = &"cemetery_grave"
@export var start_entry: StringName = &"default"


func _ready() -> void:
	_start.call_deferred()


func _start() -> void:
	if not opening.is_empty() and not Qa.skips_opening():
		await Cutscenes.play((load(opening) as GDScript).new() as Cutscene)
	Saves.autosave = true
	Rooms.goto(start_room, start_entry, &"fade")
	# The room's own fade now covers the screen, so the opening's black can go.
	Cutscenes.clear_fade()
