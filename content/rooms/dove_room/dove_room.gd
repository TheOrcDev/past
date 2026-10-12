extends Room
## The Dove's room (plan 008, chapter 4 room 5): the only present-day room
## with a trace of color, and the letter Ulric never sent. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"
const LETTER := preload("res://content/closeups/unsent_letter/unsent_letter.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"dove_room_arrived"):
		GameState.set_flag(&"dove_room_arrived")
		await Say.line(DIALOGUE, &"dove_room_arrival")


func look_desk() -> void:
	if GameState.get_flag(&"got_letter"):
		await Say.line(DIALOGUE, &"desk4_empty")
	else:
		await Closeups.open_node(LETTER.instantiate() as Closeup, hotspots.get_node(^"Desk") as Hotspot)


func use_desk() -> void:
	if GameState.get_flag(&"got_letter"):
		await Say.line(DIALOGUE, &"desk4_empty")
		return
	await Rooms.player.play(&"use")
	GameState.set_flag(&"got_letter")
	Inventory.add(&"unsent_letter")
	await Say.line(DIALOGUE, &"desk4_take")


func look_banner() -> void:
	await Say.line(DIALOGUE, &"banner_look")

func look_keepsakes() -> void:
	await Say.line(DIALOGUE, &"keepsakes_look")

func look_bed() -> void:
	await Say.line(DIALOGUE, &"bed_look")
