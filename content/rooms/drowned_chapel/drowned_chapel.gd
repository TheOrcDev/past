extends Room
## The drowned chapel (plan 008, chapter 2 room 6): the altar remembers the
## Plague Doctor's oath. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/aqueduct"


func _on_shown() -> void:
	if not GameState.get_flag(&"chapel_arrived"):
		GameState.set_flag(&"chapel_arrived")
		await Say.line(DIALOGUE, &"chapel_arrival")


func use_altar() -> void:
	await Say.line(DIALOGUE, &"altar_use")
	if not &"ch2_oath" in GameState.memories:
		await Cutscenes.play(rewatch_ch2_oath())
	GameState.set_flag(&"oath_seen")


func look_altar() -> void:
	await Say.line(DIALOGUE, &"altar_look")

func look_pews() -> void:
	await Say.line(DIALOGUE, &"pews_look")

func look_window() -> void:
	await Say.line(DIALOGUE, &"chapel_window_look")


## The altar's vision, for touching it and for watching it again.
func rewatch_ch2_oath() -> Vision:
	var anchor := hotspots.get_node(^"Altar") as Hotspot
	return Vision.new(&"ch2_oath", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch2/aqueduct", &"oath_return")
		await c.wait(1.0))
