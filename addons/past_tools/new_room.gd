extends SceneTree
## Creates a room's folder, script and scene with the standard structure in
## docs/technical-plan.md §5.1, saved through Godot so resource IDs stay valid.
##
##   tools/godot.sh --headless --script res://addons/past_tools/new_room.gd -- <room_id> [spec.json]
##
## The optional JSON spec sets the first background, the walk-area outline,
## scale zones, markers and hotspots; see art-source/work/rooms/sandbox/room_spec.json.
## Import new art first (tools/godot.sh --headless --import). After creation the
## .tscn is the source of truth: edit it in the editor or with another script.

var _root: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		printerr("usage: new_room.gd -- <room_id> [spec.json]")
		quit(2)
		return
	var spec := {}
	if args.size() > 1:
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(args[1]))
		if not parsed is Dictionary:
			printerr("Could not read spec %s" % args[1])
			quit(2)
			return
		spec = parsed
	quit(0 if create_room(args[0], spec) == OK else 1)


func create_room(room_id: String, spec: Dictionary) -> Error:
	var dir := "res://content/rooms/%s" % room_id
	var scene_path := dir.path_join("%s.tscn" % room_id)
	var script_path := dir.path_join("%s.gd" % room_id)
	if FileAccess.file_exists(scene_path):
		printerr("%s already exists" % scene_path)
		return ERR_ALREADY_EXISTS
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	if not FileAccess.file_exists(script_path):
		var file := FileAccess.open(script_path, FileAccess.WRITE)
		file.store_string("extends Room\n## %s. Hotspot verbs are methods named <verb>_<hotspot_id>.\n" % spec.get("display_name", room_id))
		file.close()

	_root = Node2D.new()
	_root.name = room_id.to_pascal_case()
	_root.set_script(ResourceLoader.load(script_path, "", ResourceLoader.CACHE_MODE_IGNORE))
	_root.set(&"room_id", StringName(room_id))
	_root.set(&"display_name", spec.get("display_name", ""))

	var layers := _add(_root, Node2D.new(), "Layers")
	var layers_now := _add(layers, Node2D.new(), "Now")
	_add(layers, Node2D.new(), "Then")
	var walk_areas := _add(_root, Node2D.new(), "WalkAreas")
	var walk_now := _add(walk_areas, NavigationRegion2D.new(), "Now") as NavigationRegion2D
	var walk_then := _add(walk_areas, NavigationRegion2D.new(), "Then") as NavigationRegion2D
	walk_then.enabled = false
	var zones := _add(_root, ScaleZones.new(), "ScaleZones") as ScaleZones
	var hotspots := _add(_root, Node2D.new(), "Hotspots")
	_add(_root, Node2D.new(), "Exits")
	var markers := _add(_root, Node2D.new(), "Markers")
	var actors := _add(_root, Node2D.new(), "Actors")
	actors.y_sort_enabled = true
	_add(_root, Node2D.new(), "Foreground")
	_add(_root, Node2D.new(), "Cinematics")

	var err := OK
	if spec.has("background"):
		var sprite := _add(layers_now, Sprite2D.new(), "Background") as Sprite2D
		sprite.centered = false
		sprite.texture = load(spec["background"])
		if sprite.texture == null:
			printerr("Background is missing or not imported: %s" % spec["background"])
			err = ERR_FILE_NOT_FOUND

	var walk: Array = spec.get("walk_now", [])
	if err == OK and not walk.is_empty():
		err = _bake_walk_area(walk_now, _points(walk))

	var zone_spec: Dictionary = spec.get("scale_zones", {})
	for key: String in ["far_y", "far_scale", "near_y", "near_scale"]:
		if zone_spec.has(key):
			zones.set(key, float(zone_spec[key]))

	var marker_spec: Dictionary = spec.get("markers", {"default": [960, 1000]})
	for marker_name: String in marker_spec:
		var marker := _add(markers, Marker2D.new(), marker_name) as Marker2D
		marker.position = _point(marker_spec[marker_name])

	for hotspot_spec: Dictionary in spec.get("hotspots", []):
		var hotspot := _add(hotspots, Hotspot.new(), String(hotspot_spec["id"]).to_pascal_case()) as Hotspot
		hotspot.id = StringName(hotspot_spec["id"])
		hotspot.display_name = hotspot_spec.get("name", hotspot_spec["id"])
		hotspot.default_verb = StringName(hotspot_spec.get("default_verb", "look"))
		hotspot.walk_offset = _point(hotspot_spec["walk_to"])
		var shape := _add(hotspot, CollisionPolygon2D.new(), "Shape") as CollisionPolygon2D
		shape.polygon = _points(hotspot_spec["polygon"])

	if err == OK:
		var packed := PackedScene.new()
		err = packed.pack(_root)
		if err == OK:
			err = ResourceSaver.save(packed, scene_path)
	print("new_room %s: %s" % [scene_path, error_string(err)])
	_root.free()
	return err


func _add(parent: Node, node: Node, node_name: String) -> Node:
	node.name = node_name
	parent.add_child(node)
	node.owner = _root
	return node


## Bakes the outline into the region's navigation polygon. The outline is also
## kept on the polygon, so the editor can re-bake after edits.
func _bake_walk_area(region: NavigationRegion2D, outline: PackedVector2Array) -> Error:
	var polygon := NavigationPolygon.new()
	polygon.agent_radius = 0.0
	polygon.add_outline(outline)
	var source := NavigationMeshSourceGeometryData2D.new()
	source.add_traversable_outline(outline)
	NavigationServer2D.bake_from_source_geometry_data(polygon, source)
	if polygon.get_polygon_count() == 0:
		printerr("The walk area did not bake; check the outline %s" % outline)
		return ERR_INVALID_DATA
	region.navigation_polygon = polygon
	return OK


func _point(pair: Array) -> Vector2:
	return Vector2(float(pair[0]), float(pair[1]))


func _points(pairs: Array) -> PackedVector2Array:
	var points := PackedVector2Array()
	for pair: Array in pairs:
		points.append(_point(pair))
	return points
