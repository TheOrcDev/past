extends Room
## On the aqueduct (plan 008, chapter 2 room 10): the stretcher bridges the
## broken span, the ring unseals the valve house door, and the view is the
## quarter's memory vista. The door's walk-to stays on the near side of the
## gap. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/aqueduct"


func _on_shown() -> void:
	if not GameState.get_flag(&"channel_arrived"):
		GameState.set_flag(&"channel_arrived")
		await Say.line(DIALOGUE, &"channel_arrival")


func look_gap() -> void:
	await Say.line(DIALOGUE, &"gap_bridged" if GameState.get_flag(&"span_bridged") else &"gap_look")


func item_gap(item: ItemDef) -> void:
	if item.id != &"stretcher":
		await Say.line(DIALOGUE, &"gap_blocked")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"stretcher")
	GameState.set_flag(&"span_bridged")
	await Say.line(DIALOGUE, &"gap_bridged")


func locked_valve_door() -> void:
	await Say.line(DIALOGUE, &"valve_door_sealed" if GameState.get_flag(&"span_bridged") else &"gap_blocked")


func item_valve_door(item: ItemDef) -> void:
	if not GameState.get_flag(&"span_bridged"):
		await Say.line(DIALOGUE, &"gap_blocked")
	elif item.id != &"seal_ring":
		await Say.fallback(&"item")
	else:
		await Rooms.player.play(&"use")
		GameState.set_flag(&"valve_door_open")
		await Say.line(DIALOGUE, &"valve_door_open")


func use_view() -> void:
	await Say.line(DIALOGUE, &"view_use")
	if not &"ch2_quarter" in GameState.memories:
		await Cutscenes.play(rewatch_ch2_quarter())



func look_valve_door() -> void:
	await Say.line(DIALOGUE, &"valve_door_look")

func look_view() -> void:
	await Say.line(DIALOGUE, &"view_look")


## The view's vision, for touching it and for watching it again.
func rewatch_ch2_quarter() -> Vision:
	var anchor := hotspots.get_node(^"View") as Hotspot
	return Vision.new(&"ch2_quarter", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch2/aqueduct", &"quarter_return")
		await c.wait(1.5))
