extends Closeup
## The theatre's playbill (plan 008, chapter 3).


func look_title() -> void:
	await Say.line(&"ch3/city", &"playbill_title_look")

func look_cast() -> void:
	await Say.line(&"ch3/city", &"playbill_cast_look")
