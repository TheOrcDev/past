extends Room
## The Gravedigger's lodge (plan 008, atlas P2): the burial register and the
## key wall. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"prologue/cemetery"
const REGISTER := preload("res://content/closeups/burial_register/burial_register.tscn")


func look_door() -> void:
	await Say.line(DIALOGUE, &"lodge_door_look")


func look_stove() -> void:
	await Say.line(DIALOGUE, &"lodge_stove_look")


func look_cot() -> void:
	await Say.line(DIALOGUE, &"lodge_cot_look")


func look_lanterns() -> void:
	await Say.line(DIALOGUE, &"lodge_lanterns_look")


func look_keys() -> void:
	await Say.line(DIALOGUE, &"keys_look")


## Key thirteen, once the register has said which key it is.
func use_keys() -> void:
	if GameState.get_flag(&"got_ossuary_key"):
		await Say.line(DIALOGUE, &"keys_done")
	elif not GameState.get_flag(&"register_read"):
		await Say.line(DIALOGUE, &"keys_unread")
	else:
		await Rooms.player.play(&"pickup_high")
		GameState.set_flag(&"got_ossuary_key")
		Inventory.add(&"ossuary_key")
		await Say.line(DIALOGUE, &"keys_take")


func look_register() -> void:
	await Closeups.open_node(REGISTER.instantiate() as Closeup, hotspots.get_node("Register") as Hotspot)
