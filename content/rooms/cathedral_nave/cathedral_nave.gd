extends Room
## Cathedral nave (plan 002). The statue is the memory anchor: using it plays
## the flashback. Hotspot verbs are methods named <verb>_<hotspot_id>.


func use_statue() -> void:
	await Say.line(&"cathedral", &"statue_use")


func look_altar() -> void:
	await Say.line(&"cathedral", &"altar_look")


func look_rose_window() -> void:
	await Say.line(&"cathedral", &"rose_window_look")
