extends Room
## The bell stair (plan 008, chapter 4 room 7). Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"


func _on_shown() -> void:
	if not GameState.get_flag(&"stair4_arrived"):
		GameState.set_flag(&"stair4_arrived")
		await Say.line(DIALOGUE, &"stair_arrival4")


func look_ropes() -> void:
	await Say.line(DIALOGUE, &"ropes4_look")


func look_up() -> void:
	await Say.line(DIALOGUE, &"stair_up_look4")


func look_door() -> void:
	await Say.line(DIALOGUE, &"stair_down_look4")
