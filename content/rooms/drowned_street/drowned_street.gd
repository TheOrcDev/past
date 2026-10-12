extends Room
## The drowned street (plan 008, chapter 2 room 3): the floating crate goes
## under the sluice house window; the rooftops lead to the chapel. Hotspot
## verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"street_arrived"):
		GameState.set_flag(&"street_arrived")
		await Say.line(DIALOGUE, &"street_arrival")


func use_crate() -> void:
	await Rooms.player.play(&"pickup_low")
	GameState.set_flag(&"got_crate")
	Inventory.add(&"crate")
	_show_state()
	await Say.line(DIALOGUE, &"crate_take")


func locked_window() -> void:
	await Say.line(DIALOGUE, &"window_high")


func item_window(item: ItemDef) -> void:
	if item.id != &"crate":
		await Say.fallback(&"item")
		return
	Inventory.remove(&"crate")
	GameState.set_flag(&"crate_set")
	await Say.line(DIALOGUE, &"crate_set")


func _show_state() -> void:
	var taken := bool(GameState.get_flag(&"got_crate"))
	for node: CanvasItem in [hotspots.get_node_or_null(^"Crate"), layers.get_node_or_null(^"Now/Crate")]:
		if node:
			node.visible = not taken


func look_crate() -> void:
	await Say.line(DIALOGUE, &"crate_look")

func look_window() -> void:
	await Say.line(DIALOGUE, &"window_look")

func look_sluice_door() -> void:
	await Say.line(DIALOGUE, &"sluice_door_look")

func look_shutters() -> void:
	await Say.line(DIALOGUE, &"shutters_look")

func look_rooftops() -> void:
	await Say.line(DIALOGUE, &"rooftops_look")
