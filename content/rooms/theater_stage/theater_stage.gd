extends Room
## The stage (plan 008, chapter 3 room 4): the Puppeteer plays The Magistrate
## and the Book to empty seats; it tells where the Ledger is kept. Hotspot
## verbs are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/city"


func _on_shown() -> void:
	if not GameState.get_flag(&"stage_arrived"):
		GameState.set_flag(&"stage_arrived")
		await Say.line(DIALOGUE, &"stage_arrival")


func talk_puppeteer() -> void:
	await Say.line(DIALOGUE, &"puppeteer_talk")


func use_booth() -> void:
	await Say.line(DIALOGUE, &"boards_use")
	if not &"ch3_opening_night" in GameState.memories:
		await Cutscenes.play(rewatch_ch3_opening_night())


func look_puppeteer() -> void:
	await Say.line(DIALOGUE, &"puppeteer_look")

func look_booth() -> void:
	await Say.line(DIALOGUE, &"booth_look")

func look_seats() -> void:
	await Say.line(DIALOGUE, &"seats_look")


## The booth's vision, for touching it and for watching it again.
func rewatch_ch3_opening_night() -> Vision:
	var anchor := hotspots.get_node(^"Booth") as Hotspot
	return Vision.new(&"ch3_opening_night", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch3/city", &"opening_night_return")
		await c.wait(1.0))
