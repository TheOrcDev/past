extends Room
## Unknown's grave (plan 007): where the game starts, after the opening reveal.
## The gravestone opens its close-up; the path east leads to the cathedral.

## Loaded with the room, under the fade, so the push-in starts without a hitch.
const TOMBSTONE := preload("res://content/closeups/tombstone/tombstone.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"cemetery_arrived"):
		GameState.set_flag(&"cemetery_arrived")
		await Say.line(&"cemetery", &"arrival")


func look_gravestone() -> void:
	await Closeups.open_node(TOMBSTONE.instantiate() as Closeup, hotspots.get_node("Gravestone") as Hotspot)


func look_grave() -> void:
	await Say.line(&"cemetery", &"grave_look")


func look_angel() -> void:
	await Say.line(&"cemetery", &"angel_look")


func look_mausoleum() -> void:
	await Say.line(&"cemetery", &"mausoleum_look")


func look_city() -> void:
	await Say.line(&"cemetery", &"city_look")
