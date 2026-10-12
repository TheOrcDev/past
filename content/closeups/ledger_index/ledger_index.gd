extends Closeup
## The index of names in the stacks (plan 008, chapter 3).


func look_names() -> void:
	await Say.line(&"ch3/records", &"index_names_look")

func look_last() -> void:
	await Say.line(&"ch3/records", &"index_last_look")


func look_dove() -> void:
	GameState.set_flag(&"knows_office")
	await Say.line(&"ch3/records", &"index_dove_look")
