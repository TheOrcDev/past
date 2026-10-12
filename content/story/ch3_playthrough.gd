class_name Ch3Playthrough
extends Playthrough
## Plays chapter 3, The Hall of Records (plan 008 slice 7,
## docs/story/ch3-puzzles.md), from the upper avenue to the covered bridge,
## along the player's mouse paths. It starts with what chapter 2 leaves
## (Chapters.start_state). The GUT test and the `ch3` QA scenario run it.


func run() -> void:
	_start_listening()
	Chapters.start_state(Chapters.part(&"ch3"))
	await Rooms.goto(&"upper_avenue", &"from_ferry", &"none")
	await _until_free()
	# The Hangman refused once; the beam remembers it.
	await _leave("ToGallows", &"gallows_square")
	_talk("Hangman")
	await _choose("Why is the theatre chained?")
	await _choose("Goodbye.")
	await _settle()
	await _verb("Beam", &"use")
	await _until_memory(&"ch3_refusal")
	_talk("Hangman")
	await _choose("You refused, once. I saw it.")
	await _choose("It was me you hanged.")
	await _choose("Goodbye.")
	await _settle()
	check.call(Inventory.has(&"chain_key") and GameState.get_flag(&"hangman_told"), "the Hangman's key, and the truth")
	await _shot("01_the_hangman")
	# The theatre: the show, and the clerk's quill.
	await _leave("Arch", &"upper_avenue")
	await _leave("ToTheatre", &"theater_facade")
	await _give(&"chain_key", "Doors")
	check.call(GameState.get_flag(&"theater_open"), "the chain comes off")
	await _leave("Doors", &"theater_stage")
	_talk("Puppeteer")
	await _choose("Show me the play.")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"saw_show"), "The Magistrate and the Book")
	await _shot("02_the_show")
	await _leave("Wings", &"theater_backstage")
	await _verb("Clerk", &"use")
	check.call(Inventory.has(&"clerk_quill"), "the clerk's quill")
	await _leave("ToStage", &"theater_stage")
	await _leave("Foyer", &"theater_facade")
	await _leave("ToAvenue", &"upper_avenue")
	# Into the Hall of Records.
	await _leave("ToRecords", &"records_gate")
	await _give(&"seal_ring", "Gate")
	check.call(GameState.get_flag(&"records_gate_open"), "the ring opens the records gate")
	await _leave("Gate", &"hall_of_records")
	await _give(&"clerk_quill", "Register")
	check.call(GameState.get_flag(&"signed_in"), "signed in as Unknown")
	await _leave("StacksDoor", &"archive_stacks")
	await _click("Lectern")
	await _closeup_click("Dove")
	await _close()
	check.call(GameState.get_flag(&"knows_office"), "the Dove's entry")
	await _leave("Arch", &"hall_of_records")
	await _leave("ChamberDoor", &"registrar_chamber")
	_talk("Registrar")
	await _choose("Why did you strike me?")
	await _choose("I want to see my office.")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"office_permitted"), "the Registrar opens the office")
	await _verb("Desk", &"use")
	await _until_memory(&"ch3_first_entry")
	await _shot("03_the_registrar")
	await _leave("Door", &"hall_of_records")
	# The playable memory: Ulric at his desk.
	await _leave("OfficeDoor", &"magistrate_office")
	await _verb("Desk", &"use")
	while not Flashback.in_memory or Cutscenes.current != null:
		await _tree.process_frame
	await _settle()
	check.call(Rooms.current.era == &"then", "the office's past, playable")
	await _verb("Ledger", &"use")
	while Flashback.in_memory:
		await _tree.process_frame
	await _settle()
	check.call(&"ch3_office" in GameState.memories and &"struck_the_dove" in GameState.facts, "he struck her name himself")
	await _shot("04_the_desk")
	# The vault opens to SILENCE, and the Registrar runs.
	await _leave("Door", &"hall_of_records")
	await _leave("ChamberDoor", &"registrar_chamber")
	Interaction.click_at(_spot("Vault").focus_point())
	await _choose("SILENCE.")
	await _until_free()
	check.call(GameState.get_flag(&"vault_open") and GameState.get_flag(&"registrar_fled"), "the vault opens and the Registrar flees")
	await _leave("Vault", &"ledger_vault")
	await _shot("05_the_empty_vault")
	await _leave("Passage", &"covered_bridge")
	await _verb("FarDoor", &"use")
	await _until_free()
	check.call(GameState.get_flag(&"ch3_done"), "across the bridge")
	_stop_listening()


## Waits out cutscenes and lines (an arrival's reveal, a vision, a card).
func _until_free() -> void:
	await _tree.process_frame
	while Cutscenes.current != null or Interaction.locked > 0 or Say.speaking:
		await _tree.process_frame
	await _settle()
