extends Room
## Behind the clock face (plan 008, chapter 1 room 11): set to eleven, the
## clock strikes once, the old town shows itself as it was (the memory vista
## "The old town"), and the lower gate opens. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/tower"


func _on_shown() -> void:
	if not GameState.get_flag(&"face_arrived"):
		GameState.set_flag(&"face_arrived")
		await Say.line(DIALOGUE, &"face_arrival")


func use_hands() -> void:
	if GameState.get_flag(&"clock_struck"):
		await Say.line(DIALOGUE, &"hands_done")
	elif not GameState.get_flag(&"knows_eleven"):
		await Say.line(DIALOGUE, &"hands_unknown")
	else:
		await Rooms.player.play(&"use")
		await Say.line(DIALOGUE, &"hands_set")
		await Cutscenes.play(rewatch_ch1_old_town())
		GameState.set_flag(&"clock_struck")
		GameState.set_flag(&"lower_gate_open")


## The strike's memory vista, for setting the hands and for watching it again.
func rewatch_ch1_old_town() -> Vision:
	var hands := hotspots.get_node(^"Hands") as Hotspot
	return Vision.new(&"ch1_old_town", self, hands.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(2.0)
		await c.say(&"ch1/tower", &"old_town_return")
		await c.wait(1.5))


func look_hands() -> void:
	await Say.line(DIALOGUE, &"hands_look")

func look_glass() -> void:
	await Say.line(DIALOGUE, &"glass_look")
