extends Room
## The alley of doors (plan 008, chapter 1 room 7): every nameplate pried off,
## and the High Magistrate's edicts, posted at the eleventh bell. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"
const BOARD := preload("res://content/closeups/edict_board/edict_board.tscn")


func look_board() -> void:
	await Closeups.open_node(BOARD.instantiate() as Closeup, hotspots.get_node(^"Board") as Hotspot)


func look_doors() -> void:
	await Say.line(DIALOGUE, &"alley_doors_look")

func look_steps() -> void:
	await Say.line(DIALOGUE, &"alley_steps_look")

func look_sign() -> void:
	await Say.line(DIALOGUE, &"tavern_door_look")
