extends Room
## The cemetery gate (plan 008, atlas P1): the Gravedigger, his lodge, and the
## crypt steps down to the ossuary. The prologue's cemetery thread is in
## docs/story/prologue-puzzles.md. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"prologue/cemetery"


func _on_shown() -> void:
	if not GameState.get_flag(&"gate_arrived"):
		GameState.set_flag(&"gate_arrived")
		await Say.line(DIALOGUE, &"gate_arrival")


func look_gravedigger() -> void:
	await Say.line(DIALOGUE, &"gravedigger_look")


func talk_gravedigger() -> void:
	await Say.line(DIALOGUE, &"gravedigger_talk")


## The lantern glass mends his lantern, and he lends it.
func item_gravedigger(item: ItemDef) -> void:
	if item.id != &"lantern_glass":
		await Say.line(DIALOGUE, &"gravedigger_other")
		return
	Inventory.remove(&"lantern_glass")
	GameState.set_flag(&"gd_lantern_mended")
	await Say.line(DIALOGUE, &"gravedigger_glass")
	Inventory.add(&"lantern")


func look_lodge_door() -> void:
	await Say.line(DIALOGUE, &"lodge_look")


func look_gate() -> void:
	await Say.line(DIALOGUE, &"gate_look")


func use_gate() -> void:
	await Say.line(DIALOGUE, &"gate_use")


func look_graves() -> void:
	await Say.line(DIALOGUE, &"graves_look")


func look_pole() -> void:
	await Say.line(DIALOGUE, &"pole_look")


func look_crypt() -> void:
	await Say.line(DIALOGUE, &"crypt_look")


func locked_crypt() -> void:
	await Say.line(DIALOGUE, &"crypt_locked")


## The ossuary key opens the crypt steps for good.
func item_crypt(item: ItemDef) -> void:
	if item.id != &"ossuary_key":
		await Say.fallback(&"item")
		return
	Inventory.remove(&"ossuary_key")
	GameState.set_flag(&"ossuary_open")
	await Say.line(DIALOGUE, &"crypt_unlocked")
