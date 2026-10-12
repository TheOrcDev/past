extends Room
## The sluice house (plan 008, chapter 2 room 5): the gate wheel remembers the
## keepers' petition, which Aldous signed first. Hotspot verbs are methods
## named <verb>_<hotspot_id>.

const DIALOGUE := &"ch2/quarter"
const PETITION := preload("res://content/closeups/petition/petition.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"sluice_arrived"):
		GameState.set_flag(&"sluice_arrived")
		await Say.line(DIALOGUE, &"sluice_arrival")


func use_wheel() -> void:
	if &"ch2_petition" in GameState.memories:
		await Say.line(DIALOGUE, &"wheel_again")
		return
	await Say.line(DIALOGUE, &"wheel_use")
	await Cutscenes.play(rewatch_ch2_petition())
	GameState.set_flag(&"petition_seen")


func look_desk() -> void:
	await Closeups.open_node(PETITION.instantiate() as Closeup, hotspots.get_node(^"Desk") as Hotspot)


func look_wheel() -> void:
	await Say.line(DIALOGUE, &"wheel_look")

func look_gauge() -> void:
	await Say.line(DIALOGUE, &"gauge_look")


## The wheel's vision, for touching it and for watching it again.
func rewatch_ch2_petition() -> Vision:
	var anchor := hotspots.get_node(^"Wheel") as Hotspot
	return Vision.new(&"ch2_petition", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch2/quarter", &"petition_return")
		await c.wait(1.0))
