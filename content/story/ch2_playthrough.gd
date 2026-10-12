class_name Ch2Playthrough
extends Playthrough
## Plays chapter 2, The Drowned Quarter (plan 008 slice 6,
## docs/story/ch2-puzzles.md), from the flooded stair to the valve house,
## along the player's mouse paths. It starts with what chapter 1 leaves
## (Chapters.start_state). The GUT test and the `ch2` QA scenario run it.


func run() -> void:
	_start_listening()
	Chapters.start_state(Chapters.part(&"ch2"))
	await Rooms.goto(&"flooded_stair", &"from_gate", &"none")
	await _until_free()
	# The bell calls the ferry; the fare is a small memory.
	await _verb("Bell", &"use")
	check.call(GameState.get_flag(&"ferry_called"), "the ferry bell")
	await _leave("Quay", &"ferry_landing")
	_talk("Ferryman")
	await _choose("The taste of bread, fresh from an oven.")
	await _ferry("The drowned street.", &"drowned_street")
	check.call(GameState.get_flag(&"ferry_paid"), "the fare is paid")
	await _shot("01_the_ferry")
	# The crate under the window, into the sluice house.
	await _verb("Crate", &"use")
	check.call(Inventory.has(&"crate"), "the floating crate")
	await _give(&"crate", "Window")
	check.call(GameState.get_flag(&"crate_set"), "the crate under the window")
	await _leave("Window", &"sluice_house")
	await _verb("Wheel", &"use")
	await _until_memory(&"ch2_petition")
	await _shot("02_the_petition")
	await _leave("Window", &"drowned_street")
	# Over the rooftops to the chapel and the doctor's oath.
	await _leave("Rooftops", &"drowned_chapel")
	await _verb("Altar", &"use")
	await _until_memory(&"ch2_oath")
	await _leave("Hole", &"drowned_street")
	# The Washerwoman: the A is for Aldous.
	await _leave("Ferry", &"ferry_landing")
	_talk("Ferryman")
	await _ferry("The washing steps.", &"washing_steps")
	_talk("Washerwoman")
	await _choose("The A is for Aldous. He signed the keepers' petition.")
	await _choose("Goodbye.")
	await _settle()
	check.call(Inventory.has(&"sluice_key"), "Maud's key")
	await _shot("03_maud")
	# The Plague Doctor: her oath, and her stretcher.
	await _leave("Ferry", &"ferry_landing")
	_talk("Ferryman")
	await _ferry("The hospice.", &"hospice_on_stilts")
	_talk("Doctor")
	await _choose("\"I will remember them, every one, by name.\"")
	await _choose("Goodbye.")
	await _settle()
	check.call(Inventory.has(&"stretcher"), "the doctor's stretcher")
	# Through the forest to the aqueduct.
	await _leave("Door", &"ferry_landing")
	_talk("Ferryman")
	await _ferry("The washing steps.", &"washing_steps")
	await _leave("ForestPath", &"drowned_forest")
	await _leave("Trunk", &"aqueduct_foot")
	await _verb("Plaque", &"use")
	await _until_memory(&"ch2_dedication")
	await _give(&"seal_ring", "Plaque")
	check.call(GameState.get_flag(&"seal_matched"), "the ring's seal is the aqueduct's")
	await _shot("04_the_seal")
	await _leave("MaintStair", &"aqueduct_channel")
	await _give(&"stretcher", "Gap")
	check.call(GameState.get_flag(&"span_bridged"), "the stretcher bridges the gap")
	await _give(&"seal_ring", "ValveDoor")
	check.call(GameState.get_flag(&"valve_door_open"), "the ring unseals the valve house")
	await _leave("ValveDoor", &"valve_house")
	# The valve: who he was.
	await _give(&"sluice_key", "Valve")
	check.call(GameState.get_flag(&"valve_unlocked"), "Aldous's key unlocks the valve")
	await _verb("Valve", &"use")
	if Chapters.in_build(&"upper_avenue"):
		while Rooms.current == null or Rooms.current.room_id != &"upper_avenue":
			await _tree.process_frame
	await _until_free()
	check.call(&"ch2_signing" in GameState.memories and &"i_am_ulric" in GameState.facts, "the signing: Ulric")
	check.call(GameState.get_flag(&"ch2_done"), "the quarter drains")
	await _shot("05_the_valve")
	_stop_listening()


## Names a landing to the Ferryman and rides there.
func _ferry(choice: String, room: StringName) -> void:
	await _choose(choice)
	while Rooms.current == null or Rooms.current.room_id != room:
		await _tree.process_frame
	await _settle()
	check.call(Rooms.current.room_id == room, "the ferry to %s" % room)


## Waits out cutscenes and lines (an arrival's reveal, a vision, a card).
func _until_free() -> void:
	await _tree.process_frame
	while Cutscenes.current != null or Interaction.locked > 0 or Say.speaking:
		await _tree.process_frame
	await _settle()
