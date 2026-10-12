extends Room
## The hospice on stilts (plan 008, chapter 2 room 7): the Plague Doctor lends
## her stretcher once Unknown gives her back her oath. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/aqueduct"
const CHART := preload("res://content/closeups/hospice_chart/hospice_chart.tscn")


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"hospice_arrived"):
		GameState.set_flag(&"hospice_arrived")
		await Say.line(DIALOGUE, &"hospice_arrival")


func talk_doctor() -> void:
	await Say.line(DIALOGUE, &"doctor_talk")
	_show_state()


func look_stretcher() -> void:
	await Say.line(DIALOGUE, &"stretcher_gone" if Inventory.has(&"stretcher") or GameState.get_flag(&"span_bridged") else &"stretcher_look")


func use_stretcher() -> void:
	await Say.line(DIALOGUE, &"stretcher_gone" if GameState.get_flag(&"doctor_told") else &"stretcher_ask")


func look_chart() -> void:
	await Closeups.open_node(CHART.instantiate() as Closeup, hotspots.get_node(^"Chart") as Hotspot)



func look_doctor() -> void:
	await Say.line(DIALOGUE, &"doctor_look")


func look_cots() -> void:
	await Say.line(DIALOGUE, &"cots_look")


func look_herbs() -> void:
	await Say.line(DIALOGUE, &"herbs_look")


## The stretcher leaves its wall once the doctor lends it.
func _show_state() -> void:
	var stretcher := layers.get_node_or_null(^"Now/Stretcher") as CanvasItem
	if stretcher:
		stretcher.visible = not GameState.get_flag(&"doctor_told")
