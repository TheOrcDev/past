extends GutTest
## Chapter 1 (plan 008 slice 5), played from the cathedral square to the
## lower gate by Ch1Playthrough: three threads, four NPCs, the wedding, the
## apprentice's playable memory and the clock's strike.


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0, 20.0)
	Interaction.inventory.close()
	Inventory.drop()
	Rooms.clear()
	GameState.reset()


func test_chapter_one_plays_to_the_lower_gate() -> void:
	var run := Ch1Playthrough.new(get_tree(), func(ok: bool, what: String) -> void: assert_true(ok, what))
	var done := [false]
	var play := func() -> void:
		await run.run()
		done[0] = true
	play.call()
	await wait_until(func() -> bool: return done[0], 300.0)
	assert_true(done[0], "chapter 1 finished")
	# The gate opens on chapter 2 where it ships, and on the end card otherwise.
	assert_eq(Rooms.current.room_id, &"flooded_stair" if Chapters.in_build(&"flooded_stair") else &"lower_gate")
	for memory in [&"ch1_wedding", &"ch1_apprentice", &"ch1_old_town"]:
		assert_true(memory in GameState.memories, "remembers %s" % memory)
