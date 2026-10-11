extends Closeup
## Unknown's gravestone, close (plan 007): only the U of the name survives,
## above "I know you are happy now. Your dove".


func look_name() -> void:
	GameState.learn(&"name_u")
	await Say.line(&"cemetery", &"name_look")


func look_inscription() -> void:
	GameState.set_flag(&"tombstone_read")
	GameState.learn(&"a_dove")
	await Say.line(&"cemetery", &"inscription_look")


func look_dove() -> void:
	await Say.line(&"cemetery", &"dove_look")
