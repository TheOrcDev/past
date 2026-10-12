extends Room
## The Registrar's chamber (plan 008, chapter 3 room 10): the Registrar, his
## desk (the first entry's memory) and the vault, which opens to SILENCE. Then
## he runs for the belfry with the Ledger. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"


func _on_enter(_from: StringName) -> void:
	_show_state()


func _on_shown() -> void:
	if not GameState.get_flag(&"chamber_arrived"):
		GameState.set_flag(&"chamber_arrived")
		await Say.line(DIALOGUE, &"chamber_arrival")


func talk_registrar() -> void:
	await Say.line(DIALOGUE, &"registrar_talk")


func use_desk() -> void:
	await Say.line(DIALOGUE, &"standing_desk_use")
	if not &"ch3_first_entry" in GameState.memories:
		await Cutscenes.play(rewatch_ch3_first_entry())
		GameState.learn(&"first_entry")
		GameState.set_flag(&"knows_edmund")


## The vault door is an exit that needs "vault_open"; until then it asks for
## the word.
func locked_vault() -> void:
	await Say.line(DIALOGUE, &"vault_dial")
	if GameState.get_flag(&"vault_open"):
		var registrar := actors.get_node_or_null(^"Registrar") as Actor
		if registrar:
			registrar.play(&"write")
		await Say.line(DIALOGUE, &"registrar_flees")
		GameState.set_flag(&"registrar_fled")
		_show_state()


func _show_state() -> void:
	var fled := bool(GameState.get_flag(&"registrar_fled"))
	for node: CanvasItem in [actors.get_node_or_null(^"Registrar"), hotspots.get_node_or_null(^"Registrar")]:
		if node:
			node.visible = not fled


func look_registrar() -> void:
	await Say.line(DIALOGUE, &"registrar_look")

func look_pigeonholes() -> void:
	await Say.line(DIALOGUE, &"pigeonholes_look")

func look_desk() -> void:
	await Say.line(DIALOGUE, &"standing_desk_look")

func look_vault() -> void:
	await Say.line(DIALOGUE, &"vault_look")


## The desk's vision, for touching it and for watching it again.
func rewatch_ch3_first_entry() -> Vision:
	var anchor := hotspots.get_node(^"Desk") as Hotspot
	return Vision.new(&"ch3_first_entry", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch3/records", &"first_entry_return")
		await c.wait(1.0))
