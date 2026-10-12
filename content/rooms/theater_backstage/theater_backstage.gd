extends Room
## Backstage (plan 008, chapter 3 room 5): three puppets, and the clerk's real
## quill, which the Puppeteer lets Unknown take after her show. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/city"


func _on_shown() -> void:
	if not GameState.get_flag(&"backstage_arrived"):
		GameState.set_flag(&"backstage_arrived")
		await Say.line(DIALOGUE, &"backstage_arrival")


func look_clerk() -> void:
	await Say.line(DIALOGUE, &"puppet_clerk_empty" if GameState.get_flag(&"got_quill") else &"puppet_clerk_look")


func use_clerk() -> void:
	if GameState.get_flag(&"got_quill"):
		await Say.line(DIALOGUE, &"puppet_clerk_empty")
	elif not GameState.get_flag(&"saw_show"):
		await Say.line(DIALOGUE, &"puppet_clerk_use")
	else:
		await Rooms.player.play(&"use")
		GameState.set_flag(&"got_quill")
		Inventory.add(&"clerk_quill")
		await Say.line(DIALOGUE, &"puppet_clerk_take")


func look_magistrate() -> void:
	await Say.line(DIALOGUE, &"puppet_magistrate_look")

func look_dove() -> void:
	await Say.line(DIALOGUE, &"puppet_dove_look")

func look_ropes() -> void:
	await Say.line(DIALOGUE, &"ropes_look")

func look_trapdoor() -> void:
	await Say.line(DIALOGUE, &"trapdoor_look")
