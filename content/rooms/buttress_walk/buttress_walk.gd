extends Room
## The flying buttresses (plan 008, chapter 4 room 2): the loose stone fills
## the gap. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"


func _on_shown() -> void:
	if not GameState.get_flag(&"buttress_arrived"):
		GameState.set_flag(&"buttress_arrived")
		await Say.line(DIALOGUE, &"buttress_arrival")


func locked_gap() -> void:
	await Say.line(DIALOGUE, &"buttress_gap_blocked")


func item_gap(item: ItemDef) -> void:
	if item.id != &"loose_stone":
		await Say.line(DIALOGUE, &"buttress_gap_blocked")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"loose_stone")
	GameState.set_flag(&"buttress_bridged")
	await Say.line(DIALOGUE, &"buttress_gap_bridged")


func look_gap() -> void:
	await Say.line(DIALOGUE, &"buttress_gap_look")

func look_wall() -> void:
	await Say.line(DIALOGUE, &"cathedral_wall_look")
