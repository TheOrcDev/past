extends Room
## The bell chamber (plan 008, chapter 4 room 8): the Registrar with the
## Ledger. Given his own name back, he lets go of the book. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/finale"
const PAGE := preload("res://content/closeups/ledger_page/ledger_page.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"bell_chamber_arrived"):
		GameState.set_flag(&"bell_chamber_arrived")
		await Say.line(DIALOGUE, &"chamber_arrival4")


func talk_registrar() -> void:
	await Say.line(DIALOGUE, &"registrar4_talk")
	if GameState.get_flag(&"registrar_named"):
		GameState.set_flag(&"got_ledger")
		GameState.learn(&"edmund")


func locked_ladder() -> void:
	await Say.line(DIALOGUE, &"ladder_up4_blocked")


## Once named, Edmund holds the Ledger open: its first page, close.
func look_registrar() -> void:
	if GameState.get_flag(&"registrar_named"):
		await Closeups.open_node(PAGE.instantiate() as Closeup, hotspots.get_node(^"Registrar") as Hotspot)
	else:
		await Say.line(DIALOGUE, &"registrar4_look")


func look_bells() -> void:
	await Say.line(DIALOGUE, &"bells_look")
