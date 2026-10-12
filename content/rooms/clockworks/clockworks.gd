extends Room
## Inside the clock (plan 008, chapter 1 room 10): the escapement's pin goes on
## the third tooth, which only the Clockmaker's memory of his apprenticeship
## remembers (the playable memory "The apprentice"). Then the winding key turns
## it. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/tower"
const ESCAPEMENT := preload("res://content/closeups/escapement/escapement.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"clockworks_seen"):
		GameState.set_flag(&"clockworks_seen")
		await Say.line(DIALOGUE, &"clockworks_arrival")


func look_escapement() -> void:
	await Closeups.open_node(ESCAPEMENT.instantiate() as Closeup, hotspots.get_node(^"Escapement") as Hotspot)


## Unknown can't guess the pin; the clock's own past shows him.
func use_escapement() -> void:
	if GameState.get_flag(&"escapement_set"):
		await Say.line(DIALOGUE, &"escapement_done")
	elif GameState.get_flag(&"knows_escapement"):
		await Rooms.player.play(&"use")
		GameState.set_flag(&"escapement_set")
		await Say.line(DIALOGUE, &"escapement_set")
	else:
		await Say.line(DIALOGUE, &"escapement_unknown")
		var escapement := hotspots.get_node(^"Escapement") as Hotspot
		Flashback.enter_memory(&"ch1_apprentice", self, escapement.focus_point(), &"knows_escapement")


## In the past only: the master's chalk mark.
func look_chalk() -> void:
	await Say.line(DIALOGUE, &"apprentice_mark")
	await Say.line(DIALOGUE, &"apprentice_out")
	GameState.set_flag(&"knows_escapement")


func use_chalk() -> void:
	await look_chalk()


func look_apprentice_bench() -> void:
	await Say.line(DIALOGUE, &"apprentice_in")
	await Say.line(DIALOGUE, &"apprentice_bench_look")


func item_post(item: ItemDef) -> void:
	if item.id != &"winding_key":
		await Say.fallback(&"item")
		return
	if not GameState.get_flag(&"escapement_set"):
		await Say.line(DIALOGUE, &"post_slips")
		return
	await Rooms.player.play(&"use")
	Inventory.remove(&"winding_key")
	GameState.set_flag(&"clock_wound")
	await Say.line(DIALOGUE, &"post_wound")


func locked_ladder() -> void:
	await Say.line(DIALOGUE, &"ladder_up_locked")


func look_gears() -> void:
	await Say.line(DIALOGUE, &"gears_look")

func look_pendulum() -> void:
	await Say.line(DIALOGUE, &"pendulum_look")

func look_post() -> void:
	await Say.line(DIALOGUE, &"post_look")
