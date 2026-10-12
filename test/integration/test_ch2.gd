extends GutTest
## Chapter 2 (plan 008 slice 6), played from the flooded stair to the valve
## house by Ch2Playthrough: the ferry, two threads, three NPCs, four visions
## and the turn, where Unknown learns he was Ulric.


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0, 20.0)
	Interaction.inventory.close()
	Inventory.drop()
	Rooms.clear()
	GameState.reset()


func test_chapter_two_plays_to_the_valve() -> void:
	var run := Ch2Playthrough.new(get_tree(), func(ok: bool, what: String) -> void: assert_true(ok, what))
	var done := [false]
	var play := func() -> void:
		await run.run()
		done[0] = true
	play.call()
	await wait_until(func() -> bool: return done[0], 300.0)
	assert_true(done[0], "chapter 2 finished")
	assert_true(GameState.get_flag(&"ch2_done"))
	for memory in [&"ch2_petition", &"ch2_oath", &"ch2_dedication", &"ch2_signing"]:
		assert_true(memory in GameState.memories, "remembers %s" % memory)
