extends GutTest
## Unknown drawn from his rendered sprites: a complete set of one-byte mask
## frames with anchors, walking with planted feet at his rendered ground speed,
## mirroring to face left, and eyes and smoke that follow the anchors.

const SPRITES := "res://content/characters/unknown/unknown_sprites.tres"
const ANCHORS: Array[StringName] = [&"head", &"eye_l", &"eye_r", &"shoulder_l", &"shoulder_r", &"back", &"hand_l", &"hand_r", &"feet"]

var _unknown: Actor
var _body: UnknownBody


func before_each() -> void:
	await Rooms.goto(&"cathedral_nave", &"default", &"none")
	_unknown = Rooms.player
	_body = _unknown.get_node("Body") as UnknownBody


func after_each() -> void:
	Engine.time_scale = 1.0
	Rooms.clear()


func test_every_animation_has_mask_frames_and_anchors() -> void:
	var sprites := load(SPRITES) as CharacterSprites
	for base in ["idle", "walk", "look_around"]:
		for dir in ["r", "u", "d"]:
			var anim := StringName("%s_%s" % [base, dir])
			assert_true(sprites.frames.has_animation(anim), "%s exists" % anim)
			var count := sprites.frames.get_frame_count(anim)
			assert_gt(count, 0, "%s has frames" % anim)
			for anchor_name in ANCHORS:
				assert_eq((sprites.anchors[anim][anchor_name] as PackedVector2Array).size(), count, "%s: one %s per frame" % [anim, anchor_name])
			assert_eq((sprites.eyes[anim] as PackedByteArray).size(), count, "%s: eye flags per frame" % anim)
			var frame := sprites.frames.get_frame_texture(anim, 0) as AtlasTexture
			assert_eq(Vector2i(frame.get_size()), sprites.frame_size, "%s: trimmed frames keep the full frame size" % anim)
			assert_eq(frame.atlas.get_image().get_format(), Image.FORMAT_L8, "%s: one byte per pixel" % anim)
	assert_false(sprites.frames.get_animation_loop(&"look_around_r"), "the look-around is a one-shot")
	assert_almost_eq(float(sprites.ground_speed[&"walk_r"]), 344.8, 1.0)


func test_walking_moves_one_frame_of_ground_per_new_frame() -> void:
	_unknown.global_position = Vector2(700, 1000)
	await wait_physics_frames(2)
	_unknown.walk_to(Vector2(1400, 1000))
	var xs: Array[float] = []
	var sample := func() -> void: xs.append(_unknown.global_position.x)
	get_tree().physics_frame.connect(sample)
	await wait_seconds(1.0)
	get_tree().physics_frame.disconnect(sample)
	var expected := 344.8 * _unknown.scale.y / _body.frame_rate()
	var moves := 0
	for i in range(1, xs.size()):
		var dx := xs[i] - xs[i - 1]
		if dx != 0.0:
			moves += 1
			assert_almost_eq(dx, expected, 0.5, "each step covers one frame of ground")
	assert_lt(moves, xs.size() / 2, "still between new frames")
	assert_between(moves, 12, 18, "a step for each of about 15 walk frames a second")
	assert_eq(_body.sprite.animation, &"walk_r")
	_unknown.stop()


func test_vertical_walking_is_slower_than_horizontal() -> void:
	_unknown.global_position = Vector2(900, 930)
	await wait_physics_frames(2)
	_unknown.walk_to(Vector2(900, 1070))
	await wait_physics_frames(30)
	var down := _unknown.global_position.y - 930.0
	_unknown.stop()
	_unknown.global_position = Vector2(700, 1000)
	await wait_physics_frames(2)
	_unknown.walk_to(Vector2(1400, 1000))
	await wait_physics_frames(30)
	var across := _unknown.global_position.x - 700.0
	_unknown.stop()
	assert_gt(down, 0.0)
	assert_lt(down, across * 0.8, "depth covers less of the screen")


func test_facing_left_mirrors_the_body_and_its_anchors() -> void:
	_unknown.face(AnimNames.Dir.R)
	await wait_process_frames(2)
	var feet_x := _unknown.global_position.x
	assert_gt(_body.to_global(_body.anchor(&"eye_r")).x, feet_x + 10.0, "eyes ahead when facing right")
	_unknown.face(AnimNames.Dir.L)
	await wait_process_frames(2)
	assert_eq(_body.sprite.animation, &"idle_r", "left reuses the right-facing frames")
	assert_eq(_body.scale.x, -1.0)
	assert_lt(_body.to_global(_body.anchor(&"eye_r")).x, feet_x - 10.0, "eyes ahead when facing left")
	assert_true((_body.sprite.material as ShaderMaterial).get_shader_parameter(&"mirrored"), "the rim light knows")


func test_eyes_show_only_when_they_face_the_camera() -> void:
	var eye_l := _body.get_node("EyeL") as Sprite2D
	var eye_r := _body.get_node("EyeR") as Sprite2D
	_unknown.face(AnimNames.Dir.D)
	await wait_process_frames(2)
	assert_true(eye_l.visible and eye_r.visible, "both eyes facing the camera")
	_unknown.face(AnimNames.Dir.U)
	await wait_process_frames(2)
	assert_false(eye_l.visible or eye_r.visible, "no eyes from behind")
	_unknown.face(AnimNames.Dir.R)
	await wait_process_frames(2)
	assert_ne(eye_l.visible, eye_r.visible, "one eye in profile")
	assert_eq(eye_r.position, _body.anchor(&"eye_r"), "eyes sit on their anchors")


func test_tendrils_stream_behind_him() -> void:
	var tendrils := _body.tendrils
	assert_between(tendrils.chain_count(), 5, 8)
	_unknown.global_position = Vector2(600, 1000)
	_unknown.face(AnimNames.Dir.R)
	await wait_seconds(1.0)
	assert_lt(_mean_tip_offset(tendrils), -20.0, "behind him when facing right")
	_unknown.walk_to(Vector2(1500, 1000))
	await wait_seconds(1.0)
	assert_lt(_mean_tip_offset(tendrils), -20.0, "still behind while walking right")
	_unknown.stop()
	_unknown.face(AnimNames.Dir.L)
	await wait_seconds(1.5)
	assert_gt(_mean_tip_offset(tendrils), 20.0, "behind him when facing left")
	for c in tendrils.chain_count():
		for point in tendrils.chain_points(c):
			assert_true(point.is_finite(), "tendril points stay finite")


func test_speaking_pulses_the_eyes() -> void:
	_unknown.set_speaking(true)
	await wait_seconds(0.5)
	assert_gt(_body.voice_level, 0.2, "voice stand-in while speaking")
	_unknown.set_speaking(false)
	await wait_seconds(0.6)
	assert_almost_eq(_body.voice_level, 0.0, 0.01, "quiet afterwards")


func test_one_shot_finishes_and_returns_to_idle() -> void:
	Engine.time_scale = 8.0
	_unknown.face(AnimNames.Dir.D)
	await _unknown.play(&"look_around")
	assert_eq(_body.sprite.animation, &"idle_d")
	assert_true(_body.sprite.is_playing())


## Mean x of the tendril tips relative to their roots, in world pixels.
func _mean_tip_offset(tendrils: Tendrils) -> float:
	var total := 0.0
	for c in tendrils.chain_count():
		var points := tendrils.chain_points(c)
		total += points[points.size() - 1].x - points[0].x
	return total / tendrils.chain_count()
