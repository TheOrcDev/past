extends Room
## The street of lamps (plan 008, chapter 1 room 2): the Lamplighter, whose
## flame won't warm until the bride's candle lights it. Then he remembers he's
## Mathis, and the street keeps its warm light. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"


func _on_enter(_from: StringName) -> void:
	_show_lamps()


func talk_lamplighter() -> void:
	await Say.line(DIALOGUE, &"lamplighter_talk")


## The wedding candle warms his flame, and he knows the memory as his own.
func item_lamplighter(item: ItemDef) -> void:
	if item.id != &"wedding_candle":
		await Say.line(DIALOGUE, &"lamplighter_other")
		return
	Inventory.remove(&"wedding_candle")
	var lamplighter := actors.get_node_or_null(^"Lamplighter") as Actor
	if lamplighter:
		lamplighter.play(&"light_lamp")
	await Say.line(DIALOGUE, &"lamplighter_candle")
	GameState.set_flag(&"mathis_named")
	GameState.learn(&"memories_not_mine")
	Inventory.add(&"warm_lamp")
	_show_lamps()
	await Say.line(DIALOGUE, &"lamplighter_after")


func look_lamps() -> void:
	await Say.line(DIALOGUE, &"lamps_warm_look" if GameState.get_flag(&"mathis_named") else &"lamps_look")


func use_lamps() -> void:
	await Say.line(DIALOGUE, &"lamps_warm_look" if GameState.get_flag(&"mathis_named") else &"lamps_use")


## Once Mathis is named, his street keeps its warm light in the present.
func _show_lamps() -> void:
	var warm := bool(GameState.get_flag(&"mathis_named"))
	for node_name in [^"Layers/Now/WarmLamps", ^"Layers/Now/WarmMotes"]:
		var node := get_node_or_null(node_name) as CanvasItem
		if node:
			node.visible = warm


func look_lamplighter() -> void:
	await Say.line(DIALOGUE, &"lamplighter_look")

func look_shops() -> void:
	await Say.line(DIALOGUE, &"shops_look")
