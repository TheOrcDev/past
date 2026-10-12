extends Room
## The theatre front (plan 008, chapter 3 room 3): chained by the Registrar's
## order, opened by the Hangman's key. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/city"
const PLAYBILL := preload("res://content/closeups/playbill/playbill.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"facade_arrived"):
		GameState.set_flag(&"facade_arrived")
		await Say.line(DIALOGUE, &"facade_arrival")


func locked_doors() -> void:
	await Say.line(DIALOGUE, &"theater_doors_chained")


func item_doors(item: ItemDef) -> void:
	if item.id != &"chain_key":
		await Say.fallback(&"item")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"chain_key")
	GameState.set_flag(&"theater_open")
	await Say.line(DIALOGUE, &"theater_doors_unchained")


func look_playbill() -> void:
	await Closeups.open_node(PLAYBILL.instantiate() as Closeup, hotspots.get_node(^"Playbill") as Hotspot)


func look_doors() -> void:
	await Say.line(DIALOGUE, &"theater_doors_look")

func look_marquee() -> void:
	await Say.line(DIALOGUE, &"marquee_look")

func look_posters() -> void:
	await Say.line(DIALOGUE, &"posters_look")
