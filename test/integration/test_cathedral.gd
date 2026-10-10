extends GutTest
## The cathedral nave built from its room spec: both eras, era switching of
## layers, walk areas and occluders, and occluder baselines below the walk area.


func before_each() -> void:
	await Rooms.goto(&"cathedral_nave", &"default", &"none")


func after_each() -> void:
	Rooms.clear()


func _occluders(era: String) -> Array[Node]:
	return Rooms.current.actors.get_children().filter(func(node: Node) -> bool: return node.is_in_group(StringName("era_%s" % era)))


func test_starts_in_the_present() -> void:
	var room := Rooms.current
	assert_eq(room.era, &"now")
	assert_true(room.get_node("Layers/Now").visible)
	assert_false(room.get_node("Layers/Then").visible)
	assert_true((room.get_node("WalkAreas/Now") as NavigationRegion2D).enabled)
	assert_false((room.get_node("WalkAreas/Then") as NavigationRegion2D).enabled)
	assert_eq(_occluders("now").size(), 2)
	for node in _occluders("now"):
		assert_true(node.visible, "%s visible now" % node.name)
	for node in _occluders("then"):
		assert_false(node.visible, "%s hidden now" % node.name)


func test_switching_to_the_past_swaps_everything() -> void:
	var room := Rooms.current
	room.set_era(&"then")
	assert_false(room.get_node("Layers/Now").visible)
	assert_true(room.get_node("Layers/Then").visible)
	assert_false((room.get_node("WalkAreas/Now") as NavigationRegion2D).enabled)
	assert_true((room.get_node("WalkAreas/Then") as NavigationRegion2D).enabled)
	for node in _occluders("then"):
		assert_true(node.visible, "%s visible then" % node.name)
	for node in _occluders("now"):
		assert_false(node.visible, "%s hidden then" % node.name)
	assert_true(room.get_node("Foreground/GroundMist").visible == false, "present-day ground mist hides in the past")


func test_occluders_sort_in_front_of_anyone_on_the_floor() -> void:
	var lowest_floor_y := 0.0
	var walk := (Rooms.current.get_node("WalkAreas/Now") as NavigationRegion2D).navigation_polygon
	for point in walk.get_outline(0):
		lowest_floor_y = maxf(lowest_floor_y, point.y)
	for node in _occluders("now") + _occluders("then"):
		assert_gt((node as Node2D).position.y, lowest_floor_y, "%s baseline below the floor" % node.name)


func test_the_statue_is_the_memory_anchor() -> void:
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	assert_eq(statue.default_verb, &"use")
	assert_true(Rooms.current.has_method("use_statue"))
