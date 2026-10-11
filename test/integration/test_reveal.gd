extends GutTest
## The cemetery reveal: the zoom stack pulls back at constant perceived speed
## about one fixed point, stays inside the outer ring, hands detail from ring to
## ring, and the opening, played by the cutscene runner, ends on black with its
## title shown. Holding Skip or Esc skips it; a short press does not.

const SCENE := "res://content/cutscenes/cemetery_reveal/cemetery_reveal.tscn"
const OPENING := preload("res://content/cutscenes/cemetery_reveal/opening.gd")

var _cutscene: Node2D
var _reveal: Reveal


func before_each() -> void:
	_cutscene = (load(SCENE) as PackedScene).instantiate()
	add_child_autofree(_cutscene)
	_reveal = _cutscene.get_node("Reveal") as Reveal


func after_each() -> void:
	Engine.time_scale = 1.0
	await wait_until(func() -> bool: return Cutscenes.current == null, 10.0)
	Cutscenes.clear_fade()


func test_zoom_moves_in_log_space() -> void:
	assert_almost_eq(_reveal.zoom_at(0.0), _reveal.start_zoom, 0.0001)
	assert_almost_eq(_reveal.zoom_at(1.0), _reveal.end_zoom, 0.0001)
	assert_almost_eq(_reveal.zoom_at(0.5), sqrt(_reveal.start_zoom * _reveal.end_zoom), 0.0001, "halfway is the geometric mean")
	var ratio_a := _reveal.zoom_at(0.25) / _reveal.zoom_at(0.0)
	var ratio_b := _reveal.zoom_at(1.0) / _reveal.zoom_at(0.75)
	assert_almost_eq(ratio_a, ratio_b, 0.0001, "equal steps zoom by equal factors")


func test_pull_back_scales_about_a_fixed_point_inside_the_outer_ring() -> void:
	var pivot := _reveal.pivot()
	var screen_center := _reveal.view_size / 2.0
	var first := (pivot - _reveal.center_at(0.0)) * _reveal.zoom_at(0.0)
	for i in 21:
		var p := i / 20.0
		var zoom := _reveal.zoom_at(p)
		var center := _reveal.center_at(p)
		assert_almost_eq((pivot - center) * zoom, first, Vector2.ONE * 0.01, "the pivot keeps its screen place at %.2f" % p)
		var half := _reveal.view_size / (2.0 * zoom)
		assert_true(center.x - half.x >= -0.01 and center.x + half.x <= _reveal.world_size.x + 0.01, "inside ring 0 across at %.2f" % p)
		assert_true(center.y - half.y >= -0.01 and center.y + half.y <= _reveal.world_size.y + 0.01, "inside ring 0 down at %.2f" % p)
	assert_true(absf(first.x) < screen_center.x and absf(first.y) < screen_center.y, "the pivot is on screen")


func test_inner_rings_hand_over_detail() -> void:
	assert_eq(_reveal.ring_count(), 3)
	_reveal.progress = 0.0
	assert_true(_reveal.ring(1).visible and _reveal.ring(2).visible, "close up, every ring adds detail")
	_reveal.progress = 1.0
	assert_false(_reveal.ring(1).visible or _reveal.ring(2).visible, "pulled back, ring 0 alone")
	assert_true(_reveal.ring(0).visible)
	assert_eq(_reveal.camera.zoom, Vector2.ONE * _reveal.end_zoom)


func test_unknown_keeps_his_vista_scale_when_facing() -> void:
	var unknown := _cutscene.get_node("Reveal/Unknown") as UnknownBody
	var size := absf(unknown.scale.y)
	assert_lt(size, 1.0, "he is smaller than his rooms scale in the vista")
	unknown.play_animation(&"idle_r", true)
	assert_almost_eq(unknown.scale.x, -size, 0.0001, "mirroring keeps the scale")
	unknown.play_animation(&"idle_r", false)
	assert_almost_eq(unknown.scale.x, size, 0.0001)


func test_the_opening_plays_to_black_and_finishes() -> void:
	Engine.time_scale = 8.0
	var opening := OPENING.new()
	watch_signals(Cutscenes)
	var peak := [0.0]
	var progress := [-1.0]
	var track := func() -> void:
		if is_instance_valid(opening.stage):
			peak[0] = maxf(peak[0], (opening.stage.get_node("Title/Card") as Control).modulate.a)
			progress[0] = opening.stage.reveal.progress
	get_tree().process_frame.connect(track)
	await Cutscenes.play(opening)
	get_tree().process_frame.disconnect(track)
	assert_gt(peak[0], 0.9, "the title card showed")
	assert_signal_emitted(Cutscenes, "finished")
	assert_eq(progress[0], 1.0, "pulled all the way back")


func test_holding_skip_fast_forwards_the_opening() -> void:
	var opening := OPENING.new()
	var progress := [-1.0]
	Cutscenes.finished.connect(func(_id: StringName) -> void: progress[0] = opening.stage.reveal.progress, CONNECT_ONE_SHOT)
	var started := Time.get_ticks_msec()
	Cutscenes.play(opening)
	await wait_process_frames(2)
	Cutscenes.skip_button.press()
	await wait_until(func() -> bool: return Cutscenes.current == null, 5.0)
	assert_lt(Time.get_ticks_msec() - started, 4000, "skipped well under its 14 s")
	assert_eq(progress[0], 1.0, "a skipped opening ends where a watched one does")


func test_a_short_press_does_not_skip_but_esc_does() -> void:
	Cutscenes.play(OPENING.new())
	await wait_process_frames(2)
	var skipped := [false]
	Cutscenes.current.skipped.connect(func() -> void: skipped[0] = true)
	Cutscenes.skip_button.press()
	await wait_seconds(SkipButton.HOLD_SECONDS * 0.5)
	Cutscenes.skip_button.release()
	await wait_seconds(SkipButton.HOLD_SECONDS)
	assert_false(skipped[0], "let go too soon")
	var esc := InputEventAction.new()
	esc.action = &"ui_cancel"
	esc.pressed = true
	Input.parse_input_event(esc)
	await wait_process_frames(2)
	assert_true(skipped[0], "Esc skips")
	await wait_until(func() -> bool: return Cutscenes.current == null, 5.0)
