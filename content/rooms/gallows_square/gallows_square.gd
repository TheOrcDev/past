extends Room
## The gallows square (plan 008, chapter 3 room 2): the Hangman, who keeps the
## theatre's key, and the beam that remembers his one refusal. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/city"


func _on_shown() -> void:
	if not GameState.get_flag(&"gallows_arrived"):
		GameState.set_flag(&"gallows_arrived")
		await Say.line(DIALOGUE, &"gallows_arrival")


func talk_hangman() -> void:
	await Say.line(DIALOGUE, &"hangman_talk")


func use_beam() -> void:
	await Say.line(DIALOGUE, &"beam_use")
	if not &"ch3_refusal" in GameState.memories:
		await Cutscenes.play(rewatch_ch3_refusal())
	GameState.set_flag(&"refusal_seen")


func look_hangman() -> void:
	await Say.line(DIALOGUE, &"hangman_look")

func look_beam() -> void:
	await Say.line(DIALOGUE, &"gallows_look")

func look_frames() -> void:
	await Say.line(DIALOGUE, &"market_frames_look")


## The beam's vision, for touching it and for watching it again.
func rewatch_ch3_refusal() -> Vision:
	var anchor := hotspots.get_node(^"Beam") as Hotspot
	return Vision.new(&"ch3_refusal", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch3/city", &"refusal_return")
		await c.wait(1.0))
