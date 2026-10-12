extends Room
## The cathedral square (plan 008, chapter 1 room 1): where the great doors
## open onto the old town, and the Crier cries news from the night time
## stopped. docs/story/ch1-puzzles.md. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"
const REVEAL := preload("res://content/cutscenes/old_town_reveal/old_town_reveal.tscn")


## The first arrival plays the old town's discovery reveal (game-design.md §7).
func _on_shown() -> void:
	if not GameState.get_flag(&"ch1_arrived"):
		GameState.set_flag(&"ch1_arrived")
		await Cutscenes.play(rewatch_old_town_reveal())
		await Say.line(DIALOGUE, &"parvis_arrival")


func rewatch_old_town_reveal() -> RevealCutscene:
	return RevealCutscene.new(&"old_town_reveal", REVEAL)


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
