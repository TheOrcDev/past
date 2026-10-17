extends Closeup
## The index of names in the stacks (plan 008, chapter 3).


## The Dove's entry, "at his own desk", is written large on the page.
func _on_shown() -> void:
	GameState.set_flag(&"knows_office")


func look_names() -> void:
	await Say.line(&"ch3/records", &"index_names_look")

func look_last() -> void:
	await Say.line(&"ch3/records", &"index_last_look")


func look_dove() -> void:
	await Say.line(&"ch3/records", &"index_dove_look")
