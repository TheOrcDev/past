extends Closeup
## The sluice keepers' petition (plan 008, chapter 2), every name struck through.


func look_text() -> void:
	await Say.line(&"ch2/quarter", &"petition_text_look")

func look_names() -> void:
	await Say.line(&"ch2/quarter", &"petition_names_look")

func look_seal() -> void:
	await Say.line(&"ch2/quarter", &"petition_seal_look")
