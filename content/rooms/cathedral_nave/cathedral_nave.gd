extends Room
## Cathedral nave (plan 002). The statue is the memory anchor: using it plays
## the flashback. Hotspot verbs are methods named <verb>_<hotspot_id>.


func _on_enter(_from: StringName) -> void:
	GameState.set_flag(&"cathedral_visited")


func use_statue() -> void:
	await Say.line(&"cathedral", &"statue_use")
	await Cutscenes.play(rewatch_cathedral_statue())


## The statue's vision, for using the statue and for watching it again from
## the journal.
func rewatch_cathedral_statue() -> Vision:
	var statue := hotspots.get_node("Statue") as Hotspot
	return Vision.new(&"cathedral_statue", self, statue.focus_point(), func(c: CutsceneSteps) -> void:
		await c.wait(1.5)
		await c.say(&"cathedral", &"statue_return")
		await c.wait(1.5))


func look_statue() -> void:
	await Say.line(&"cathedral", &"statue_look")


func look_altar() -> void:
	await Say.line(&"cathedral", &"altar_look")


func look_rose_window() -> void:
	await Say.line(&"cathedral", &"rose_window_look")


func look_arch() -> void:
	await Say.line(&"prologue/cathedral", &"arch_look")


func look_doors() -> void:
	await Say.line(&"prologue/cathedral", &"doors_look")


func use_doors() -> void:
	if GameState.get_flag(&"west_doors_open"):
		await _through_the_doors()
	else:
		await Say.line(&"prologue/cathedral", &"doors_locked")


## The west door key opens the great doors: the prologue's end (plan 008).
func item_doors(item: ItemDef) -> void:
	if item.id != &"west_door_key":
		await Say.fallback(&"item")
		return
	Inventory.remove(&"west_door_key")
	GameState.set_flag(&"west_doors_open")
	await Say.line(&"prologue/cathedral", &"doors_open")
	await _through_the_doors()


## Into chapter 1's square, or, in a build without chapter 1 (the browser
## demo), the prologue's closing card and back into the nave.
func _through_the_doors() -> void:
	if Chapters.in_build(&"cathedral_parvis"):
		Rooms.goto.call_deferred(&"cathedral_parvis", &"from_cathedral", &"fade")
		return
	await Cutscenes.play(StepsCutscene.new(&"prologue_end", func(c: CutsceneSteps) -> void:
		await c.fade(1.0, 1.5)
		var card := EndCard.new("PAST", "The prologue ends here. The nameless city waits beyond the doors.")
		get_tree().root.add_child(card)
		card.fade_in()
		await c.wait(5.5)
		card.queue_free()
		await c.fade(0.0, 1.0)))

