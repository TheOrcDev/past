extends Room
## The gargoyle gallery (plan 008, chapter 4 room 3): the dovecote key in a
## gargoyle's jaws. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"gallery_arrived"):
		GameState.set_flag(&"gallery_arrived")
		await Say.line(DIALOGUE, &"gallery_arrival")


func use_key_gargoyle() -> void:
	if GameState.get_flag(&"got_dovecote_key"):
		await Say.line(DIALOGUE, &"key_gargoyle_empty")
		return
	await Rooms.player.play(&"pickup_high")
	GameState.set_flag(&"got_dovecote_key")
	Inventory.add(&"dovecote_key")
	_show_state()
	await Say.line(DIALOGUE, &"key_gargoyle_take")


func look_key_gargoyle() -> void:
	await Say.line(DIALOGUE, &"key_gargoyle_empty" if GameState.get_flag(&"got_dovecote_key") else &"key_gargoyle_look")


func _show_state() -> void:
	pass


func look_gargoyles() -> void:
	await Say.line(DIALOGUE, &"gargoyles_look")
