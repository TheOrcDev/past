extends Room
## Cathedral nave (plan 002). The statue is the memory anchor: using it plays
## the flashback. Hotspot verbs are methods named <verb>_<hotspot_id>.


func _on_enter(_from: StringName) -> void:
	GameState.set_flag(&"cathedral_visited")


func use_statue() -> void:
	await Say.line(&"cathedral", &"statue_use")
	await Cutscenes.play(rewatch_cathedral_statue())


## The statue's vision, for using the statue and for watching it again from
## the journal.
func rewatch_cathedral_statue() -> Vision:
	var statue := hotspots.get_node("Statue") as Hotspot
	return Vision.new(&"cathedral_statue", self, statue.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"cathedral", &"statue_return")
		await c.wait(1.5))


func look_statue() -> void:
	await Say.line(&"cathedral", &"statue_look")


func look_altar() -> void:
	await Say.line(&"cathedral", &"altar_look")


func look_rose_window() -> void:
	await Say.line(&"cathedral", &"rose_window_look")
