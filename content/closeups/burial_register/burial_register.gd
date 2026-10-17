extends Closeup
## The burial register in the Gravedigger's lodge (plan 008, prologue): the
## entry for the grave Unknown woke in, and the margin note naming the ossuary
## key.

const DIALOGUE := &"prologue/cemetery"


## "Ossuary: key 13" and the entry are written large on the page.
func _on_shown() -> void:
	GameState.set_flag(&"register_read")
	GameState.learn(&"registrar_order")


func look_entry() -> void:
	await Say.line(DIALOGUE, &"register_entry")


func look_margin() -> void:
	await Say.line(DIALOGUE, &"register_keys")


func look_page() -> void:
	await Say.line(DIALOGUE, &"register_page")
