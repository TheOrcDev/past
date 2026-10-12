class_name Ch1Playthrough
extends Playthrough
## Plays chapter 1, The Nameless Streets (plan 008 slice 5,
## docs/story/ch1-puzzles.md), from the cathedral square to the lower gate,
## along the player's mouse paths. It starts with what the prologue leaves
## (Chapters.start_state). The GUT test and the `ch1` QA scenario run it.


func run() -> void:
	_start_listening()
	Chapters.start_state(Chapters.part(&"ch1"))
	await Rooms.goto(&"cathedral_parvis", &"from_cathedral", &"none")
	await _settle()
	# The Crier's headline gives the hour.
	_talk("Crier")
	await _choose("What's the latest news?")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"knows_eleven"), "the Crier gives the hour")
	await _shot("01_the_crier")
	# The Lamplighter wants one warm lamp.
	await _leave("Street", &"street_of_lamps")
	_talk("Lamplighter")
	await _choose("Why don't they give any light?")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"lamplighter_wants"), "the Lamplighter's wish")
	# The saint's ribbon holds his memory of the wedding.
	await _leave("ToMarket", &"market_square")
	await _verb("Ribbon", &"use")
	await _until_memory(&"ch1_wedding")
	await _shot("02_the_wedding")
	# The bride's candle is still on the tavern mantel.
	await _leave("ToStreet", &"street_of_lamps")
	await _leave("ToParvis", &"cathedral_parvis")
	await _leave("Alley", &"alley_of_doors")
	await _leave("TavernDoor", &"tavern_lost_name")
	await _verb("Mantel", &"use")
	check.call(Inventory.has(&"wedding_candle"), "the bride's candle")
	await _leave("BackDoor", &"alley_of_doors")
	await _leave("ToParvis", &"cathedral_parvis")
	await _leave("Street", &"street_of_lamps")
	# The candle warms his flame, and he knows the memory as his own.
	await _give(&"wedding_candle", "Lamplighter")
	check.call(GameState.get_flag(&"mathis_named") and Inventory.has(&"warm_lamp"), "Mathis remembers his name and lends the lamp")
	check.call(&"memories_not_mine" in GameState.facts, "Unknown learns the memories aren't his")
	await _shot("03_mathis")
	# The Clockmaker's three needs.
	await _leave("ToMarket", &"market_square")
	await _leave("ToBridge", &"canal_bridge")
	await _leave("OverBridge", &"clock_tower_base")
	_talk("Clockmaker")
	await _choose("What would it need, to run?")
	await _choose("It stopped at eleven.")
	await _choose("Goodbye.")
	await _settle()
	check.call(GameState.get_flag(&"clockmaker_wants"), "the Clockmaker's three needs")
	# The Broker trades the winding key for the mended lantern, and the ring.
	await _leave("ToBridge", &"canal_bridge")
	await _leave("ToMarket", &"market_square")
	await _leave("PawnDoor", &"pawn_shop")
	await _give(&"lantern", "Broker")
	check.call(Inventory.has(&"winding_key") and not Inventory.has(&"lantern"), "the lantern buys the winding key")
	_talk("Broker")
	await _choose("May I try the ring on?")
	await _choose("Goodbye.")
	await _settle()
	check.call(Inventory.has(&"seal_ring"), "the seal ring fits")
	await _shot("04_the_ring")
	await _leave("Door", &"market_square")
	await _leave("ToBridge", &"canal_bridge")
	await _leave("OverBridge", &"clock_tower_base")
	# Inside the clock: the apprentice's memory gives the third tooth.
	await _leave("TowerDoor", &"clockworks")
	await _verb("Escapement", &"use")
	while not Flashback.in_memory or Cutscenes.current != null:
		await _tree.process_frame
	await _settle()
	check.call(Rooms.current.era == &"then", "the clock's past, playable")
	await _shot("05_the_apprentice")
	await _click("Chalk")
	while Flashback.in_memory:
		await _tree.process_frame
	await _settle()
	check.call(&"ch1_apprentice" in GameState.memories and Rooms.current.era == &"now", "the third tooth, and back")
	await _verb("Escapement", &"use")
	check.call(GameState.get_flag(&"escapement_set"), "the pin on the third tooth")
	await _give(&"winding_key", "Post")
	check.call(GameState.get_flag(&"clock_wound"), "the clock is wound")
	# Eleven bells.
	await _leave("Ladder", &"clock_face")
	await _verb("Hands", &"use")
	await _until_memory(&"ch1_old_town")
	check.call(GameState.get_flag(&"clock_struck") and GameState.get_flag(&"lower_gate_open"), "the clock strikes eleven")
	await _shot("06_eleven_bells")
	await _leave("Hatch", &"clockworks")
	await _leave("Trapdoor", &"clock_tower_base")
	await _leave("Stairs", &"lower_gate")
	await _verb("Portcullis", &"use")
	while Cutscenes.current != null:
		await _tree.process_frame
	await _settle()
	check.call(GameState.get_flag(&"ch1_done"), "through the lower gate")
	await _shot("07_the_lower_gate")
	_stop_listening()
