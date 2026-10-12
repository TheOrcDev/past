extends Room
## The lamplighter's shed (plan 008, chapter 1 room 3): walls of tally marks,
## one for every name he can't remember. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"
const LEDGER := preload("res://content/closeups/lamp_ledger/lamp_ledger.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"shed_seen"):
		GameState.set_flag(&"shed_seen")
		await Say.line(DIALOGUE, &"shed_arrival")


func look_tallies() -> void:
	await Closeups.open_node(LEDGER.instantiate() as Closeup, hotspots.get_node(^"Tallies") as Hotspot)


func look_oil() -> void:
	await Say.line(DIALOGUE, &"oil_look")

func look_wicks() -> void:
	await Say.line(DIALOGUE, &"wicks_look")

func look_bench() -> void:
	await Say.line(DIALOGUE, &"bench_shed_look")
