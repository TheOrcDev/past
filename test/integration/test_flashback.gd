extends GutTest
## A flashback vision in the cathedral: the past blooms in, holds, drains back,
## and the room, grade, input lock and camera end exactly as they started.

var _era_during_hold: StringName


func before_all() -> void:
	Engine.time_scale = 8.0


func after_all() -> void:
	Engine.time_scale = 1.0


func before_each() -> void:
	await Rooms.goto(&"cathedral_nave", &"default", &"none")


func after_each() -> void:
	Rooms.clear()


func test_vision_shows_the_past_then_returns_to_the_present() -> void:
	var room := Rooms.current
	var origin := (room.hotspots.get_node("Statue") as Hotspot).focus_point()
	await Flashback.vision(room, origin, func() -> void:
		_era_during_hold = room.era
		assert_true(Interaction.locked > 0, "input is locked during the vision")
		await get_tree().create_timer(0.5).timeout)
	assert_eq(_era_during_hold, &"then", "the past is shown during the hold")
	assert_eq(room.era, &"now", "back in the present afterwards")
	assert_eq(Interaction.locked, 0, "input unlocked")
	assert_false(Flashback.playing)
	assert_null((room.get_node("Layers/Then/Background") as Sprite2D).material, "dissolve material removed")
	assert_false(room.get_node("Layers/Then").visible)
	for node in room.era_nodes() + room.get_node("Layers/Now").get_children():
		assert_eq((node as CanvasItem).modulate.a, 1.0, "%s opacity restored" % node.name)
	await wait_process_frames(2)
	assert_eq(room.get_viewport().get_canvas_transform(), Transform2D.IDENTITY, "drift camera removed")


func test_using_the_statue_plays_the_vision() -> void:
	watch_signals(Flashback)
	var skip_lines := func(_id: String, _speaker: String, _text: String) -> void: Say.skip.call_deferred()
	Say.line_started.connect(skip_lines)
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await wait_for_signal(Flashback.vision_finished, 40.0)
	Say.line_started.disconnect(skip_lines)
	assert_signal_emitted(Flashback, "vision_started")
	assert_signal_emitted(Flashback, "vision_finished")
	assert_eq(Rooms.current.era, &"now")
	await wait_until(func() -> bool: return Interaction.locked == 0, 5.0)
	assert_eq(Interaction.locked, 0)


func test_warm_up_draws_the_past_and_puts_everything_back() -> void:
	var room := Rooms.current
	await Flashback.warm_up(room)
	assert_false(room.get_node("Layers/Then").visible, "the past is hidden again")
	assert_null((room.get_node("Layers/Then/Background") as Sprite2D).material, "no dissolve left behind")
	for node in room.era_nodes():
		assert_eq(node.visible, node.is_in_group(&"era_now"), "%s back to its era's visibility" % node.name)


func test_a_fade_waits_for_the_warm_up_while_black() -> void:
	var seen := []
	var step := func(room: Room) -> void:
		seen.append(room.room_id)
		await get_tree().process_frame
	Rooms.while_black.append(step)
	await Rooms.goto(&"cathedral_nave", &"default", &"fade")
	Rooms.while_black.erase(step)
	assert_eq(seen, [&"cathedral_nave"], "steps run once with the new room")
	assert_true(Flashback.warm_up in Rooms.while_black, "the flashback warms up on every faded room change")


func test_unknown_eyes_flare_as_the_vision_opens_and_settle_after() -> void:
	var body := Rooms.player.get_node("Body") as UnknownBody
	var flared := [false]
	var watch := func(_origin: Vector2) -> void: flared[0] = body.eye_state == UnknownBody.EyeState.FLARE
	Flashback.vision_started.connect(watch)
	await Flashback.vision(Rooms.current, Vector2(200, 500), func() -> void: await get_tree().create_timer(0.3).timeout)
	Flashback.vision_started.disconnect(watch)
	assert_true(flared[0], "his eyes flare as the past opens")
	await wait_seconds(1.5)
	assert_eq(body.eye_state, UnknownBody.EyeState.IDLE, "and settle once it has closed")
