extends Closeup
## Ulric's unsent letter to Elise (plan 008, chapter 4).


func look_text() -> void:
	await Say.line(&"ch4/heights", &"letter_text_look")

func look_sign() -> void:
	await Say.line(&"ch4/heights", &"letter_sign_look")
