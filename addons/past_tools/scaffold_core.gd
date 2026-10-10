extends SceneTree
## Creates the core scenes: the entry scene res://src/core/main.tscn and
## Unknown, res://content/characters/unknown/unknown.tscn, drawn from his
## rendered sprites (build those first with import_sprites.gd). Existing scenes
## are kept unless named with --replace.
##
##   tools/godot.sh --headless --script res://addons/past_tools/scaffold_core.gd [-- --replace=unknown]

const MAIN := "res://src/core/main.tscn"
const UNKNOWN := "res://content/characters/unknown/unknown.tscn"
const UNKNOWN_SPRITES := "res://content/characters/unknown/unknown_sprites.tres"

var _replace: PackedStringArray = []


func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--replace="):
			_replace = arg.get_slice("=", 1).split(",")
	var ok := _save(MAIN, _make_main, "main" in _replace)
	ok = _save(UNKNOWN, _make_unknown, "unknown" in _replace) and ok
	quit(0 if ok else 1)


func _save(path: String, make: Callable, replace: bool) -> bool:
	if FileAccess.file_exists(path) and not replace:
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
	unknown.speech_offset = Vector2(0, -520)
	unknown.depth_speed = 0.6
	unknown.step_with_frames = true
	unknown.talk_animations = [&"talk_a", &"talk_b"]
	var body := UnknownBody.new()
	body.name = "Body"
	body.sprites = load(UNKNOWN_SPRITES)
	unknown.add_child(body)
	body.owner = unknown
	return unknown
