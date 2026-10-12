extends Room
## The Hall of Records (plan 008, chapter 3 room 7): sign the visitors'
## register to go further in; the Registrar holds the office. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"


func _on_shown() -> void:
	if not GameState.get_flag(&"hall_arrived"):
		GameState.set_flag(&"hall_arrived")
		await Say.line(DIALOGUE, &"hall_arrival")


func look_register() -> void:
	await Say.line(DIALOGUE, &"register_signed" if GameState.get_flag(&"signed_in") else &"register_look3")


func use_register() -> void:
	await Say.line(DIALOGUE, &"register_signed" if GameState.get_flag(&"signed_in") else &"register_unsigned")


func item_register(item: ItemDef) -> void:
	if item.id != &"clerk_quill":
		await Say.line(DIALOGUE, &"register_unsigned")
		return
	await Rooms.player.play(&"use")
	GameState.set_flag(&"signed_in")
	await Say.line(DIALOGUE, &"register_signed")


func locked_stacks_door() -> void:
	await Say.line(DIALOGUE, &"inner_doors_unsigned")


func locked_chamber_door() -> void:
	await Say.line(DIALOGUE, &"inner_doors_unsigned")


func locked_office_door() -> void:
	await Say.line(DIALOGUE, &"office_door_locked")


func look_drawers() -> void:
	await Say.line(DIALOGUE, &"drawers_look")

func look_desks() -> void:
	await Say.line(DIALOGUE, &"desks_look")

func look_office_door() -> void:
	await Say.line(DIALOGUE, &"office_door_look")
