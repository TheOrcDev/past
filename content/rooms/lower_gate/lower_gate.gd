extends Room
## The lower gate (plan 008, chapter 1 room 12): wound to the clock, it opens
## when the hour strikes, onto chapter 2's drowned quarter (or, in a build
## without chapter 2, the chapter's closing card). Hotspot verbs are methods
## named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/tower"


func _on_shown() -> void:
	if not GameState.get_flag(&"lower_arrived"):
		GameState.set_flag(&"lower_arrived")
		await Say.line(DIALOGUE, &"lower_gate_arrival")


func use_portcullis() -> void:
	if not GameState.get_flag(&"lower_gate_open"):
		await Say.line(DIALOGUE, &"portcullis_shut")
		return
	GameState.set_flag(&"ch1_done")
	if Chapters.in_build(&"flooded_stair"):
		Rooms.goto.call_deferred(&"flooded_stair", &"from_gate", &"fade")
		return
	await Cutscenes.play(StepsCutscene.new(&"ch1_end", func(c: CutsceneSteps) -> void:
		await c.fade(1.0, 1.5)
		var card := EndCard.new("THE NAMELESS STREETS", "Below the gate, the drowned quarter waits.")
		get_tree().root.add_child(card)
		card.fade_in()
		await c.wait(5.5)
		card.queue_free()
		await c.fade(0.0, 1.0)))


func look_portcullis() -> void:
	await Say.line(DIALOGUE, &"portcullis_look")

func look_chain() -> void:
	await Say.line(DIALOGUE, &"chain_look")
