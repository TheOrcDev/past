extends Room
## The belfry (plan 008, chapter 4 room 9): the finale. Unknown reads every
## name from the Ledger as the great bell rings, Elise's and then his own; the
## city takes back its color, and the epilogue follows. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/finale"
const BELL := preload("res://content/closeups/bell_inscription/bell_inscription.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"belfry_arrived"):
		GameState.set_flag(&"belfry_arrived")
		await Say.line(DIALOGUE, &"belfry_arrival")


func look_bell() -> void:
	await Closeups.open_node(BELL.instantiate() as Closeup, hotspots.get_node(^"Bell") as Hotspot)


func use_bell() -> void:
	await Say.line(DIALOGUE, &"great_bell_noledger")


func item_bell(item: ItemDef) -> void:
	if item.id != &"ledger":
		await Say.line(DIALOGUE, &"great_bell_noledger")
		return
	await Rooms.player.play(&"use")
	await Cutscenes.play(rewatch_ch4_city())
	Inventory.remove(&"ledger")
	GameState.set_flag(&"names_returned")
	GameState.learn(&"ulric")
	Rooms.goto.call_deferred(&"grave_at_dawn", &"default", &"fade")


## The finale's vision: the names read, and the city in color. It ends with
## the present gone gold, kept by the epilogue.
func rewatch_ch4_city() -> Vision:
	var anchor := hotspots.get_node(^"Bell") as Hotspot
	return Vision.new(&"ch4_city", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.0)
		await c.say(&"ch4/finale", &"finale")
		await c.wait(3.0))


func look_city() -> void:
	await Say.line(DIALOGUE, &"city_below_look")
