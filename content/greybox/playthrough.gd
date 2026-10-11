class_name GreyboxPlaythrough
extends RefCounted
## Plays the greybox puzzle chain (plan 004 slice 11) from start to finish
## through the paths a player's mouse takes: clicks for default verbs, the verb
## coin for the others, inventory slots, dialogue choices and exits. The GUT
## test and the `greybox` QA scenario both run it.
##
## The chain: look at the rusted gate, take the rag, ask the gatekeeper about
## the word, take the oil in the chapel, combine it with the rag, touch the
## altar to step into its past and read the word there, oil the gate, say the
## word, open the gate and walk through.

## Called as check.call(ok, what) after each step that must have worked.
var check: Callable
## Called as await shot.call(name) at the chain's main moments, or not at all.
var shot: Callable
## Lines are cut short as they start; off, they play at reading pace (for a
## recording).
var skip_lines := true
## The ids of the lines spoken so far.
var lines: Array[String] = []

var _tree: SceneTree


func _init(tree: SceneTree, on_check: Callable, on_shot := Callable()) -> void:
	_tree = tree
	check = on_check
	shot = on_shot


func run() -> void:
	var listen := func(id: String, _speaker: String, _text: String) -> void:
		lines.append(id)
		if skip_lines:
			Say.skip.call_deferred()
	Say.line_started.connect(listen)
	await Rooms.goto(&"greybox_gate", &"default", &"none")
	await _settle()
	# Look: a click's default verb.
	await _click("Gate")
	check.call("GB_GATE_LOOK_1" in lines, "looking at the gate")
	# Use, through the verb coin: the rag leaves its hook.
	await _verb("Rag", &"use")
	check.call(Inventory.has(&"rag") and not _spot("Rag").visible, "taking the rag")
	await _shot("01_took_the_rag")
	# Talk: the gatekeeper's default verb, and a choice.
	Interaction.click_at(_spot("Gatekeeper").focus_point())
	await _choose("What word?", "02_asking_the_gatekeeper")
	await _choose("Nothing.")
	await _settle()
	check.call("GB_KEEPER_WORD" in lines, "the gatekeeper names the chapel's altar")
	await _leave("ExitWest", &"greybox_chapel")
	await _verb("Flask", &"use")
	check.call(Inventory.has(&"oil"), "taking the oil")
	# Combine, in the inventory: pick the rag, then click the oil.
	Interaction.right_click()
	await _click_slot(&"rag")
	await _click_slot(&"oil")
	check.call(Inventory.has(&"oiled_rag") and not Inventory.has(&"rag"), "the rag and the oil make an oiled rag")
	await _shot("03_combined")
	Interaction.right_click()
	# The flashback clue, a playable memory: in the chapel's past the carving is
	# whole, and reading it ends the memory.
	await _verb("Altar", &"use")
	await _settle()
	check.call(Flashback.in_memory and Rooms.current.era == &"then", "touching the altar steps into the past")
	while Cutscenes.letterbox.amount > 0.01:
		await _tree.process_frame
	await _shot("04_in_the_past")
	await _click("Carving")
	while Flashback.in_memory:
		await _tree.process_frame
	await _settle()
	check.call(GameState.get_flag(&"greybox_knows_word") and Rooms.current.era == &"now", "the past gives the word, and the present returns")
	await _leave("ExitEast", &"greybox_gate")
	# The oiled rag on the gate: picked in the inventory, then a click outside.
	Interaction.right_click()
	await _click_slot(&"oiled_rag")
	var gate := _spot("Gate")
	await _click_outside(_tree.root.get_canvas_transform() * gate.focus_point())
	await _settle()
	check.call(GameState.get_flag(&"greybox_gate_oiled"), "oiling the gate")
	Interaction.click_at(_spot("Gatekeeper").focus_point())
	await _choose("The word is Mercy.")
	await _settle()
	check.call(GameState.get_flag(&"greybox_word_spoken"), "saying the word")
	await _verb("Gate", &"use")
	check.call(GameState.get_flag(&"greybox_gate_open") and _spot("Beyond").visible, "the gate opens")
	await _shot("05_gate_open")
	Interaction.click_at(_spot("Beyond").focus_point())
	await Rooms.room_changed
	await _settle()
	check.call(Rooms.current.room_id == &"greybox_courtyard" and GameState.get_flag(&"greybox_done"), "through the gate to the end")
	await _shot("06_through_the_gate")
	Say.line_started.disconnect(listen)


func _spot(hotspot_name: String) -> Hotspot:
	return Rooms.current.hotspots.get_node(hotspot_name) as Hotspot


## A left click on a hotspot: Unknown walks there and runs its default verb.
func _click(hotspot_name: String) -> void:
	await Interaction.click_at(_spot(hotspot_name).focus_point())
	await _settle()


## Holds the button on a hotspot until the verb coin opens, then lets go over
## `verb`.
func _verb(hotspot_name: String, verb: StringName) -> void:
	var world := _spot(hotspot_name).focus_point()
	Interaction.press_at(world, _tree.root.get_canvas_transform() * world)
	await _tree.create_timer(Interaction.COIN_HOLD_SECONDS + 0.1).timeout
	check.call(Interaction.coin.is_open, "the verb coin opens on %s" % hotspot_name)
	var glyph := Interaction.coin.glyph_position(verb)
	Interaction.coin.point_at(glyph)
	await Interaction.release_at(world, glyph)
	await _settle()


## Picks the dialogue choice reading `text` once the choices show.
func _choose(text: String, shot_name := "") -> void:
	while not Say.choices.is_open:
		await _tree.process_frame
	var index := Say.choices.index_of(text)
	check.call(index >= 0, "the choice \"%s\" is offered" % text)
	if not shot_name.is_empty():
		await _shot(shot_name)
	Say.choices.pick(maxi(index, 0))


func _leave(exit_name: String, room: StringName) -> void:
	Interaction.double_click_at(_spot(exit_name).focus_point())
	await Rooms.room_changed
	await _settle()
	check.call(Rooms.current.room_id == room, "into %s" % room)


## A left click on an item in the open inventory.
func _click_slot(id: StringName) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	Interaction.inventory.slot_for(id).gui_input.emit(event)
	await _tree.process_frame


## A left click outside the open inventory's band, at `screen`.
func _click_outside(screen: Vector2) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = screen
	Interaction.inventory.get_node(^"Band").gui_input.emit(event)
	await _tree.process_frame


func _shot(shot_name: String) -> void:
	if shot.is_valid():
		await shot.call(shot_name)


## Waits until Unknown stands still and the player could act again.
func _settle() -> void:
	await _tree.process_frame
	while Interaction.locked > 0 or Say.speaking or Rooms.player.is_walking or Closeups.busy:
		await _tree.process_frame
