extends GutTest
## The plan 001 walking skeleton end to end in the sandbox room: walking with
## depth scaling, hotspot verbs answered by Dialogue Manager lines, fallback
## lines, the input lock and a real mouse event.

var _lines: Array[String] = []
var _auto_skip := true


func before_all() -> void:
	Engine.time_scale = 4.0


func after_all() -> void:
	Engine.time_scale = 1.0


func before_each() -> void:
	_lines.clear()
	_auto_skip = true
	Say.line_started.connect(_on_line_started)
	await Rooms.goto(&"sandbox", &"default", &"none")


func after_each() -> void:
	Say.line_started.disconnect(_on_line_started)
	while Say.speaking:
		Say.skip()
		await wait_process_frames(1)
	assert_eq(Interaction.locked, 0, "the input lock is balanced")
	Rooms.clear()


func _on_line_started(static_id: String, _speaker: String, _text: String) -> void:
	_lines.append(static_id)
	if _auto_skip:
		Say.skip.call_deferred()


func test_starts_at_the_entry_marker() -> void:
	assert_eq(Rooms.current.room_id, &"sandbox")
	assert_almost_eq(Rooms.player.global_position.distance_to(Vector2(760, 1010)), 0.0, 0.5)


func test_click_on_the_floor_walks_there() -> void:
	var target := Vector2(1500, 1000)
	Interaction.click_at(target)
	await wait_until(func() -> bool: return Rooms.player.global_position.distance_to(target) < 2.0 and not Rooms.player.is_walking, 10.0)
	assert_almost_eq(Rooms.player.global_position.distance_to(target), 0.0, 2.0)


func test_click_above_the_floor_walks_to_the_nearest_floor_point() -> void:
	Interaction.click_at(Vector2(960, 500))
	await wait_until(func() -> bool: return Rooms.player.global_position.y < 960.0 and not Rooms.player.is_walking, 10.0)
	assert_lt(Rooms.player.global_position.y, 960.0)
	assert_almost_eq(Rooms.player.global_position.x, 960.0, 40.0)


func test_actor_is_smaller_farther_away() -> void:
	Rooms.player.global_position = Vector2(960, 935)
	await wait_process_frames(2)
	assert_almost_eq(Rooms.player.scale.y, Rooms.current.scale_at(935.0), 0.001)
	assert_lt(Rooms.player.scale.y, 0.6)


func test_click_on_the_statue_walks_there_and_says_its_lines() -> void:
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await wait_until(func() -> bool: return _lines.size() >= 2, 15.0)
	assert_eq(_lines, ["SANDBOX_STATUE_LOOK", "SANDBOX_STATUE_LOOK_2"] as Array[String])
	assert_almost_eq(Rooms.player.global_position.distance_to(statue.walk_point()), 0.0, 2.0)
	assert_eq(Rooms.player.facing, AnimNames.Dir.U, "faces up toward the statue")


func test_a_verb_with_no_handler_plays_a_fallback_line() -> void:
	var altar := Rooms.current.hotspots.get_node("Altar") as Hotspot
	Interaction.click_at(altar.focus_point())
	await wait_until(func() -> bool: return _lines.size() >= 1, 15.0)
	assert_eq(_lines.size(), 1)
	assert_true(_lines[0].begins_with("CORE_FALLBACK_LOOK_"), "got %s" % [_lines])


func test_input_is_locked_while_a_line_is_spoken() -> void:
	_auto_skip = false
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await wait_until(func() -> bool: return Say.speaking and _lines.size() >= 1, 15.0)
	Interaction.click_at(Vector2(1500, 1000))
	await wait_process_frames(2)
	assert_false(Rooms.player.is_walking, "a click while speaking does not walk")


func test_a_left_click_event_reaches_interaction() -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = Vector2(1200, 1020)
	get_viewport().push_input(event, true)
	await wait_until(func() -> bool: return Rooms.player.is_walking, 3.0)
	assert_true(Rooms.player.is_walking)
