extends Room
## Cathedral nave (plan 002). The statue is the memory anchor: using it plays
## the flashback. Hotspot verbs are methods named <verb>_<hotspot_id>.


func use_statue() -> void:
	await Say.line(&"cathedral", &"statue_use")
	var statue := hotspots.get_node("Statue") as Hotspot
	await Flashback.vision(self, statue.focus_point(), func() -> void:
		await get_tree().create_timer(1.5).timeout
		await Say.line(&"cathedral", &"statue_return")
		await get_tree().create_timer(1.5).timeout)
	GameState.remember(&"cathedral_statue")


func look_altar() -> void:
	await Say.line(&"cathedral", &"altar_look")


func look_rose_window() -> void:
	await Say.line(&"cathedral", &"rose_window_look")
