extends Room
## Beyond the greybox gate (plan 004 slice 11). Reaching it finishes the test
## puzzle chain. The way on shows the land beyond as a discovery reveal, and
## the milestone shows the same land as it was, a memory vista (plan 005
## slice 5).

const VISTA := preload("res://content/cutscenes/greybox_vista/greybox_vista.tscn")


func _on_enter(_from: StringName) -> void:
	GameState.set_flag(&"greybox_done")


func look_path() -> void:
	await Say.line(&"greybox", &"path_look")


func use_path() -> void:
	await Say.line(&"greybox", &"path_use")
	await Cutscenes.play(RevealCutscene.new(&"greybox_vista", VISTA))


func look_milestone() -> void:
	await Say.line(&"greybox", &"milestone_look")


func use_milestone() -> void:
	await Say.line(&"greybox", &"milestone_use")
	await Cutscenes.play(RevealCutscene.new(&"greybox_milestone", VISTA, &"then"))
