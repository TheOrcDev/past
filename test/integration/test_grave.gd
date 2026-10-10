extends GutTest
## The grave (plan 007), where the game starts: the arrival line plays once,
## the gravestone opens its close-up, the stone's carvings answer with Unknown's
## lines, and exits join the grave and the cathedral both ways.

var _lines: Array = []
var _listen: Callable


func before_each() -> void:
	GameState.flags.erase(&"cemetery_arrived")
	_lines.clear()
	_listen = func(id: String, _speaker: String, _text: String) -> void:
		_lines.append(id)
		Say.skip.call_deferred()
	Say.line_started.connect(_listen)
	await Rooms.goto(&"cemetery_grave", &"default", &"none")
	await _until_free()


func after_each() -> void:
	await _until_free()
	if Closeups.current:
		await Closeups.close()
	Say.line_started.disconnect(_listen)
	Rooms.clear()
	GameState.flags.erase(&"cemetery_arrived")


func _until_free() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0 and not Say.speaking and not Closeups.busy, 10.0)


func test_the_arrival_line_plays_once() -> void:
	assert_eq(_lines, ["CEM_ARRIVAL_1"])
	await Rooms.goto(&"cemetery_grave", &"default", &"none")
	await _until_free()
	assert_eq(_lines, ["CEM_ARRIVAL_1"], "not again on a second visit")


func test_the_gravestone_opens_its_closeup() -> void:
	var gravestone := Rooms.current.hotspots.get_node("Gravestone") as Hotspot
	assert_eq(Interaction.hotspot_at(gravestone.focus_point()), gravestone)
	Interaction.click_at(gravestone.focus_point())
	await wait_for_signal(Closeups.opened, 20.0)
	assert_not_null(Closeups.current)
	assert_eq(Closeups.current.closeup_id, &"tombstone")
	assert_lt(Rooms.player.global_position.distance_to(gravestone.walk_point()), 4.0, "Unknown walked to the stone first")


func test_the_stone_up_close() -> void:
	await Closeups.open(&"tombstone", Rooms.current.hotspots.get_node("Gravestone") as Hotspot)
	var closeup := Closeups.current
	_lines.clear()
	for spot in ["Name", "Inscription", "Dove"]:
		Interaction.click_at((closeup.hotspots.get_node(spot) as Hotspot).focus_point())
		await _until_free()
	assert_eq(_lines, ["CEM_NAME_LOOK_1", "CEM_NAME_LOOK_2", "CEM_INSCRIPTION_LOOK_1", "CEM_INSCRIPTION_LOOK_2", "CEM_DOVE_LOOK_1"])
	Interaction.right_click()
	await wait_for_signal(Closeups.closed, 5.0)
	assert_null(Closeups.current, "a right click backs out to the grave")


func test_each_carving_is_picked_at_its_centre() -> void:
	var closeup := (load("res://content/closeups/tombstone/tombstone.tscn") as PackedScene).instantiate() as Closeup
	add_child_autofree(closeup)
	assert_eq((closeup.get_node("Background") as Sprite2D).texture.get_size(), Vector2(1920, 1080))
	for spot in ["Name", "Inscription", "Dove"]:
		var hotspot := closeup.hotspots.get_node(spot) as Hotspot
		assert_eq(closeup.hotspot_at(hotspot.focus_point()), hotspot, "%s at its centre" % spot)


func test_exits_join_the_grave_and_the_cathedral() -> void:
	Interaction.double_click_at((Rooms.current.hotspots.get_node("ExitEast") as Hotspot).focus_point())
	await wait_for_signal(Rooms.room_changed, 5.0)
	assert_eq(Rooms.current.room_id, &"cathedral_nave")
	assert_eq(Rooms.player.global_position, Rooms.current.marker_position(&"from_cemetery"))
	await _until_free()
	assert_true(await Rooms.player.walk_to(Vector2(900, 1010)), "Unknown can walk on from the cathedral's breach")
	Interaction.double_click_at((Rooms.current.hotspots.get_node("ExitWest") as Hotspot).focus_point())
	await wait_for_signal(Rooms.room_changed, 5.0)
	assert_eq(Rooms.current.room_id, &"cemetery_grave")
	assert_eq(Rooms.player.global_position, Rooms.current.marker_position(&"from_cathedral"))
	await _until_free()
	assert_true(await Rooms.player.walk_to(Vector2(900, 905)), "and back to the grave")
