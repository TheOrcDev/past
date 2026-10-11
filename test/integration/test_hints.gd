extends GutTest
## Hints (plan 004 slice 9): clicking Unknown makes him think aloud about the
## current goal, the goal follows GameState progress, and asking again about
## the same goal gets a more direct line.

var _lines: Array = []
var _listen: Callable


func before_each() -> void:
	GameState.reset()
	GameState.set_flag(&"cemetery_arrived")
	_lines.clear()
	_listen = func(id: String, _speaker: String, _text: String) -> void:
		_lines.append(id)
		Say.skip.call_deferred()
	Say.line_started.connect(_listen)
	await Rooms.goto(&"cemetery_grave", &"default", &"none")


func after_each() -> void:
	if Closeups.current:
		await Closeups.close()
	await wait_until(func() -> bool: return Interaction.locked == 0 and not Say.speaking, 10.0)
	Say.line_started.disconnect(_listen)
	Rooms.clear()
	GameState.reset()


func test_the_goal_follows_progress() -> void:
	var goals: Array[Dictionary] = (load("res://content/hints/goals.gd") as GDScript).GOALS
	assert_eq(Hints.current_goal(), &"stone")
	for goal in goals:
		assert_eq(Hints.current_goal(), goal["goal"])
		_complete(goal)
	assert_eq(Hints.current_goal(), &"", "every goal done")


func test_asking_again_gets_more_direct() -> void:
	for i in 4:
		await Hints.ask()
	assert_eq(_lines, ["HINT_STONE_1", "HINT_STONE_2", "HINT_STONE_3", "HINT_STONE_3"], "the most direct line repeats")
	GameState.set_flag(&"tombstone_read")
	_lines.clear()
	await Hints.ask()
	assert_eq(_lines, ["HINT_GRAVEDIGGER_1"], "then the next goal's first line")
	for goal: Dictionary in (load("res://content/hints/goals.gd") as GDScript).GOALS:
		_complete(goal)
	_lines.clear()
	await Hints.ask()
	assert_eq(_lines, ["HINT_NONE_1"])


func test_every_goal_has_its_lines() -> void:
	var cues := (load(Say.DIALOGUE_PATH % Hints.DIALOGUE) as DialogueResource).get_cues()
	for goal: Dictionary in (load("res://content/hints/goals.gd") as GDScript).GOALS:
		assert_true(cues.has("%s_1" % goal["goal"]), "%s has a first hint" % goal["goal"])


func _complete(goal: Dictionary) -> void:
	if goal.has("flag"):
		GameState.set_flag(goal["flag"])
	else:
		GameState.remember(goal["memory"])


func test_clicking_unknown_asks_him() -> void:
	# His legs, below the grave mound he stands in front of.
	var on_him := Rooms.player.global_position + Vector2(0, -40) * Rooms.player.scale.y
	assert_true(Rooms.player.contains_point(on_him), "a point on his body")
	assert_false(Rooms.player.contains_point(Rooms.player.global_position + Vector2(400, -180)), "and one beside him")
	await Interaction.click_at(on_him)
	assert_eq(_lines, ["HINT_STONE_1"])


func test_a_hotspot_behind_him_still_takes_the_click() -> void:
	# His chest, in front of the grave mound: the grave answers, not a hint.
	var chest := Rooms.player.global_position + Vector2(0, -180) * Rooms.player.scale.y
	assert_true(Rooms.player.contains_point(chest))
	await Interaction.click_at(chest)
	assert_eq(_lines, ["CEM_GRAVE_LOOK_1", "CEM_GRAVE_LOOK_2"])


func test_progress_is_noted_where_it_happens() -> void:
	await Closeups.open(&"tombstone", Rooms.current.hotspots.get_node("Gravestone") as Hotspot)
	await Interaction.click_at((Closeups.current.hotspots.get_node("Inscription") as Hotspot).focus_point())
	assert_true(GameState.get_flag(&"tombstone_read"), "reading the inscription")
	await Closeups.close()
	await Rooms.goto(&"cathedral_nave", &"from_cemetery", &"none")
	assert_true(GameState.get_flag(&"cathedral_visited"), "entering the cathedral")
