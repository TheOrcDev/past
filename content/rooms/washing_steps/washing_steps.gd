extends Room
## The washing steps (plan 008, chapter 2 room 4): the Washerwoman scrubs a
## shirt whose initial she can't place. Told of Aldous, she gives his key.
## Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"
const SHIRT := preload("res://content/closeups/washer_shirt/washer_shirt.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"washing_arrived"):
		GameState.set_flag(&"washing_arrived")
		await Say.line(DIALOGUE, &"washing_arrival")


func talk_washerwoman() -> void:
	await Say.line(DIALOGUE, &"washerwoman_talk")


func look_shirt() -> void:
	await Closeups.open_node(SHIRT.instantiate() as Closeup, hotspots.get_node(^"Shirt") as Hotspot)


func look_washerwoman() -> void:
	await Say.line(DIALOGUE, &"washerwoman_look")

func look_lines() -> void:
	await Say.line(DIALOGUE, &"lines_look")

func look_basket() -> void:
	await Say.line(DIALOGUE, &"basket_look")
