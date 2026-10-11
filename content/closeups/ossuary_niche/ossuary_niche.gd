extends Closeup
## One burial niche in the ossuary (plan 008, prologue), its plaque scraped
## blank by a careful chisel.

const DIALOGUE := &"prologue/cemetery"


func look_plaque() -> void:
	await Say.line(DIALOGUE, &"niche_plaque_look")


func look_marks() -> void:
	await Say.line(DIALOGUE, &"niche_chisel_look")
