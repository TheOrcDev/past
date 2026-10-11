extends Room
## The ossuary (plan 008, atlas P3): the crow's nest with the lantern glass,
## and the scraped niches, whose memory is the vision "The edict". Hotspot
## verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"prologue/cemetery"
const NICHE := preload("res://content/closeups/ossuary_niche/ossuary_niche.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"ossuary_arrived"):
		GameState.set_flag(&"ossuary_arrived")
		await Say.line(DIALOGUE, &"ossuary_arrival")


func look_stair() -> void:
	await Say.line(DIALOGUE, &"ossuary_stair_look")


func look_nest() -> void:
	await Say.line(DIALOGUE, &"nest_look")


func use_nest() -> void:
	if GameState.get_flag(&"got_lantern_glass"):
		await Say.line(DIALOGUE, &"nest_empty")
		return
	await Rooms.player.play(&"pickup_high")
	GameState.set_flag(&"got_lantern_glass")
	Inventory.add(&"lantern_glass")
	await Say.line(DIALOGUE, &"nest_take")


func look_niches() -> void:
	await Closeups.open_node(NICHE.instantiate() as Closeup, hotspots.get_node("Niches") as Hotspot)


func use_niches() -> void:
	await Say.line(DIALOGUE, &"niches_use")
	await Cutscenes.play(rewatch_prologue_edict())


## The niches' vision, for touching them and for watching it again from the
## journal.
func rewatch_prologue_edict() -> Vision:
	var niches := hotspots.get_node("Niches") as Hotspot
	return Vision.new(&"prologue_edict", self, niches.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"prologue/cemetery", &"edict_return")
		await c.wait(1.0))


func look_skulls() -> void:
	await Say.line(DIALOGUE, &"skulls_look")


func look_candles() -> void:
	await Say.line(DIALOGUE, &"candles_look")
