extends Room
## The choir loft (plan 008, atlas P5): the dove's hymn book on its stand,
## whose memory is the vision "The singer". Hotspot verbs are methods named
## <verb>_<hotspot_id>.

const DIALOGUE := &"prologue/cathedral"
const HYMN := preload("res://content/closeups/hymn_book/hymn_book.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"loft_arrived"):
		GameState.set_flag(&"loft_arrived")
		await Say.line(DIALOGUE, &"turret_lit")
		await Say.line(DIALOGUE, &"loft_arrival")


func look_stair() -> void:
	await Say.line(DIALOGUE, &"loft_stair_look")


func look_stand() -> void:
	if GameState.get_flag(&"got_hymn_book"):
		await Say.line(DIALOGUE, &"stand_empty")
		return
	await Closeups.open_node(HYMN.instantiate() as Closeup, hotspots.get_node("Stand") as Hotspot)


## The first touch plays the vision; after it the book can be taken.
func use_stand() -> void:
	if GameState.get_flag(&"got_hymn_book"):
		await Say.line(DIALOGUE, &"stand_empty")
	elif not &"prologue_singer" in GameState.memories:
		await Cutscenes.play(rewatch_prologue_singer())
	else:
		await Rooms.player.play(&"use")
		GameState.set_flag(&"got_hymn_book")
		Inventory.add(&"hymn_book")
		await Say.line(DIALOGUE, &"book_take")


## The hymn book's vision, for touching it and for watching it again.
func rewatch_prologue_singer() -> Vision:
	var stand := hotspots.get_node("Stand") as Hotspot
	return Vision.new(&"prologue_singer", self, stand.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"prologue/cathedral", &"singer_return")
		await c.wait(1.0))


func look_organ() -> void:
	await Say.line(DIALOGUE, &"organ_look")


func use_organ() -> void:
	await Say.line(DIALOGUE, &"organ_use")


func look_balustrade() -> void:
	await Say.line(DIALOGUE, &"balustrade_look")


func look_banners() -> void:
	await Say.line(DIALOGUE, &"banners_look")
