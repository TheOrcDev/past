extends GutTest
## Chapter 4 (plan 008 slice 8), played from the cathedral roof to the
## epilogue by Ch4Playthrough: the Dove, the song of names, Edmund, the bell
## and the names, and the grave at dawn.


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0, 20.0)
	Interaction.inventory.close()
	Inventory.drop()
	Rooms.clear()
	GameState.reset()


func test_chapter_four_plays_to_the_end() -> void:
	var run := Ch4Playthrough.new(get_tree(), func(ok: bool, what: String) -> void: assert_true(ok, what))
	var done := [false]
	var play := func() -> void:
		await run.run()
		done[0] = true
	play.call()
	await wait_until(func() -> bool: return done[0], 300.0)
	assert_true(done[0], "chapter 4 finished")
	assert_eq(Rooms.current.room_id, &"grave_at_dawn")
	for memory in [&"ch4_song", &"ch4_city"]:
		assert_true(memory in GameState.memories, "remembers %s" % memory)
