extends Room
## The ferry landing (plan 008, chapter 2 room 2): the Ferryman takes a small
## memory as his fare, then ferries Unknown to the drowned rooms. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"


func _on_shown() -> void:
	if not GameState.get_flag(&"landing_arrived"):
		GameState.set_flag(&"landing_arrived")
		await Say.line(DIALOGUE, &"landing_arrival")


func talk_ferryman() -> void:
	await Say.line(DIALOGUE, &"ferryman_talk")
	_take_ferry()


func look_ferryman() -> void:
	await Say.line(DIALOGUE, &"ferryman_look")

func look_fareboard() -> void:
	await Say.line(DIALOGUE, &"fareboard_look")

func look_lantern() -> void:
	await Say.line(DIALOGUE, &"jetty_lantern_look")


## The ferry is a conversation with the Ferryman: the landing he names is
## kept in the flag "ferry_to", and the boat leaves once the talk ends.
func _take_ferry() -> void:
	var to: Variant = GameState.get_flag(&"ferry_to", false)
	if to is String and not String(to).is_empty():
		GameState.set_flag(&"ferry_to", false)
		Rooms.goto.call_deferred(StringName(to), &"from_ferry", &"fade")
