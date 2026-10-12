extends Room
## The gate of the Hall of Records (plan 008, chapter 3 room 6): its lock is
## the Magistrate's seal, and the ring turns it. Hotspot verbs are methods
## named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"


func _on_shown() -> void:
	if not GameState.get_flag(&"records_gate_arrived"):
		GameState.set_flag(&"records_gate_arrived")
		await Say.line(DIALOGUE, &"gate_arrival3")


func locked_gate() -> void:
	await Say.line(DIALOGUE, &"records_gate_sealed")


func item_gate(item: ItemDef) -> void:
	if item.id != &"seal_ring":
		await Say.fallback(&"item")
		return
	await Rooms.player.play(&"use")
	GameState.set_flag(&"records_gate_open")
	await Say.line(DIALOGUE, &"records_gate_open")


func look_gate() -> void:
	await Say.line(DIALOGUE, &"records_gate_look")

func look_clerks() -> void:
	await Say.line(DIALOGUE, &"clerks_look")

func look_windows() -> void:
	await Say.line(DIALOGUE, &"windows_look")
