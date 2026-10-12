extends Room
## The clock tower square (plan 008, chapter 1 room 9): the Clockmaker keeps
## a stopped clock ready. The tower door is too dark to enter without Mathis's
## warm lamp. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/tower"


func _on_shown() -> void:
	if not GameState.get_flag(&"tower_arrived"):
		GameState.set_flag(&"tower_arrived")
		await Say.line(DIALOGUE, &"tower_arrival")


func talk_clockmaker() -> void:
	await Say.line(DIALOGUE, &"clockmaker_talk")


func locked_tower_door() -> void:
	await Say.line(DIALOGUE, &"tower_door_dark")


func look_clock() -> void:
	await Say.line(DIALOGUE, &"clock_struck_look" if GameState.get_flag(&"clock_struck") else &"clock_look")


func look_clockmaker() -> void:
	await Say.line(DIALOGUE, &"clockmaker_look")

func look_tower_door() -> void:
	await Say.line(DIALOGUE, &"tower_door_look")

func look_workbench() -> void:
	await Say.line(DIALOGUE, &"workbench_look")
