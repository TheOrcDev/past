extends Closeup
## The great bell's inscription (plan 008, chapter 4).


func look_text() -> void:
	await Say.line(&"ch4/finale", &"bell_text_look")

func look_metal() -> void:
	await Say.line(&"ch4/finale", &"bell_metal_look")
