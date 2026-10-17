extends Closeup
## Unknown's gravestone, close (plan 007): only the U of the name survives,
## above "I know you are happy now. Your dove".


## The U and the inscription are cut large in the stone.
func _on_shown() -> void:
	GameState.learn(&"name_u")
	GameState.set_flag(&"tombstone_read")
	GameState.learn(&"a_dove")


func look_name() -> void:
	await Say.line(&"cemetery", &"name_look")


func look_inscription() -> void:
	await Say.line(&"cemetery", &"inscription_look")


func look_dove() -> void:
	await Say.line(&"cemetery", &"dove_look")
