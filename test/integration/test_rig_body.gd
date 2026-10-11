extends GutTest
## NPCs are paintings skinned to a Skeleton2D (plan 008 slice 3, decision #49):
## the Gravedigger's scene has its motions, loops bend his bones while the feet
## stay put, a one-shot ends with animation_finished, and clicks land on him.

var _npc: Actor


func before_each() -> void:
	_npc = (load("res://content/characters/gravedigger/gravedigger.tscn") as PackedScene).instantiate() as Actor
	add_child_autofree(_npc)


func _body() -> RigBody:
	return _npc.get_node("Body") as RigBody


func test_it_has_its_motions_and_speaks_as_the_gravedigger() -> void:
	assert_eq(_npc.speaker_name, "Gravedigger")
	for anim in [&"idle", &"talk_a", &"talk_b", &"lean"]:
		assert_true(_body().has_animation(anim), "has %s" % anim)


func test_talking_bends_the_head_and_leaves_the_base() -> void:
	var head := _npc.get_node("Body/Rig/Skeleton/Base/Spine/Head") as Bone2D
	var base := _npc.get_node("Body/Rig/Skeleton/Base") as Bone2D
	var rest := head.rotation
	_body().play_animation(&"talk_a", false)
	_body().set_speaking(true)
	await wait_seconds(0.5)
	assert_ne(head.rotation, rest, "the head moves while talking")
	assert_almost_eq(base.rotation, base.rest.get_rotation(), 0.0001, "the feet stay planted")


func test_a_one_shot_finishes() -> void:
	watch_signals(_body())
	_body().play_animation(&"lean", false)
	await wait_for_signal(_body().animation_finished, 4.0)
	assert_signal_emitted(_body(), "animation_finished")


func test_clicks_land_on_the_painting() -> void:
	assert_true(_npc.contains_point(_npc.global_position + Vector2(0, -200)), "the coat is clickable")
	assert_false(_npc.contains_point(_npc.global_position + Vector2(0, -600)), "the air above is not")
