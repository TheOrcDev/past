extends Room
## The cathedral square (plan 008, chapter 1 room 1): where the great doors
## open onto the old town, and the Crier cries news from the night time
## stopped. docs/story/ch1-puzzles.md. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"


func _on_shown() -> void:
	if not GameState.get_flag(&"ch1_arrived"):
		GameState.set_flag(&"ch1_arrived")
		await Say.line(DIALOGUE, &"parvis_arrival")


func talk_crier() -> void:
	await Say.line(DIALOGUE, &"crier_talk")


func look_crier() -> void:
	await Say.line(DIALOGUE, &"crier_look")

func look_platform() -> void:
	await Say.line(DIALOGUE, &"platform_look")

func look_trough() -> void:
	await Say.line(DIALOGUE, &"trough_look")

func look_tower_far() -> void:
	await Say.line(DIALOGUE, &"tower_far_look")
