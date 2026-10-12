extends Room
## The drowned forest (plan 008, chapter 2 room 8), on the way to the aqueduct.
## Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"


func _on_shown() -> void:
	if not GameState.get_flag(&"forest_arrived"):
		GameState.set_flag(&"forest_arrived")
		await Say.line(DIALOGUE, &"forest_arrival")


func look_trees() -> void:
	await Say.line(DIALOGUE, &"trees_look")

func look_arches() -> void:
	await Say.line(DIALOGUE, &"arches_look")
