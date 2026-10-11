extends Node
## The top bar and the pages it opens (plan 004 slice 8). The bar comes down
## when the cursor pushes against the top edge while the player is free to act.
## A page pauses the game until it closes; loading a slot happens after its page
## has closed.

## The open page, or null.
var screen: MenuScreen
var bar: TopBar
var hotspots: HotspotReveal
## Off in scripted QA runs, so a stray cursor at the top of the window cannot
## bring the bar into a recording.
var enabled := true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	bar = TopBar.new()
	bar.name = "TopBar"
	bar.chosen.connect(choose)
	add_child(bar)
	hotspots = HotspotReveal.new()
	hotspots.name = "HotspotReveal"
	add_child(hotspots)


func _process(_delta: float) -> void:
	# Headless runs have no cursor; tests call bar.follow() themselves, and a
	# scripted run that switched the bar off may still open it by hand.
	if enabled and DisplayServer.get_name() != "headless":
		bar.follow(get_viewport().get_mouse_position(), can_open())


## Whether the bar may come down: a room is showing and nothing else has the
## player's attention. Not inside a playable memory, which a save could not
## resume.
func can_open() -> bool:
	return enabled and screen == null and Rooms.current != null and Interaction.locked == 0 \
		and not Interaction.coin.is_open and not Interaction.inventory.is_open and not Flashback.in_memory


## Runs the bar's entry `id`.
func choose(id: StringName) -> void:
	bar.hide_now()
	match id:
		&"journal":
			var page := MenuScreen.new()
			page.title = "Journal"
			page.ready.connect(func() -> void:
				page.get_node(^"Content").add_child(MenuScreen.text_line("Nothing is written here yet.", 32)))
			open_page(page)
		&"save":
			# The thumbnail is the game as it was, so it waits for a frame without the bar.
			await get_tree().process_frame
			await get_tree().process_frame
			var page := SlotsScreen.new()
			page.title = "Save"
			page.saving = true
			page.picture = Saves.screen_image()
			open_page(page)
		&"load":
			var page := SlotsScreen.new()
			page.title = "Load"
			page.saving = false
			page.picked.connect(func(slot: int) -> void: Saves.load_slot.call_deferred(slot))
			open_page(page)
		&"settings":
			var page := SettingsScreen.new()
			page.title = "Settings"
			open_page(page)
		&"hotspots":
			hotspots.reveal()
		&"quit":
			var page := MenuScreen.new()
			page.title = "Leave the game?"
			page.ready.connect(func() -> void:
				var row := HBoxContainer.new()
				row.alignment = BoxContainer.ALIGNMENT_CENTER
				row.add_theme_constant_override(&"separation", 120)
				row.add_child(MenuScreen.text_button("Quit", 40, func() -> void: get_tree().quit()))
				row.add_child(MenuScreen.text_button("Stay", 40, page.close))
				page.get_node(^"Content").add_child(row))
			open_page(page)


## Shows `page` over the paused game.
func open_page(page: MenuScreen) -> void:
	if screen:
		screen.close()
	screen = page
	get_tree().paused = true
	Cursors.show_for(null)
	page.closed.connect(func() -> void:
		if screen == page:
			screen = null
			get_tree().paused = false)
	add_child(page)
