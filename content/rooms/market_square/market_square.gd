extends Room
## The market square (plan 008, chapter 1 room 4): the weeping saint's ribbon
## holds the Lamplighter's memory of his daughter's wedding. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"


func _on_shown() -> void:
	if not GameState.get_flag(&"market_arrived"):
		GameState.set_flag(&"market_arrived")
		await Say.line(DIALOGUE, &"market_arrival")


func look_ribbon() -> void:
	await Say.line(DIALOGUE, &"saint_look")


func use_ribbon() -> void:
	await Say.line(DIALOGUE, &"ribbon_use")
	if not &"ch1_wedding" in GameState.memories:
		await Cutscenes.play(rewatch_ch1_wedding())


## The ribbon's vision, for touching it and for watching it again.
func rewatch_ch1_wedding() -> Vision:
	var ribbon := hotspots.get_node(^"Ribbon") as Hotspot
	return Vision.new(&"ch1_wedding", self, ribbon.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch1/streets", &"wedding_return")
		await c.wait(1.0))


func look_window() -> void:
	await Say.line(DIALOGUE, &"pawn_door_look")

func look_saint() -> void:
	await Say.line(DIALOGUE, &"saint_look")

func look_fountain() -> void:
	await Say.line(DIALOGUE, &"fountain_look")

func look_stalls() -> void:
	await Say.line(DIALOGUE, &"stalls_look")
