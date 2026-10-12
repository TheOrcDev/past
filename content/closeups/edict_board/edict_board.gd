extends Closeup
## The High Magistrate's edicts in the alley (plan 008, chapter 1): a name is a
## privilege, posted at the eleventh bell.


func look_main() -> void:
	GameState.learn(&"high_magistrate")
	await Say.line(&"ch1/streets", &"edict_main_look")


func look_time() -> void:
	GameState.set_flag(&"knows_eleven")
	await Say.line(&"ch1/streets", &"edict_time_look")


func look_seal() -> void:
	await Say.line(&"ch1/streets", &"edict_seal_look")
