extends Room
## The vault (plan 008, chapter 3 room 11): an empty lectern; the Registrar has
## taken the Ledger toward the cathedral. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"
const LECTERN := preload("res://content/closeups/vault_lectern/vault_lectern.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"vault_arrived"):
		GameState.set_flag(&"vault_arrived")
		await Say.line(DIALOGUE, &"vault_arrival")


func look_lectern() -> void:
	await Closeups.open_node(LECTERN.instantiate() as Closeup, hotspots.get_node(^"Lectern") as Hotspot)


func look_passage() -> void:
	await Say.line(DIALOGUE, &"arch_door_look")


func look_vault_door() -> void:
	await Say.line(DIALOGUE, &"vault_back_look")
