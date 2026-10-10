class_name Exit
extends Hotspot
## A way out of the room (game-design.md §8). A click walks Unknown there and
## leaves; a double-click leaves at once. Look falls back like any hotspot
## unless the room answers `look_<id>`.

@export var target_room: StringName
## The marker in the target room where Unknown arrives.
@export var target_entry: StringName = &"default"
## Which way the exit cursor points: "left", "right", "up" or "down".
@export var direction: StringName = &"right"


func _init() -> void:
	default_verb = &"walk"


## Leaves after this verb has returned: changing rooms frees this exit, and a
## coroutine still running on it would never finish (Interaction would stay
## locked). Rooms is looked up by path so the room scaffold, which runs without
## autoloads, can still compile this class.
func on_walk() -> void:
	var rooms := get_node_or_null(^"/root/Rooms")
	if target_room != &"" and rooms:
		rooms.goto.call_deferred(target_room, target_entry, &"fade")
