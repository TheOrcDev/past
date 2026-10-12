extends Room
## The cathedral roof (plan 008, chapter 4 room 1): the heights' reveal, and
## a loose stone. docs/story/ch4-puzzles.md. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"
const REVEAL := preload("res://content/cutscenes/heights_reveal/heights_reveal.tscn")


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"ch4_arrived"):
		GameState.set_flag(&"ch4_arrived")
		await Cutscenes.play(rewatch_heights_reveal())
		await Say.line(DIALOGUE, &"roof_arrival")


func rewatch_heights_reveal() -> RevealCutscene:
	return RevealCutscene.new(&"heights_reveal", REVEAL)


func use_stone() -> void:
	if GameState.get_flag(&"got_stone"):
		await Say.line(DIALOGUE, &"stone_look")
		return
	await Rooms.player.play(&"pickup_low")
	GameState.set_flag(&"got_stone")
	Inventory.add(&"loose_stone")
	_show_state()
	await Say.line(DIALOGUE, &"stone_take")


func _show_state() -> void:
	for node: CanvasItem in [hotspots.get_node_or_null(^"Stone"), layers.get_node_or_null(^"Now/Stone")]:
		if node:
			node.visible = not GameState.get_flag(&"got_stone")


func look_stone() -> void:
	await Say.line(DIALOGUE, &"stone_look")

func look_city() -> void:
	await Say.line(DIALOGUE, &"ridge_city_look")

func look_belfry() -> void:
	await Say.line(DIALOGUE, &"belfry_far_look")
