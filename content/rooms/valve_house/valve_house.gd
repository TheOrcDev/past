extends Room
## The valve house (plan 008, chapter 2 room 11): Aldous's key unlocks the
## valve; its memory shows Unknown who he was; turning it drains the quarter
## and gives three memories back. Then the Ferryman, Corin again, takes him to
## the upper city (chapter 3), or the chapter's card ends a build without it.
## Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/aqueduct"


func _on_shown() -> void:
	if not GameState.get_flag(&"valve_arrived"):
		GameState.set_flag(&"valve_arrived")
		await Say.line(DIALOGUE, &"valve_arrival")


func item_valve(item: ItemDef) -> void:
	if item.id != &"sluice_key":
		await Say.fallback(&"item")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"sluice_key")
	GameState.set_flag(&"valve_unlocked")
	await Say.line(DIALOGUE, &"valve_unlocked")


func use_valve() -> void:
	if not GameState.get_flag(&"valve_unlocked"):
		await Say.line(DIALOGUE, &"valve_locked")
		return
	if not &"ch2_signing" in GameState.memories:
		await Cutscenes.play(rewatch_ch2_signing())
		GameState.learn(&"i_am_ulric")
		GameState.learn(&"the_flood")
		await Say.line(DIALOGUE, &"signing_after")
	await Rooms.player.play(&"use")
	GameState.set_flag(&"ch2_done")
	await Say.line(DIALOGUE, &"drained")
	await _onward()


func _onward() -> void:
	if Chapters.in_build(&"upper_avenue"):
		Rooms.goto.call_deferred(&"upper_avenue", &"from_ferry", &"fade")
		return
	await Cutscenes.play(StepsCutscene.new(&"ch2_end", func(c: CutsceneSteps) -> void:
		await c.fade(1.0, 1.5)
		var card := EndCard.new("THE DROWNED QUARTER", "Upstream, the city on the hill keeps its records.")
		get_tree().root.add_child(card)
		card.fade_in()
		await c.wait(5.5)
		card.queue_free()
		await c.fade(0.0, 1.0)))


func look_valve() -> void:
	await Say.line(DIALOGUE, &"valve_look")

func look_grating() -> void:
	await Say.line(DIALOGUE, &"grating_look")

func look_desk() -> void:
	await Say.line(DIALOGUE, &"valve_desk_look")


## The valve's vision, for touching it and for watching it again.
func rewatch_ch2_signing() -> Vision:
	var anchor := hotspots.get_node(^"Valve") as Hotspot
	return Vision.new(&"ch2_signing", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch2/aqueduct", &"signing_return")
		await c.wait(1.5))
