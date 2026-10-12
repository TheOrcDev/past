extends Room
## The stacks (plan 008, chapter 3 room 8): the index of names, where the
## Dove's entry says she was struck at the Magistrate's own desk. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"
const INDEX := preload("res://content/closeups/ledger_index/ledger_index.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"stacks_arrived"):
		GameState.set_flag(&"stacks_arrived")
		await Say.line(DIALOGUE, &"stacks_arrival")


func look_lectern() -> void:
	await Closeups.open_node(INDEX.instantiate() as Closeup, hotspots.get_node(^"Lectern") as Hotspot)


func look_ledgers() -> void:
	await Say.line(DIALOGUE, &"ledgers_look")

func look_moths() -> void:
	await Say.line(DIALOGUE, &"moths_look")
