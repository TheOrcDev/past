extends Room
## Behind the rose window (plan 008, chapter 4 room 6): the window remembers
## the song of names, the night Ulric took Elise's name. Hotspot verbs are
## methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch4/heights"


func _on_shown() -> void:
	if not GameState.get_flag(&"ledge_arrived"):
		GameState.set_flag(&"ledge_arrived")
		await Say.line(DIALOGUE, &"ledge_arrival")


func use_rose() -> void:
	await Say.line(DIALOGUE, &"rose_use")
	if not &"ch4_song" in GameState.memories:
		await Cutscenes.play(rewatch_ch4_song())


## The window's vision, for touching it and for watching it again.
func rewatch_ch4_song() -> Vision:
	var anchor := hotspots.get_node(^"Rose") as Hotspot
	return Vision.new(&"ch4_song", self, anchor.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"ch4/heights", &"song_return")
		await c.wait(1.5))


func look_rose() -> void:
	await Say.line(DIALOGUE, &"rose_look")

func look_nave() -> void:
	await Say.line(DIALOGUE, &"nave_below_look")
