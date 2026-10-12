extends Room
## The covered bridge (plan 008, chapter 3 room 12): on to the cathedral's
## heights (chapter 4), or the chapter's card in a build without it. Hotspot
## verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"


func _on_shown() -> void:
	if not GameState.get_flag(&"bridge3_arrived"):
		GameState.set_flag(&"bridge3_arrived")
		await Say.line(DIALOGUE, &"bridge3_arrival")


func use_far_door() -> void:
	GameState.set_flag(&"ch3_done")
	if Chapters.in_build(&"cathedral_roof"):
		Rooms.goto.call_deferred(&"cathedral_roof", &"from_bridge", &"fade")
		return
	await Cutscenes.play(StepsCutscene.new(&"ch3_end", func(c: CutsceneSteps) -> void:
		await c.fade(1.0, 1.5)
		var card := EndCard.new("THE HALL OF RECORDS", "Above the city, the Registrar waits with the book.")
		get_tree().root.add_child(card)
		card.fade_in()
		await c.wait(5.5)
		card.queue_free()
		await c.fade(0.0, 1.0)))


func look_windows() -> void:
	await Say.line(DIALOGUE, &"bridge_windows_look")

func look_banners() -> void:
	await Say.line(DIALOGUE, &"banners3_look")

func look_far_door() -> void:
	await Say.line(DIALOGUE, &"far_door_look")
