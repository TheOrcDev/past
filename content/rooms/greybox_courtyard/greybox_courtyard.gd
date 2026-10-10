extends Room
## Beyond the greybox gate (plan 004 slice 11). Reaching it finishes the test
## puzzle chain.


func _on_enter(_from: StringName) -> void:
	GameState.set_flag(&"greybox_done")


func look_path() -> void:
	await Say.line(&"greybox", &"path_look")
