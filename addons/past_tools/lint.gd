extends SceneTree
## Content lint (docs/technical-plan.md §9). Checks every room scene and every
## dialogue file, prints the problems and exits non-zero if there are any.
##
##   tools/godot.sh --headless --script res://addons/past_tools/lint.gd

const ROOMS_DIR := "res://content/rooms"
const DIALOGUE_DIR := "res://content/dialogue"
## Lines that start with these are structure, not speech.
const STRUCTURE := ["~ ", "=>", "do ", "do! ", "set ", "$>", "if ", "elif ", "else", "while ", "match ", "when ", "- ", "#", "import ", "using "]

var _problems: PackedStringArray = []


func _initialize() -> void:
	_lint_rooms()
	_lint_dialogue(DIALOGUE_DIR)
	for problem in _problems:
		printerr("[lint] %s" % problem)
	print("[lint] %s: %d problem(s)" % ["FAIL" if _problems.size() > 0 else "PASS", _problems.size()])
	quit(1 if _problems.size() > 0 else 0)


func _lint_rooms() -> void:
	for room_id in DirAccess.get_directories_at(ROOMS_DIR):
		var path := "%s/%s/%s.tscn" % [ROOMS_DIR, room_id, room_id]
		var scene := load(path) as PackedScene
		if scene == null:
			_problems.append("%s: room scene missing" % path)
			continue
		var room := scene.instantiate()
		if not room is Room:
			_problems.append("%s: root is not a Room" % path)
		else:
			var walk := room.get_node_or_null("WalkAreas/Now") as NavigationRegion2D
			if walk == null or walk.navigation_polygon == null or walk.navigation_polygon.get_polygon_count() == 0:
				_problems.append("%s: no baked walk area at WalkAreas/Now" % room_id)
			if room.get_node_or_null("Markers/default") == null:
				_problems.append("%s: no entry marker at Markers/default" % room_id)
			for node in room.get_node("Hotspots").get_children():
				var hotspot := node as Hotspot
				if hotspot and (hotspot.id == &"" or hotspot.display_name.is_empty()):
					_problems.append("%s/%s: a hotspot needs an id and a display name" % [room_id, node.name])
		room.free()


## Every spoken line, with or without a speaker, needs a static [ID:…]; the ID
## names its voice file (docs/decisions.md #21).
func _lint_dialogue(dir: String) -> void:
	for sub in DirAccess.get_directories_at(dir):
		_lint_dialogue(dir.path_join(sub))
	for file in DirAccess.get_files_at(dir):
		if not file.ends_with(".dialogue"):
			continue
		var path := dir.path_join(file)
		var lines := FileAccess.get_file_as_string(path).split("\n")
		for i in lines.size():
			var text := _without_random_prefix(lines[i].strip_edges())
			if text.is_empty() or _is_structure(text):
				continue
			if not "[ID:" in text:
				_problems.append("%s:%d: spoken line has no [ID:…]" % [path, i + 1])


func _is_structure(text: String) -> bool:
	for prefix: String in STRUCTURE:
		if text.begins_with(prefix):
			return true
	return false


## Weighted random siblings start with "%", optionally a weight and a condition.
func _without_random_prefix(text: String) -> String:
	if not text.begins_with("%"):
		return text
	var regex := RegEx.create_from_string("^%[\\d.]*( \\[if .+? /\\])? ")
	var found := regex.search(text)
	return text.substr(found.get_end()) if found else text
