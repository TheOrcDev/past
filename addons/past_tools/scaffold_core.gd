extends SceneTree
## Creates the core scenes that plan 001 needs: the entry scene
## res://src/core/main.tscn and the placeholder Unknown
## res://content/characters/unknown/unknown.tscn. Existing scenes are kept.
##
##   tools/godot.sh --headless --script res://addons/past_tools/scaffold_core.gd


func _initialize() -> void:
	var ok := _save_if_missing("res://src/core/main.tscn", _make_main)
	ok = _save_if_missing("res://content/characters/unknown/unknown.tscn", _make_unknown) and ok
	quit(0 if ok else 1)


func _save_if_missing(path: String, make: Callable) -> bool:
	if FileAccess.file_exists(path):
		print("scaffold_core: keeping %s" % path)
		return true
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	var root: Node = make.call()
	var packed := PackedScene.new()
	var err := packed.pack(root)
	if err == OK:
		err = ResourceSaver.save(packed, path)
	root.free()
	print("scaffold_core: %s %s" % [path, error_string(err)])
	return err == OK


func _make_main() -> Node:
	var main := Node.new()
	main.name = "Main"
	main.set_script(load("res://src/core/main.gd"))
	return main


func _make_unknown() -> Node:
	var unknown := Actor.new()
	unknown.name = "Unknown"
	unknown.speaker_name = "Unknown"
	unknown.subtitle_color = Color(0.86, 0.89, 0.96)
	unknown.speech_offset = Vector2(0, -450)
	var body := PlaceholderBody.new()
	body.name = "Body"
	unknown.add_child(body)
	body.owner = unknown
	return unknown
