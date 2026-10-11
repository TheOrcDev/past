extends Room
## The greybox chapel (plan 004 slice 11). The oil flask sits on the shelf, and
## the altar's carving has burned away. Touching the altar shows the past, where
## the word of the house is still carved.


func _on_enter(_from: StringName) -> void:
	_show_state()


func look_altar() -> void:
	await Say.line(&"greybox", &"altar_look")


func use_altar() -> void:
	await Say.line(&"greybox", &"altar_touch")
	var altar := hotspots.get_node(^"Altar") as Hotspot
	await Flashback.vision(&"greybox_altar", self, altar.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.0)
		await c.say(&"greybox", &"altar_past")
		await c.wait(1.0))
	GameState.set_flag(&"greybox_knows_word")


func look_flask() -> void:
	await Say.line(&"greybox", &"flask_look_shelf")


func use_flask() -> void:
	await Rooms.player.play(&"pickup_high")
	Inventory.add(&"oil")
	GameState.set_flag(&"greybox_oil_taken")
	_show_state()
	await Say.line(&"greybox", &"flask_take")


func look_window() -> void:
	await Say.line(&"greybox", &"window_look")


func _show_state() -> void:
	var taken := bool(GameState.get_flag(&"greybox_oil_taken"))
	layers.get_node(^"Now/Flask").visible = not taken
	hotspots.get_node(^"Flask").visible = not taken
