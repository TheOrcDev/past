extends Closeup
## Unknown's gravestone, close (plan 007): only the U of the name survives,
## above "I know you are happy now. Your dove".


func look_name() -> void:
	await Say.line(&"cemetery", &"name_look")


func look_inscription() -> void:
	await Say.line(&"cemetery", &"inscription_look")


func look_dove() -> void:
	await Say.line(&"cemetery", &"dove_look")
