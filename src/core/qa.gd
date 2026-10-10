extends Node
## Scripted smoke runs for builds and the editor. Run the game with
##   -- --qa=sandbox_smoke --qa-out=/absolute/dir
## (in a browser build, add ?qa=perf to the page URL) and it plays a short
## sequence, saves screenshots, prints a result line and quits with exit code 0
## on success. Without --qa this node does nothing.

const TIMEOUT_SECONDS := 60.0
const LONG_TIMEOUT_SECONDS := 150.0
## Scenarios that start from the opening instead of straight in the first room.
const WITH_OPENING: Array[String] = ["cemetery_reveal", "perf", "tour", "screenshots"]

var _out_dir := ""
var _scenario := ""
var _args := {}
var _failures: PackedStringArray = []
var _finished := false
var _samples := PackedFloat32Array()
var _gpu_samples := PackedFloat32Array()
var _cpu_samples := PackedFloat32Array()
var _sampling := false


func _ready() -> void:
	var raw := OS.get_cmdline_user_args()
	if OS.has_feature("web"):
		var query = JavaScriptBridge.eval("window.location.search", true)
		if query is String and not query.is_empty():
			for pair in query.trim_prefix("?").split("&"):
				raw.append("--" + pair)
	for arg in raw:
		if arg.begins_with("--"):
			_args[arg.substr(2).get_slice("=", 0)] = arg.get_slice("=", 1) if "=" in arg else "true"
	if not _args.has("qa"):
		set_process(false)
		return
	_scenario = _args["qa"]
	_out_dir = _args.get("qa-out", OS.get_user_data_dir().path_join("qa"))
	DirAccess.make_dir_recursive_absolute(_out_dir)
	var timeout := LONG_TIMEOUT_SECONDS if _scenario in WITH_OPENING else TIMEOUT_SECONDS
	get_tree().create_timer(timeout, true, false, true).timeout.connect(_finish.bind("timeout"))
	_run.call_deferred(_scenario)


## Scripted runs ignore the real mouse, so a stray click on the window cannot
## send Unknown off script (scenarios drive input through Interaction directly).
func _input(event: InputEvent) -> void:
	if not _scenario.is_empty() and event is InputEventMouse:
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if _sampling:
		_samples.append(delta)
		var viewport := get_viewport().get_viewport_rid()
		_cpu_samples.append(RenderingServer.viewport_get_measured_render_time_cpu(viewport) + RenderingServer.get_frame_setup_time_cpu())
		_gpu_samples.append(RenderingServer.viewport_get_measured_render_time_gpu(viewport))


## Room scenarios start straight in the first room, without the opening.
func skips_opening() -> bool:
	return not _scenario.is_empty() and not _scenario in WITH_OPENING


func _run(scenario: String) -> void:
	match scenario:
		"sandbox_smoke":
			await _sandbox_smoke()
		"cathedral_eras":
			await _cathedral_eras()
		"cathedral_flashback":
			await _cathedral_flashback()
		"unknown_look":
			await _unknown_look()
		"cemetery_reveal":
			await _cemetery_reveal()
		"perf":
			await _perf()
		"tour":
			await _tour()
		"banding":
			await _banding()
		"screenshots":
			await _screenshots()
		_:
			_failures.append("unknown scenario %s" % scenario)
	_finish("done")


## Waits for the start room to finish loading, then switches to `room_id`.
func _enter(room_id: StringName) -> void:
	while Rooms.current == null or Interaction.locked > 0:
		await get_tree().process_frame
	if Rooms.current.room_id != room_id:
		await Rooms.goto(room_id, &"default", &"none")


func _sandbox_smoke() -> void:
	await _enter(&"sandbox")
	await get_tree().create_timer(0.5).timeout
	await _shot("01_start")
	var target := Vector2(1400, 1010)
	var arrived: bool = await Rooms.player.walk_to(target)
	_check(arrived and Rooms.player.global_position.distance_to(target) < 4.0, "walk to the floor point")
	await _shot("02_walked")
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	var started: Array = await Say.line_started
	_check(started[0] == "SANDBOX_STATUE_LOOK", "statue look line id is %s" % started[0])
	await get_tree().create_timer(0.4).timeout
	await _shot("03_statue_line")
	while Say.speaking:
		Say.skip()
		await get_tree().process_frame


## Both eras of the cathedral with their effects running, and Unknown behind an occluder.
func _cathedral_eras() -> void:
	await _enter(&"cathedral_nave")
	await get_tree().create_timer(2.0).timeout
	await _shot("01_now")
	Rooms.current.set_era(&"then")
	_check(Rooms.current.era == &"then", "era switched to then")
	await get_tree().create_timer(2.0).timeout
	await _shot("02_then")
	Rooms.current.set_era(&"now")
	Rooms.player.global_position = Vector2(1765, 1060)
	await get_tree().create_timer(0.5).timeout
	await _shot("03_behind_occluder")


## The statue's flashback, captured at its key moments, in real time.
func _cathedral_flashback() -> void:
	await _enter(&"cathedral_nave")
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Flashback.vision_started
	await get_tree().create_timer(1.0).timeout
	await _shot("01_bloom_early")
	await get_tree().create_timer(1.0).timeout
	await _shot("02_bloom_mid")
	await get_tree().create_timer(3.0).timeout
	await _shot("03_past_hold")
	await Flashback.vision_finished
	_check(Rooms.current.era == &"now", "back in the present after the vision")
	await _shot("04_after")


## Unknown from his rendered sprites: each facing, walking both ways, near and
## far, and how much video memory his sheets take.
func _unknown_look() -> void:
	await _enter(&"cathedral_nave")
	var unknown := Rooms.player
	unknown.global_position = Vector2(900, 1060)
	for facing: Array in [[AnimNames.Dir.D, "01_front"], [AnimNames.Dir.R, "02_side"], [AnimNames.Dir.U, "03_back"]]:
		unknown.face(facing[0])
		await get_tree().create_timer(1.5).timeout
		await _shot(facing[1])
	unknown.walk_to(Vector2(1500, 1040))
	await get_tree().create_timer(1.2).timeout
	await _shot("04_walk_right")
	unknown.walk_to(Vector2(600, 1040))
	await get_tree().create_timer(1.6).timeout
	await _shot("05_walk_left")
	unknown.stop()
	unknown.global_position = Vector2(1100, 915)
	unknown.face(AnimNames.Dir.D)
	await get_tree().create_timer(1.5).timeout
	await _shot("06_far")
	var path := (unknown.get_node("Body") as SpriteBody).sprites.resource_path
	var before := Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
	var fresh := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP) as CharacterSprites
	RenderingServer.force_draw(false)
	var monitor := Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) - before
	# The sheets' own data (GPU-compressed or not); Godot's monitor reads about
	# 1.4 times this for the same textures, so both are printed.
	var bytes := 0
	var seen := {}
	for anim in fresh.frames.get_animation_names():
		var atlas := (fresh.frames.get_frame_texture(anim, 0) as AtlasTexture).atlas
		if not seen.has(atlas):
			seen[atlas] = true
			bytes += atlas.get_image().get_data().size()
	print("[qa] Unknown's sheets: %.1f MiB of texture data (Godot's monitor: %.1f MiB), %d animations" % [bytes / 1048576.0, monitor / 1048576.0, fresh.frames.get_animation_names().size()])
	_check(bytes > 0 and bytes < 128 * 1048576, "Unknown's frames fit 128 MiB")


## The opening reveal at key moments, then the handoff into the first room.
func _cemetery_reveal() -> void:
	var cutscene: Node = null
	while cutscene == null:
		await get_tree().process_frame
		cutscene = get_tree().current_scene.get_node_or_null("CemeteryReveal")
	await get_tree().create_timer(1.8).timeout
	await _shot("01_close")
	await get_tree().create_timer(4.5).timeout
	await _shot("02_pulling_back")
	await get_tree().create_timer(5.0).timeout
	await _shot("03_title")
	await Rooms.room_changed
	_check(Rooms.current.room_id == &"cathedral_nave", "the opening hands off into the cathedral")
	await get_tree().create_timer(1.0).timeout
	await _shot("04_cathedral")


## Frame times through the whole slice (plan 002 slice 7): the opening, Unknown
## walking the nave, and the flashback, plus memory. With --uncapped, vsync is
## off so frame times show the real cost; otherwise they show what the display
## allows. Prints one "[qa] PERF {json}" line.
func _perf() -> void:
	if _args.has("uncapped"):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	RenderingServer.viewport_set_measure_render_time(get_viewport().get_viewport_rid(), true)
	var report := {
		"platform": OS.get_name(),
		"adapter": RenderingServer.get_video_adapter_name(),
		"framebuffer": get_viewport().get_texture().get_size(),
		"vsync": DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED,
	}
	_start_sampling()
	while Rooms.current == null:
		await get_tree().process_frame
	report["opening"] = _stop_sampling()
	await get_tree().create_timer(1.0).timeout
	_start_sampling()
	for target in [Vector2(1500, 1000), Vector2(600, 1050), Vector2(1100, 930), Vector2(900, 1040)]:
		await Rooms.player.walk_to(target)
	report["nave_walking"] = _stop_sampling()
	var skip_lines := func(_id: String, _speaker: String, _text: String) -> void:
		get_tree().create_timer(1.2).timeout.connect(Say.skip)
	Say.line_started.connect(skip_lines)
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Flashback.vision_started
	_start_sampling()
	await Flashback.vision_finished
	report["flashback"] = _stop_sampling()
	Say.line_started.disconnect(skip_lines)
	report["memory_mib"] = {
		"textures": snappedf(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576.0, 0.1),
		"video": snappedf(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0, 0.1),
		"static": snappedf(Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0, 0.1),
	}
	print("[qa] PERF %s" % JSON.stringify(report))


## The whole slice as a player sees it, for the screen recording: the opening,
## a walk round the nave, the flashback, and a last walk. Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=tour
func _tour() -> void:
	while Rooms.current == null or Interaction.locked > 0:
		await get_tree().process_frame
	await get_tree().create_timer(0.8).timeout
	for target in [Vector2(1450, 1010), Vector2(700, 1050), Vector2(420, 1000)]:
		await Rooms.player.walk_to(target)
		await get_tree().create_timer(0.5).timeout
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Flashback.vision_finished
	while Interaction.locked > 0:
		await get_tree().process_frame
	await Rooms.player.walk_to(Vector2(1000, 1030))
	await get_tree().create_timer(1.5).timeout


## The fog gradients with grain on and off, in both eras, for judging banding.
func _banding() -> void:
	await _enter(&"cathedral_nave")
	Rooms.player.global_position = Vector2(1650, 1060)
	for era in [&"now", &"then"]:
		Rooms.current.set_era(era)
		Flashback.set_grade(1.0 if era == &"then" else 0.0)
		for grain in [0.04, 0.0]:
			Flashback.set_grain(grain)
			await get_tree().create_timer(1.0).timeout
			await _shot("%s_grain_%s" % [era, "on" if grain > 0.0 else "off"])
	Flashback.set_grain(0.04)


## A gallery of the game as it stands: the opening, the nave, Unknown's
## animations and a flashback, for showing progress.
func _screenshots() -> void:
	while get_tree().current_scene.get_node_or_null("CemeteryReveal") == null:
		await get_tree().process_frame
	for moment: Array in [[2.2, "01_opening_close"], [5.0, "02_opening_pull_back"], [4.6, "03_opening_title"]]:
		await get_tree().create_timer(moment[0]).timeout
		await _shot(moment[1])
	await Rooms.room_changed
	while Interaction.locked > 0:
		await get_tree().process_frame
	var unknown := Rooms.player
	unknown.get_node("IdleFidgets").set_process(false)
	await get_tree().create_timer(1.0).timeout
	await _shot("04_nave")
	unknown.walk_to(Vector2(1500, 1030))
	await get_tree().create_timer(1.3).timeout
	await _shot("05_walking")
	await unknown.walk_to(Vector2(1300, 1040))
	unknown.face(AnimNames.Dir.D)
	unknown.play(&"fidget_b")
	await get_tree().create_timer(1.4).timeout
	await _shot("06_studying_his_hand")
	await get_tree().create_timer(2.0).timeout
	unknown.face(AnimNames.Dir.R)
	unknown.play(&"pickup_low")
	await get_tree().create_timer(0.95).timeout
	await _shot("07_picking_up")
	await get_tree().create_timer(1.5).timeout
	var altar := Rooms.current.hotspots.get_node("Altar") as Hotspot
	var altar_screen := get_viewport().get_canvas_transform() * altar.focus_point()
	Interaction.press_at(altar.focus_point(), altar_screen)
	await get_tree().create_timer(Interaction.COIN_HOLD_SECONDS + 0.3).timeout
	Interaction.coin.point_at(Interaction.coin.glyph_position(&"look"))
	await get_tree().create_timer(0.1).timeout
	await _shot("07b_verb_coin")
	Interaction.release_at(altar.focus_point(), Vector2.ZERO)
	while Interaction.locked > 0 or Say.speaking or unknown.is_walking:
		if Say.speaking:
			Say.skip()
		await get_tree().process_frame
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Say.line_started
	await get_tree().create_timer(0.8).timeout
	await _shot("08_talking")
	await Flashback.vision_started
	await get_tree().create_timer(1.7).timeout
	await _shot("09_memory_blooming")
	await get_tree().create_timer(2.6).timeout
	await _shot("10_the_past")
	await Flashback.vision_finished
	await get_tree().create_timer(0.5).timeout
	await _shot("11_back_in_the_present")


func _start_sampling() -> void:
	_samples.clear()
	_cpu_samples.clear()
	_gpu_samples.clear()
	_sampling = true


## Frame time (mean, 95th percentile, worst and when it happened), frames over
## 1/60 s, and the renderer's own CPU and GPU time per frame, all in ms.
func _stop_sampling() -> Dictionary:
	_sampling = false
	var count := _samples.size()
	if count == 0:
		return {"frames": 0}
	var total := 0.0
	var slow := 0
	var worst := 0
	for i in count:
		total += _samples[i]
		if _samples[i] > 1.0 / 58.0:
			slow += 1
		if _samples[i] > _samples[worst]:
			worst = i
	var worst_at := 0.0
	for i in worst:
		worst_at += _samples[i]
	return {
		"frames": count,
		"seconds": snappedf(total, 0.01),
		"mean_ms": snappedf(total / count * 1000.0, 0.01),
		"p95_ms": snappedf(_percentile(_samples, 0.95) * 1000.0, 0.01),
		"max_ms": snappedf(_samples[worst] * 1000.0, 0.01),
		"max_at_s": snappedf(worst_at, 0.01),
		"over_60fps_budget": slow,
		"render_cpu_p95_ms": snappedf(_percentile(_cpu_samples, 0.95), 0.01),
		"render_gpu_p95_ms": snappedf(_percentile(_gpu_samples, 0.95), 0.01),
	}


func _percentile(values: PackedFloat32Array, fraction: float) -> float:
	if values.is_empty():
		return 0.0
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[mini(int(sorted.size() * fraction), sorted.size() - 1)]


func _check(ok: bool, what: String) -> void:
	print("[qa] %s %s" % ["PASS" if ok else "FAIL", what])
	if not ok:
		_failures.append(what)


func _shot(shot_name: String) -> void:
	# Draw now rather than await the next frame: macOS stops drawing a window that
	# other windows cover, and the post-draw signal would never come.
	RenderingServer.force_draw(false)
	var path := _out_dir.path_join("%s.png" % shot_name)
	var err := get_viewport().get_texture().get_image().save_png(path)
	_check(err == OK, "screenshot %s" % path)


func _finish(reason: String) -> void:
	if _finished:
		return
	_finished = true
	if reason == "timeout":
		_failures.append("timed out")
	print("[qa] RESULT %s %s" % ["PASS" if _failures.is_empty() else "FAIL", ", ".join(_failures)])
	get_tree().quit(0 if _failures.is_empty() else 1)
