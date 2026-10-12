extends Room
## The aqueduct's foot (plan 008, chapter 2 room 9): the dedication plaque,
## whose seal is the seal on Unknown's ring. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/aqueduct"
const PLAQUE := preload("res://content/closeups/aqueduct_plaque/aqueduct_plaque.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"foot_arrived"):
		GameState.set_flag(&"foot_arrived")
		await Say.line(DIALOGUE, &"foot_arrival")


func look_plaque() -> void:
	await Closeups.open_node(PLAQUE.instantiate() as Closeup, hotspots.get_node(^"Plaque") as Hotspot)


func use_plaque() -> void:
	await Say.line(DIALOGUE, &"plaque_use")
	if not &"ch2_dedication" in GameState.memories:
		await Cutscenes.play(rewatch_ch2_dedication())


func item_plaque(item: ItemDef) -> void:
	if item.id != &"seal_ring":
		await Say.fallback(&"item")
		return
	await Rooms.player.play(&"use")
	GameState.set_flag(&"seal_matched")
	GameState.learn(&"my_seal")
	await Say.line(DIALOGUE, &"plaque_ring")


func look_pier() -> void:
	await Say.line(DIALOGUE, &"pier_look")


## The plaque's vision, for touching it and for watching it again.
func rewatch_ch2_dedication() -> Vision:
	var anchor := hotspots.get_node(^"Plaque") as Hotspot
	return Vision.new(&"ch2_dedication", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch2/aqueduct", &"dedication_return")
		await c.wait(1.0))
