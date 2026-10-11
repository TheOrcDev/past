extends Closeup
## The dove's hymn book in the choir loft (plan 008, prologue): names written
## small in her hand in every margin.

const DIALOGUE := &"prologue/cathedral"


func look_words() -> void:
	await Say.line(DIALOGUE, &"hymn_words_look")


func look_names() -> void:
	GameState.learn(&"the_singer")
	await Say.line(DIALOGUE, &"hymn_names_look")


func look_names_right() -> void:
	await look_names()


func look_ribbon() -> void:
	await Say.line(DIALOGUE, &"hymn_ribbon_look")
