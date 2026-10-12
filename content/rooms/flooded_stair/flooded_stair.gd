extends Room
## The flooded stair (plan 008, chapter 2 room 1): the drowned quarter's
## reveal, and the bell that calls the ferry. docs/story/ch2-puzzles.md.
## Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"
const REVEAL := preload("res://content/cutscenes/drowned_quarter_reveal/drowned_quarter_reveal.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"ch2_arrived"):
		GameState.set_flag(&"ch2_arrived")
		await Cutscenes.play(rewatch_drowned_quarter_reveal())
		await Say.line(DIALOGUE, &"stair_arrival")


func rewatch_drowned_quarter_reveal() -> RevealCutscene:
	return RevealCutscene.new(&"drowned_quarter_reveal", REVEAL)


func use_bell() -> void:
	if GameState.get_flag(&"ferry_called"):
		await Say.line(DIALOGUE, &"bell_again")
		return
	await Rooms.player.play(&"use")
	GameState.set_flag(&"ferry_called")
	await Say.line(DIALOGUE, &"bell_ring")


func locked_quay() -> void:
	await Say.line(DIALOGUE, &"quay_unrung")


func look_bell() -> void:
	await Say.line(DIALOGUE, &"bell_look")

func look_water() -> void:
	await Say.line(DIALOGUE, &"water_look")

func look_roofs() -> void:
	await Say.line(DIALOGUE, &"roofs_look")

func look_upstairs() -> void:
	await Say.line(DIALOGUE, &"upstairs_look")

func look_quay() -> void:
	await Say.line(DIALOGUE, &"quay_look")
