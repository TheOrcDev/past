extends GutTest
## The prologue (plan 008 slice 4), played from the grave to the great doors
## by ProloguePlaythrough: both threads, every item, the Gravedigger's and
## the Sister's trees, and two visions.


func before_each() -> void:
	GameState.reset()


func after_each() -> void:
	await wait_until(func() -> bool: return Interaction.locked == 0, 20.0)
	Interaction.inventory.close()
	Inventory.drop()
	Rooms.clear()
	GameState.reset()


func test_the_prologue_plays_to_the_doors() -> void:
	var run := ProloguePlaythrough.new(get_tree(), func(ok: bool, what: String) -> void: assert_true(ok, what))
	var done := [false]
	var play := func() -> void:
		await run.run()
		done[0] = true
	play.call()
	await wait_until(func() -> bool: return done[0], 300.0)
	assert_true(done[0], "the prologue finished")
	assert_eq(Rooms.current.room_id, &"cathedral_nave")
	for memory in [&"prologue_edict", &"prologue_singer"]:
		assert_true(memory in GameState.memories, "remembers %s" % memory)
