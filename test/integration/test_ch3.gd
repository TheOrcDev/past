extends GutTest
## Chapter 3 (plan 008 slice 7), played from the upper avenue to the covered
## bridge by Ch3Playthrough: the Hangman, the Puppeteer, the Registrar, the
## playable memory as Ulric, and the vault.


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0, 20.0)
	Interaction.inventory.close()
	Inventory.drop()
	Rooms.clear()
	GameState.reset()


func test_chapter_three_plays_to_the_bridge() -> void:
	var run := Ch3Playthrough.new(get_tree(), func(ok: bool, what: String) -> void: assert_true(ok, what))
	var done := [false]
	var play := func() -> void:
		await run.run()
		done[0] = true
	play.call()
	await wait_until(func() -> bool: return done[0], 300.0)
	assert_true(done[0], "chapter 3 finished")
	assert_true(GameState.get_flag(&"ch3_done"))
	for memory in [&"ch3_refusal", &"ch3_first_entry", &"ch3_office"]:
		assert_true(memory in GameState.memories, "remembers %s" % memory)
