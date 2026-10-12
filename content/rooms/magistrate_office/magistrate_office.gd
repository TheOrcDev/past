extends Room
## The Magistrate's office (plan 008, chapter 3 room 9): the desk opens a
## playable memory in which Unknown is Ulric, writes the vault's word and
## strikes the Dove's name. Hotspot verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/records"
const DESK := preload("res://content/closeups/office_desk/office_desk.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"office_arrived"):
		GameState.set_flag(&"office_arrived")
		await Say.line(DIALOGUE, &"office_arrival")


func look_desk() -> void:
	await Closeups.open_node(DESK.instantiate() as Closeup, hotspots.get_node(^"Desk") as Hotspot)


func use_desk() -> void:
	await Say.line(DIALOGUE, &"desk_use3")
	if GameState.get_flag(&"knows_vault_word"):
		return
	var desk := hotspots.get_node(^"Desk") as Hotspot
	Flashback.enter_memory(&"ch3_office", self, desk.focus_point(), &"knows_vault_word")


## In the past only: the Ledger on the desk.
func look_ledger() -> void:
	await Say.line(DIALOGUE, &"office_in")
	await Say.line(DIALOGUE, &"office_ledger_look")


func use_ledger() -> void:
	await Say.line(DIALOGUE, &"office_ledger_use")
	GameState.learn(&"struck_the_dove")
	GameState.set_flag(&"knows_vault_word")


func look_fire() -> void:
	await Say.line(DIALOGUE, &"office_fire_look")


func look_portrait() -> void:
	await Say.line(DIALOGUE, &"portrait_look")

func look_window() -> void:
	await Say.line(DIALOGUE, &"office_window_look")

func look_fireplace() -> void:
	await Say.line(DIALOGUE, &"fireplace3_look")
