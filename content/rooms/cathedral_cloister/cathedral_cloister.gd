extends Room
## The cathedral cloister (plan 008, atlas P4): the Sister, who holds the key
## to the great doors, and the turret stair to the choir loft, too dark to
## climb without the Gravedigger's lantern. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"prologue/cathedral"


func _on_shown() -> void:
	if not GameState.get_flag(&"cloister_arrived"):
		GameState.set_flag(&"cloister_arrived")
		await Say.line(DIALOGUE, &"cloister_arrival")


func look_sister() -> void:
	await Say.line(DIALOGUE, &"sister_look")


func talk_sister() -> void:
	await Say.line(DIALOGUE, &"sister_talk")


## The dove's hymn book earns the west door key.
func item_sister(item: ItemDef) -> void:
	if item.id != &"hymn_book":
		await Say.line(DIALOGUE, &"sister_other")
		return
	Inventory.remove(&"hymn_book")
	await Say.line(DIALOGUE, &"sister_book")
	var sister := actors.get_node_or_null("Sister") as Actor
	if sister:
		sister.play(&"conduct")
	GameState.set_flag(&"got_west_door_key")
	Inventory.add(&"west_door_key")


func look_doorway() -> void:
	await Say.line(DIALOGUE, &"doorway_look")


func look_turret() -> void:
	await Say.line(DIALOGUE, &"turret_look")


func locked_turret() -> void:
	await Say.line(DIALOGUE, &"turret_dark")


func look_well() -> void:
	await Say.line(DIALOGUE, &"well_look")


func look_sundial() -> void:
	await Say.line(DIALOGUE, &"sundial_look")


func look_roses() -> void:
	await Say.line(DIALOGUE, &"roses_look")
