extends Room
## The canal bridge (plan 008, chapter 1 room 6), between the market and the
## clock tower. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"


func look_bridge() -> void:
	await Say.line(DIALOGUE, &"bridge_look")

func look_bridge_lamp() -> void:
	await Say.line(DIALOGUE, &"bridge_lamp_look")

func look_canal() -> void:
	await Say.line(DIALOGUE, &"canal_look")

func look_boat() -> void:
	await Say.line(DIALOGUE, &"boat_look")

func look_tower_far() -> void:
	await Say.line(DIALOGUE, &"tower_far_look")
