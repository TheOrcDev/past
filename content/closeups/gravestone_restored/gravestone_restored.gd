extends Closeup
## Unknown's gravestone, recut, at dawn (plan 008, chapter 4).


func look_name() -> void:
	await Say.line(&"ch4/finale", &"name4_look")

func look_inscription() -> void:
	await Say.line(&"ch4/finale", &"inscription4_look")
