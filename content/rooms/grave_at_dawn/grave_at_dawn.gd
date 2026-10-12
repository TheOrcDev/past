extends Room
## The grave at dawn (plan 008, chapter 4 room 10): the epilogue, in full
## color. Elise has recut the stone; Unknown fades, and the credits roll.
## Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/finale"
const STONE := preload("res://content/closeups/gravestone_restored/gravestone_restored.tscn")


func _on_shown() -> void:
	if GameState.get_flag(&"epilogue_seen"):
		return
	GameState.set_flag(&"epilogue_seen")
	await Say.line(DIALOGUE, &"epilogue")
	await Cutscenes.play(StepsCutscene.new(&"credits", func(c: CutsceneSteps) -> void:
		await c.wait(1.0)
		await c.fade(1.0, 3.0)
		var card := EndCard.new("PAST", "Unknown was Ulric. Thank you for remembering him.")
		get_tree().root.add_child(card)
		card.fade_in()
		await c.wait(7.0)
		card.queue_free()
		await c.fade(0.0, 1.5)))


func look_stone() -> void:
	await Closeups.open_node(STONE.instantiate() as Closeup, hotspots.get_node(^"Stone") as Hotspot)


func look_city() -> void:
	await Say.line(DIALOGUE, &"dawn_city_look")

func look_dove() -> void:
	await Say.line(DIALOGUE, &"dawn_dove_look")
