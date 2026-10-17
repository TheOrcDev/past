extends Closeup
## The High Magistrate's edicts in the alley (plan 008, chapter 1): a name is a
## privilege, posted at the eleventh bell.


## The edict and "Posted at the eleventh bell" are written large on the board.
func _on_shown() -> void:
	GameState.learn(&"high_magistrate")
	GameState.set_flag(&"knows_eleven")


func look_main() -> void:
	await Say.line(&"ch1/streets", &"edict_main_look")


func look_time() -> void:
	await Say.line(&"ch1/streets", &"edict_time_look")


func look_seal() -> void:
	await Say.line(&"ch1/streets", &"edict_seal_look")
