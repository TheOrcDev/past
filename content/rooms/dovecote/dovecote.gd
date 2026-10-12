extends Room
## The dovecote (plan 008, chapter 4 room 4): the Dove, Elise. She forgives
## him for the letter he never sent, and the tower opens. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"dovecote_arrived"):
		GameState.set_flag(&"dovecote_arrived")
		await Say.line(DIALOGUE, &"dovecote_arrival")


func talk_dove() -> void:
	await Say.line(DIALOGUE, &"dove_talk")


func item_dove(item: ItemDef) -> void:
	if item.id != &"unsent_letter":
		await Say.line(DIALOGUE, &"dove_other")
		return
	Inventory.remove(&"unsent_letter")
	var dove := actors.get_node_or_null(^"Dove") as Actor
	if dove:
		dove.play(&"release_dove")
	await Say.line(DIALOGUE, &"dove_letter")
	GameState.set_flag(&"dove_forgave")
	GameState.learn(&"elise")


func look_door() -> void:
	await Say.line(DIALOGUE, &"dovecote_door_look")


## The key opens the dovecote, and she steps out.
func item_door(item: ItemDef) -> void:
	if item.id != &"dovecote_key":
		await Say.fallback(&"item")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"dovecote_key")
	GameState.set_flag(&"dovecote_open")
	_show_state()
	await Say.line(DIALOGUE, &"dovecote_door_open")


func locked_trapdoor() -> void:
	await Say.line(DIALOGUE, &"trapdoor4_locked")


func locked_tower_door() -> void:
	await Say.line(DIALOGUE, &"tower_door4_locked")


## She stands outside once the dovecote is open.
func _show_state() -> void:
	var out := bool(GameState.get_flag(&"dovecote_open"))
	for node: CanvasItem in [actors.get_node_or_null(^"Dove"), hotspots.get_node_or_null(^"Dove")]:
		if node:
			node.visible = out


func look_dove() -> void:
	await Say.line(DIALOGUE, &"dove_look")

func look_doves() -> void:
	await Say.line(DIALOGUE, &"doves_look")

func look_trapdoor() -> void:
	await Say.line(DIALOGUE, &"trapdoor4_look")

func look_tower_door() -> void:
	await Say.line(DIALOGUE, &"tower_door4_look")
