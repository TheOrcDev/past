extends Room
## The Broker's shop (plan 008, chapter 1 room 5): the Clockmaker's pawned
## winding key, for a lantern with a story in it, and the seal ring in the
## cabinet that fits Unknown's hand. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/tower"
const CABINET := preload("res://content/closeups/seal_cabinet/seal_cabinet.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"pawn_arrived"):
		GameState.set_flag(&"pawn_arrived")
		await Say.line(DIALOGUE, &"pawn_arrival")


func talk_broker() -> void:
	await Say.line(DIALOGUE, &"broker_talk")


## The Gravedigger's lantern, mended for a stranger, buys the winding key.
func item_broker(item: ItemDef) -> void:
	if item.id != &"lantern":
		await Say.line(DIALOGUE, &"broker_other")
		return
	Inventory.remove(&"lantern")
	var broker := actors.get_node_or_null(^"Broker") as Actor
	if broker:
		broker.play(&"weigh")
	await Say.line(DIALOGUE, &"broker_lantern")
	GameState.set_flag(&"got_winding_key")
	Inventory.add(&"winding_key")


func look_cabinet() -> void:
	await Closeups.open_node(CABINET.instantiate() as Closeup, hotspots.get_node(^"Cabinet") as Hotspot)


func look_broker() -> void:
	await Say.line(DIALOGUE, &"broker_look")

func look_clocks() -> void:
	await Say.line(DIALOGUE, &"shop_clocks_look")

func look_portraits() -> void:
	await Say.line(DIALOGUE, &"portraits_look")

func look_scale() -> void:
	await Say.line(DIALOGUE, &"scale_look")
