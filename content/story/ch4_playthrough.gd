class_name Ch4Playthrough
extends Playthrough
## Plays chapter 4, The Dovecote (plan 008 slice 8, docs/story/ch4-puzzles.md),
## from the cathedral roof to the epilogue, along the player's mouse paths. It
## starts with what chapter 3 leaves (Chapters.start_state). The GUT test and
## the `ch4` QA scenario run it.


func run() -> void:
	_start_listening()
	Chapters.start_state(Chapters.part(&"ch4"))
	await Rooms.goto(&"cathedral_roof", &"from_bridge", &"none")
	await _until_free()
	# Across the roof and the buttresses to the gargoyles.
	await _verb("Stone", &"use")
	check.call(Inventory.has(&"loose_stone"), "the loose stone")
	await _leave("ToButtress", &"buttress_walk")
	await _give(&"loose_stone", "Gap")
	check.call(GameState.get_flag(&"buttress_bridged"), "the stone fills the gap")
	await _leave("Gap", &"gargoyle_gallery")
	await _verb("KeyGargoyle", &"use")
	check.call(Inventory.has(&"dovecote_key"), "the key in the gargoyle's jaws")
	await _shot("01_the_gargoyles")
	# The Dove.
	await _leave("ToDovecote", &"dovecote")
	await _give(&"dovecote_key", "Door")
	_talk("Dove")
	await _choose("May I see your room?")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"dove_met") and GameState.get_flag(&"dove_room_ok"), "the Dove, and her room")
	await _shot("02_the_dove")
	await _leave("Trapdoor", &"dove_room")
	await _verb("Desk", &"use")
	check.call(Inventory.has(&"unsent_letter"), "the unsent letter")
	await _leave("Ladder", &"dovecote")
	await _give(&"unsent_letter", "Dove")
	check.call(GameState.get_flag(&"dove_forgave") and &"elise" in GameState.facts, "Elise forgives him")
	# The song of names, then up the tower.
	await _leave("TowerDoor", &"rose_window_ledge")
	await _verb("Rose", &"use")
	await _until_memory(&"ch4_song")
	await _shot("03_the_song")
	await _leave("StairDoor", &"bell_stair")
	await _leave("Up", &"bell_chamber")
	_talk("Registrar")
	await _choose("Edmund. Your name is Edmund Vey.")
	await _settle()
	check.call(GameState.get_flag(&"got_ledger") and Inventory.has(&"ledger"), "Edmund gives up the Ledger")
	await _shot("04_edmund")
	# The bell, the names, and the epilogue.
	await _leave("Ladder", &"belfry_top")
	await _give(&"ledger", "Bell")
	while Rooms.current == null or Rooms.current.room_id != &"grave_at_dawn":
		await _tree.process_frame
	await _until_free()
	check.call(GameState.get_flag(&"names_returned") and GameState.get_flag(&"epilogue_seen"), "every name returned, and the epilogue")
	await _shot("05_dawn")
	_stop_listening()


## Waits out cutscenes and lines (an arrival's reveal, a vision, a card).
func _until_free() -> void:
	await _tree.process_frame
	while Cutscenes.current != null or Interaction.locked > 0 or Say.speaking:
		await _tree.process_frame
	await _settle()
