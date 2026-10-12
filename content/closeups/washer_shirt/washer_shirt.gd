extends Closeup
## The Washerwoman's shirt (plan 008, chapter 2): an A on the cuff.


func look_initial() -> void:
	await Say.line(&"ch2/quarter", &"shirt_initial_look")

func look_cloth() -> void:
	await Say.line(&"ch2/quarter", &"shirt_cloth_look")
