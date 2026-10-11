class_name ProloguePlaythrough
extends Playthrough
## Plays the prologue (plan 008 slice 4, docs/story/prologue-puzzles.md) from
## the grave to the great doors, along the player's mouse paths. The GUT test
## and the `prologue` QA scenario both run it.


func run() -> void:
	_start_listening()
	await Rooms.goto(&"cemetery_grave", &"default", &"none")
	await _settle()
	# The stone: a click opens its close-up, the inscription is read.
	await _click("Gravestone")
	await _closeup_click("Inscription")
	await _close()
	check.call(GameState.get_flag(&"tombstone_read"), "reading the gravestone")
	await _shot("01_the_stone")
	await _leave("ExitWest", &"cemetery_gate")
	# The Gravedigger: his lantern lost its glass.
	_talk("Gravedigger")
	await _choose("What happened to your lantern?")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"gd_met") and GameState.get_flag(&"gd_lantern_asked"), "meeting the Gravedigger")
	await _shot("02_the_gravedigger")
	# The lodge: the register says which key.
	await _leave("LodgeDoor", &"sexton_lodge")
	await _verb("Keys", &"use")
	check.call(not Inventory.has(&"ossuary_key"), "no key before the register is read")
	await _click("Register")
	await _closeup_click("Entry")
	await _closeup_click("Margin")
	await _close()
	check.call(GameState.get_flag(&"register_read"), "reading the register")
	await _verb("Keys", &"use")
	check.call(Inventory.has(&"ossuary_key"), "taking key thirteen")
	await _leave("Door", &"cemetery_gate")
	# The crypt steps open with the key.
	await _give(&"ossuary_key", "Crypt")
	check.call(GameState.get_flag(&"ossuary_open") and not Inventory.has(&"ossuary_key"), "unlocking the crypt")
	await _leave("Crypt", &"ossuary")
	await _verb("Niches", &"use")
	await _until_memory(&"prologue_edict")
	await _shot("03_the_ossuary")
	await _verb("Nest", &"use")
	check.call(Inventory.has(&"lantern_glass"), "the glass from the crow's nest")
	await _leave("Stair", &"cemetery_gate")
	# The glass mends the lantern, and he tells of the night.
	await _give(&"lantern_glass", "Gravedigger")
	check.call(GameState.get_flag(&"gd_lantern_mended") and Inventory.has(&"lantern"), "the lantern, mended and lent")
	_talk("Gravedigger")
	await _choose("Tell me about that night.")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"gd_told_night"), "the story of the night")
	# The cathedral thread.
	await _leave("ExitEast", &"cemetery_grave")
	await _leave("ExitEast", &"cathedral_nave")
	await _leave("Arch", &"cathedral_cloister")
	_talk("Sister")
	await _choose("Did you know someone called the dove?")
	await _choose("I need to get into the city.")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"sister_wants_book"), "the Sister wants the hymn book")
	await _shot("04_the_sister")
	await _leave("Turret", &"choir_loft")
	await _verb("Stand", &"use")
	await _until_memory(&"prologue_singer")
	await _verb("Stand", &"use")
	check.call(Inventory.has(&"hymn_book"), "taking the hymn book")
	await _shot("05_the_loft")
	await _leave("Stair", &"cathedral_cloister")
	await _give(&"hymn_book", "Sister")
	check.call(Inventory.has(&"west_door_key"), "the west door key")
	await _leave("Doorway", &"cathedral_nave")
	await _give(&"west_door_key", "Doors")
	while Cutscenes.current != null:
		await _tree.process_frame
	await _settle()
	check.call(GameState.get_flag(&"west_doors_open"), "the great doors open")
	await _shot("06_the_doors")
	_stop_listening()


func _closeup_click(hotspot_name: String) -> void:
	await Interaction.click_at((Closeups.current.hotspots.get_node(hotspot_name) as Hotspot).focus_point())
	await _settle()


func _close() -> void:
	Interaction.right_click()
	while Closeups.current != null or Closeups.busy:
		await _tree.process_frame
	await _settle()


func _until_memory(memory: StringName) -> void:
	while not memory in GameState.memories or Cutscenes.current != null:
		await _tree.process_frame
	await _settle()
	check.call(memory in GameState.memories, "the vision %s" % memory)
