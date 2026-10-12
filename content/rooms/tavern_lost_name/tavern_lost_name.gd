extends Room
## The tavern (plan 008, chapter 1 room 8): the bride's candle on the mantel,
## and the wedding guests' toast at the bar. Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"ch1/streets"
const SLATE := preload("res://content/closeups/tavern_tally/tavern_tally.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"tavern_arrived"):
		GameState.set_flag(&"tavern_arrived")
		await Say.line(DIALOGUE, &"tavern_arrival")


func look_mantel() -> void:
	if GameState.get_flag(&"got_wedding_candle"):
		await Say.line(DIALOGUE, &"mantel_empty")
	elif &"ch1_wedding" in GameState.memories:
		await Say.line(DIALOGUE, &"mantel_candle_look")
	else:
		await Say.line(DIALOGUE, &"mantel_look")


## The candle stub is only noticed once the wedding has been seen.
func use_mantel() -> void:
	if GameState.get_flag(&"got_wedding_candle") or not &"ch1_wedding" in GameState.memories:
		await look_mantel()
		return
	await Rooms.player.play(&"pickup_high")
	GameState.set_flag(&"got_wedding_candle")
	Inventory.add(&"wedding_candle")
	await Say.line(DIALOGUE, &"mantel_take")


func look_slate() -> void:
	await Closeups.open_node(SLATE.instantiate() as Closeup, hotspots.get_node(^"Slate") as Hotspot)


func use_bar() -> void:
	await Say.line(DIALOGUE, &"bar_use")
	if not &"ch1_toast" in GameState.memories:
		await Cutscenes.play(rewatch_ch1_toast())


## The bar's vision, for touching it and for watching it again.
func rewatch_ch1_toast() -> Vision:
	var bar := hotspots.get_node(^"Bar") as Hotspot
	return Vision.new(&"ch1_toast", self, bar.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch1/streets", &"toast_return")
		await c.wait(1.0))


func look_fireplace() -> void:
	await Say.line(DIALOGUE, &"fireplace_look")

func look_bar() -> void:
	await Say.line(DIALOGUE, &"bar_look")

func look_mirror() -> void:
	await Say.line(DIALOGUE, &"mirror_look")
