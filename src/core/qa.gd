extends Node
## Scripted smoke runs for builds and the editor. Run the game with
##   -- --qa=sandbox_smoke --qa-out=/absolute/dir
## (in a browser build, add ?qa=perf to the page URL) and it plays a short
## sequence, saves screenshots, prints a result line and quits with exit code 0
## on success. Without --qa this node does nothing.

const TIMEOUT_SECONDS := 60.0
const LONG_TIMEOUT_SECONDS := 150.0
## Scenarios that need the long timeout without the opening.
const LONG_RUNS: Array[String] = ["greybox", "vista", "journal"]
## Scenarios that need longer still, in seconds.
const TIMEOUTS := {"greybox_clip": 360.0, "toolkit_reel": 360.0, "rooms": 900.0}
## Scenarios that start from the opening instead of straight in the first room.
const WITH_OPENING: Array[String] = ["cemetery_reveal", "grave", "grave_clip", "perf", "tour", "screenshots", "reduced_motion", "skip", "toolkit_reel"]

var _out_dir := ""
var _scenario := ""
var _args := {}
var _failures: PackedStringArray = []
var _finished := false
var _samples := PackedFloat32Array()
var _gpu_samples := PackedFloat32Array()
var _cpu_samples := PackedFloat32Array()
## Each frame's script time (process and physics), to tell slow scripts from slow drawing.
var _script_samples := PackedFloat32Array()
var _sampling := false
## The step a scenario is on, named in the result if it times out.
var _at := ""


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
	# Scripted runs keep their saves apart from a player's, and run on the
	# default settings whatever the player chose.
	Saves.directory = "user://qa-saves"
	Journal.directory = "user://qa-journal"
	Settings.path = "user://qa-settings.cfg"
	Settings.reset({&"fullscreen": false})
	Menus.enabled = false
	_out_dir = _args.get("qa-out", OS.get_user_data_dir().path_join("qa"))
	DirAccess.make_dir_recursive_absolute(_out_dir)
	var timeout: float = TIMEOUTS.get(_scenario, LONG_TIMEOUT_SECONDS if _scenario in WITH_OPENING or _scenario in LONG_RUNS else TIMEOUT_SECONDS)
	get_tree().create_timer(timeout, true, false, true).timeout.connect(_finish.bind("timeout"))
	_run.call_deferred(_scenario)


## Scripted runs ignore the real mouse, so a stray click on the window cannot
## send Unknown off script (scenarios drive input through Interaction directly).
func _input(event: InputEvent) -> void:
	if not _scenario.is_empty() and event is InputEventMouse:
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	# --force-draw: draw every frame even when other windows cover this one
	# (macOS stops drawing it), so the movie writer never records stale frames.
	if _args.has("force-draw"):
		RenderingServer.force_draw(false)
	if _sampling:
		_samples.append(delta)
		var viewport := get_viewport().get_viewport_rid()
		_cpu_samples.append(RenderingServer.viewport_get_measured_render_time_cpu(viewport) + RenderingServer.get_frame_setup_time_cpu())
		_gpu_samples.append(RenderingServer.viewport_get_measured_render_time_gpu(viewport))
		_script_samples.append((Performance.get_monitor(Performance.TIME_PROCESS) + Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0)


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
		"grave":
			await _grave()
		"grave_clip":
			await _grave_clip()
		"perf":
			await _perf()
		"tour":
			await _tour()
		"banding":
			await _banding()
		"screenshots":
			await _screenshots()
		"flashback_clip":
			await _flashback_clip()
		"saves":
			await _saves()
		"reduced_motion":
			await _reduced_motion()
		"menus":
			await _menus()
		"skip":
			await _skip()
		"greybox":
			await _greybox()
		"rooms":
			await _rooms()
		"npc":
			await _npc()
		"greybox_clip":
			await _greybox_clip()
		"vista":
			await _vista()
		"journal":
			await _journal()
		"toolkit_reel":
			await _toolkit_reel()
		"voice":
			await _voice()
		_:
			_failures.append("unknown scenario %s" % scenario)
	_finish("done")


## Waits for the start room to finish loading, skipping its arrival line, then
## switches to `room_id`.
func _enter(room_id: StringName) -> void:
	while Rooms.current == null:
		await get_tree().process_frame
	await _settle()
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
	_check(Rooms.current.room_id == &"cemetery_grave", "the opening hands off into the grave")
	await get_tree().create_timer(1.0).timeout
	await _shot("04_grave")


## The grave (plan 007): the arrival line, the push-in on the gravestone, the U
## and the inscription up close, the pull back out, and the exits to the
## cathedral and back.
func _grave() -> void:
	while Rooms.current == null:
		await get_tree().process_frame
	_check(Rooms.current.room_id == &"cemetery_grave", "the game starts at the grave")
	while not Say.speaking:
		await get_tree().process_frame
	await get_tree().create_timer(0.8).timeout
	await _shot("01_arrival")
	await _settle()
	var gravestone := Rooms.current.hotspots.get_node("Gravestone") as Hotspot
	Interaction.click_at(gravestone.focus_point())
	while not Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(Closeups.SECONDS * 0.45).timeout
	await _shot("02_pushing_in")
	while Closeups.current == null or Closeups.busy:
		await get_tree().process_frame
	_check(Closeups.current.closeup_id == &"tombstone", "the gravestone opens its close-up")
	await _shot("03_the_stone")
	for spot: Array in [["Name", "CEM_NAME_LOOK_1", "04_only_a_u"], ["Inscription", "CEM_INSCRIPTION_LOOK_1", "05_your_dove"], ["Dove", "CEM_DOVE_LOOK_1", "06_the_dove"]]:
		var hotspot := Closeups.current.hotspots.get_node(String(spot[0])) as Hotspot
		var id: String = await _click_for_line(hotspot.focus_point())
		_check(id == spot[1], "%s line id is %s" % [spot[0], id])
		await get_tree().create_timer(0.8).timeout
		await _shot(spot[2])
		await _settle()
	Interaction.right_click()
	while Closeups.current:
		await get_tree().process_frame
	_check(Interaction.locked == 0, "input is free after the close-up closes")
	await get_tree().create_timer(0.3).timeout
	await _shot("07_back_at_the_grave")
	# The stone is read, so a click on Unknown hints at the way on.
	var hint: String = await _click_for_line(Rooms.player.global_position + Vector2(0, -40) * Rooms.player.scale.y)
	_check(hint == "HINT_GRAVEDIGGER_1", "clicking Unknown gives the next hint (%s)" % hint)
	await get_tree().create_timer(0.8).timeout
	await _shot("07b_hint")
	await _settle()
	Interaction.double_click_at((Rooms.current.hotspots.get_node("ExitEast") as Hotspot).focus_point())
	await Rooms.room_changed
	_check(Rooms.current.room_id == &"cathedral_nave", "the east exit leads to the cathedral")
	await _settle()
	Interaction.double_click_at((Rooms.current.hotspots.get_node("ExitWest") as Hotspot).focus_point())
	await Rooms.room_changed
	var arrival := Rooms.current.marker_position(&"from_cathedral")
	_check(Rooms.current.room_id == &"cemetery_grave" and Rooms.player.global_position.distance_to(arrival) < 1.0, "the cathedral leads back to the grave")
	await _settle()
	_check(not Say.speaking, "the arrival line plays only once")
	await get_tree().create_timer(0.5).timeout
	await _shot("08_back_from_the_cathedral")


## Shows an NPC (`--npc=<id>`) large over a grey backdrop and plays its
## motions (plan 008 slice 3): idle, each talk loop while "speaking", and each
## one-shot, with screenshots at their extremes. With `--room=<id>` it stands
## in that room at the marker named by `--marker` instead.
func _npc() -> void:
	var npc_id: String = _args.get("npc", "gravedigger")
	var npc := (load("res://content/characters/%s/%s.tscn" % [npc_id, npc_id]) as PackedScene).instantiate() as Actor
	var stage := Node2D.new()
	if _args.has("room"):
		await Rooms.goto(StringName(_args["room"]), &"default", &"none")
		npc.position = Rooms.current.marker_position(StringName(_args.get("marker", "default")))
		Rooms.current.actors.add_child(npc)
	else:
		while Rooms.current == null:
			await get_tree().process_frame
		await _settle()
		Rooms.clear()
		var backdrop := ColorRect.new()
		backdrop.color = Color(0.36, 0.37, 0.4)
		backdrop.size = Vector2(1920, 1080)
		stage.add_child(backdrop)
		# The actor sets its own scale, so the stage is what's enlarged.
		var zoom := Node2D.new()
		zoom.scale = Vector2(2.2, 2.2)
		zoom.position = Vector2(960, 1050)
		stage.add_child(zoom)
		zoom.add_child(npc)
		get_tree().root.add_child(stage)
	var body := npc.get_node("Body") as RigBody
	_check(body != null, "%s has a RigBody" % npc_id)
	await get_tree().create_timer(0.6).timeout
	await _shot("%s_idle" % npc_id)
	for anim: String in body.motions:
		var motion: Dictionary = body.motions[anim]
		if anim == "idle":
			continue
		if motion.get("loop", true):
			body.play_animation(StringName(anim), false)
			body.set_speaking(true)
			for i in 3:
				await get_tree().create_timer(0.37).timeout
				await _shot("%s_%s_%d" % [npc_id, anim, i])
			body.set_speaking(false)
		else:
			var length := float(motion.get("length", 1.0))
			body.play_animation(StringName(anim), false)
			for i in 3:
				await get_tree().create_timer(length / 4.0).timeout
				await _shot("%s_%s_%d" % [npc_id, anim, i])
			await body.animation_finished
	npc.queue_free()
	stage.queue_free()


## Tours rooms (plan 008): `--part=<id>` for a part's rooms with its story
## flags, or `--rooms=a,b`. Each room is shown now and, if it has a past, then,
## and every hotspot that isn't an exit is looked at and must answer with a line.
func _rooms() -> void:
	var rooms: Array[StringName] = []
	if _args.has("rooms"):
		for room in String(_args["rooms"]).split(","):
			rooms.append(StringName(room))
	else:
		var part := Chapters.part(StringName(_args.get("part", "prologue")))
		for flag: String in part.get("flags", []):
			GameState.set_flag(StringName(flag))
		for room: String in part.get("rooms", []):
			rooms.append(StringName(room))
	_check(not rooms.is_empty(), "there are rooms to tour")
	var listen := func(_id: String, _speaker: String, _text: String) -> void:
		Say.skip.call_deferred()
	Say.line_started.connect(listen)
	# The game's own start fades into its first room; let it land first.
	while Rooms.current == null:
		await get_tree().process_frame
	await _settle()
	for room_id in rooms:
		_mark(String(room_id))
		await Rooms.goto(room_id, &"default", &"none")
		await _settle()
		await get_tree().create_timer(0.4).timeout
		await _shot("%s_now" % room_id)
		if Rooms.current.get_node("Layers/Then").get_child_count() > 0:
			Rooms.current.set_era(&"then")
			await get_tree().create_timer(0.4).timeout
			await _shot("%s_then" % room_id)
			Rooms.current.set_era(&"now")
		for node in Rooms.current.hotspots.get_children():
			var hotspot := node as Hotspot
			if hotspot == null or hotspot is Exit or not hotspot.is_visible_in_tree():
				continue
			var spoken := [false]
			var heard := func(_id: String, _speaker: String, _text: String) -> void:
				spoken[0] = true
			Say.line_started.connect(heard)
			await hotspot.handle(&"look")
			await _settle()
			Say.line_started.disconnect(heard)
			_check(spoken[0] or Closeups.current != null, "%s/%s answers Look" % [room_id, hotspot.id])
			if Closeups.current:
				await Closeups.close()
	Say.line_started.disconnect(listen)


## Frame times through the whole slice (plan 002 slice 7): the opening, the
## gravestone close-up, Unknown walking the nave, and the flashback, plus
## memory. With --uncapped, vsync is off so frame times show the real cost;
## otherwise they show what the display allows. Prints one "[qa] PERF {json}"
## line.
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
	_mark("opening")
	_start_sampling()
	while Rooms.current == null:
		await get_tree().process_frame
	report["opening"] = _stop_sampling()
	var skip_lines := func(_id: String, _speaker: String, _text: String) -> void:
		get_tree().create_timer(1.2).timeout.connect(Say.skip)
	Say.line_started.connect(skip_lines)
	_mark("arrival")
	while Interaction.locked > 0:
		await get_tree().process_frame
	_mark("gravestone close-up")
	_start_sampling()
	Interaction.click_at((Rooms.current.hotspots.get_node("Gravestone") as Hotspot).focus_point())
	while Closeups.current == null or Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	Closeups.close()
	while Closeups.current:
		await get_tree().process_frame
	report["gravestone_closeup"] = _stop_sampling()
	_mark("into the nave")
	# Through the exit, as a player goes: its fade warms up the past's shaders.
	Interaction.double_click_at((Rooms.current.hotspots.get_node("ExitEast") as Hotspot).focus_point())
	await Rooms.room_changed
	while Interaction.locked > 0:
		await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	_mark("nave walking")
	_start_sampling()
	for target in [Vector2(1500, 1000), Vector2(600, 1050), Vector2(1100, 930), Vector2(900, 1040)]:
		await Rooms.player.walk_to(target)
	report["nave_walking"] = _stop_sampling()
	_mark("flashback")
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
## the grave and its stone up close, the way to the cathedral, a walk round the
## nave, the flashback, and a last walk. Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=tour
func _tour() -> void:
	while Rooms.current == null:
		await get_tree().process_frame
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await _read_the_stone(0.6)
	await get_tree().create_timer(0.6).timeout
	Interaction.click_at((Rooms.current.hotspots.get_node("ExitEast") as Hotspot).focus_point())
	await Rooms.room_changed
	await _settle(false)
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


## The start as a short clip (plan 007): the opening, Unknown's arrival at his
## grave, the push-in on the stone, his lines on the U and the inscription, and
## the pull back out. Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=grave_clip --force-draw
func _grave_clip() -> void:
	while Rooms.current == null:
		await get_tree().process_frame
	Rooms.player.get_node("IdleFidgets").set_process(false)
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await _read_the_stone(0.8)
	await get_tree().create_timer(1.5).timeout


## At the grave: Unknown walks to the stone and its close-up opens, he reads the
## U and the inscription at speaking pace, and the view pulls back out.
func _read_the_stone(pause: float) -> void:
	Interaction.click_at((Rooms.current.hotspots.get_node("Gravestone") as Hotspot).focus_point())
	while Closeups.current == null or Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(1.2).timeout
	for spot in ["Name", "Inscription"]:
		Interaction.click_at((Closeups.current.hotspots.get_node(spot) as Hotspot).focus_point())
		await get_tree().process_frame
		await _settle(false)
		await get_tree().create_timer(pause).timeout
	Closeups.close()
	while Closeups.current:
		await get_tree().process_frame


## Saving and loading in a running game (plan 004 slice 6). The first pass saves
## at the grave, goes to the cathedral, loads the save back and plays on a few
## seconds, as a player would. A later pass (browser-qa.ts adds qa-pass=<n> when
## it loads the page again) checks that the save outlived the reload: in the
## browser, user:// reaches IndexedDB a second or two after a write.
func _saves() -> void:
	await _enter(&"cemetery_grave")
	print("[qa] user:// persists: %s; %s holds %s" % [OS.is_userfs_persistent(), Saves.directory,
		DirAccess.get_files_at(Saves.directory) if DirAccess.dir_exists_absolute(Saves.directory) else []])
	if _args.get("qa-pass", "1") != "1":
		var kept := Saves.read(1)
		_check(not kept.is_empty() and kept.get("flags", {}).get("qa_marker") == "kept", "the save outlived the reload")
		_check(FileAccess.file_exists(Saves.thumbnail_path(1)), "and so did its thumbnail")
		return
	for file in [Saves.path(1), Saves.thumbnail_path(1)]:
		DirAccess.remove_absolute(file)
	GameState.set_flag(&"qa_marker", "kept")
	Rooms.player.global_position = Vector2(1200, 905)
	await get_tree().create_timer(0.3).timeout
	_check(Saves.save(1) == OK, "slot 1 saved")
	_check(FileAccess.file_exists(Saves.thumbnail_path(1)), "with a thumbnail")
	GameState.set_flag(&"qa_marker", "changed")
	await Rooms.goto(&"cathedral_nave", &"default", &"none")
	var err: Error = await Saves.load_slot(1)
	_check(err == OK and Rooms.current.room_id == &"cemetery_grave", "loading goes back to the grave")
	_check(Rooms.player.global_position.distance_to(Vector2(1200, 905)) < 1.0, "Unknown stands where he was saved")
	_check(GameState.get_flag(&"qa_marker") == "kept", "the flags are as saved")
	await get_tree().create_timer(0.5).timeout
	await _shot("01_loaded")
	await get_tree().create_timer(4.0).timeout


## Reduce camera motion (plan 004 slice 7): the opening crossfades from the
## close shot to the vista instead of pulling back, and the gravestone's
## close-up crossfades in without a camera move.
func _reduced_motion() -> void:
	Settings.reduce_camera_motion = true
	while get_tree().current_scene.get_node_or_null("CemeteryReveal") == null:
		await get_tree().process_frame
	var cutscene := get_tree().current_scene.get_node("CemeteryReveal")
	var animation := cutscene.get_node("AnimationPlayer") as AnimationPlayer
	for moment: Array in [[3.0, "01_close_held"], [6.6, "02_crossfading"], [8.5, "03_vista"]]:
		while animation.current_animation_position < moment[0]:
			await get_tree().process_frame
		await _shot(moment[1])
	var camera := cutscene.get_node("Reveal").camera as Camera2D
	_check(is_equal_approx(camera.zoom.x, (cutscene.get_node("Reveal") as Reveal).zoom_at(1.0)), "the view cut to the vista without travelling")
	await Rooms.room_shown
	await _settle()
	Interaction.click_at((Rooms.current.hotspots.get_node("Gravestone") as Hotspot).focus_point())
	while not Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(Closeups.SECONDS * 0.5).timeout
	_check(get_viewport().get_camera_2d() == null, "no camera push into the close-up")
	await _shot("04_closeup_crossfading")
	while Closeups.busy:
		await get_tree().process_frame
	await _shot("05_closeup_open")


## The top bar and its pages (plan 004 slice 8), shot one by one at the grave.
func _menus() -> void:
	await _enter(&"cemetery_grave")
	await get_tree().create_timer(0.5).timeout
	Menus.bar.open()
	await get_tree().create_timer(0.4).timeout
	await _shot("01_top_bar")
	Menus.bar.hide_now()
	_check(Menus.hotspots.reveal() == 6, "the grave's five things and its exit are marked")
	await get_tree().create_timer(0.6).timeout
	await _shot("02_reveal_hotspots")
	Menus.hotspots.clear()
	for file in [Saves.path(1), Saves.thumbnail_path(1)]:
		DirAccess.remove_absolute(file)
	await Menus.choose(&"save")
	await get_tree().create_timer(0.3).timeout
	await _shot("03_save_page")
	(Menus.screen as SlotsScreen).pick(1)
	await Menus.choose(&"load")
	await get_tree().create_timer(0.3).timeout
	await _shot("04_load_page")
	Menus.screen.close()
	for page: Array in [[&"settings", "05_settings_page"], [&"journal", "06_journal_page"], [&"quit", "07_quit_page"]]:
		await Menus.choose(page[0])
		await get_tree().create_timer(0.3).timeout
		await _shot(page[1])
		Menus.screen.close()


## Skipping the opening (plan 004 slice 10): the Skip button shows, fills as it
## is held, and the opening fast-forwards to the grave.
func _skip() -> void:
	var cutscene: Node = null
	while cutscene == null:
		await get_tree().process_frame
		cutscene = get_tree().current_scene.get_node_or_null("CemeteryReveal")
	await get_tree().create_timer(2.0).timeout
	var button := Cutscenes.skip_button
	button.press()
	await get_tree().create_timer(SkipButton.HOLD_SECONDS * 0.6).timeout
	await _shot("01_skip_held")
	var started := Time.get_ticks_msec()
	await Rooms.room_changed
	_check(Time.get_ticks_msec() - started < 4000, "the opening fast-forwards to the grave")
	await _settle()
	await _shot("02_at_the_grave")


## The greybox puzzle chain (plan 004 slice 11), played to the end.
func _greybox() -> void:
	await _enter(&"cemetery_grave")
	GameState.reset()
	await GreyboxPlaythrough.new(get_tree(), _check, _shot).run()


## The greybox chain at a viewer's pace, for the movie writer: lines play out.
## Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=greybox_clip --force-draw
func _greybox_clip() -> void:
	await _enter(&"cemetery_grave")
	GameState.reset()
	Rooms.player.get_node("IdleFidgets").set_process(false)
	var run := GreyboxPlaythrough.new(get_tree(), _check)
	run.skip_lines = false
	await run.run()
	await get_tree().create_timer(2.0).timeout


## The discovery reveal and the memory vista (plan 005 slice 5), in the greybox
## courtyard: using the way on pulls back over the land beyond, and using the
## milestone shows the same land in the past.
func _vista() -> void:
	await _enter(&"greybox_courtyard")
	var skip_lines := func(_id: String, _speaker: String, _text: String) -> void: Say.skip.call_deferred()
	Say.line_started.connect(skip_lines)
	for use: Array in [["Path", "01_reveal_close", "02_reveal_pulling_back", "03_reveal_vista"],
			["Milestone", "04_vista_close", "05_vista_pulling_back", "06_vista_in_the_past"]]:
		var spot := Rooms.current.hotspots.get_node(String(use[0])) as Hotspot
		Interaction.press_at(spot.focus_point(), spot.focus_point())
		await get_tree().create_timer(Interaction.COIN_HOLD_SECONDS + 0.1).timeout
		Interaction.coin.point_at(Interaction.coin.glyph_position(&"use"))
		Interaction.release_at(spot.focus_point(), Interaction.coin.glyph_position(&"use"))
		while Cutscenes.current == null or not Cutscenes.current is CutsceneSteps:
			await get_tree().process_frame
		var stage: RevealStage = null
		while stage == null:
			await get_tree().process_frame
			stage = get_tree().current_scene.get_node_or_null("GreyboxVista") as RevealStage
		for moment: Array in [[2.0, use[1]], [7.0, use[2]], [12.0, use[3]]]:
			while is_instance_valid(stage) and stage.animation.current_animation_position < moment[0]:
				await get_tree().process_frame
			await _shot(moment[1])
		await _settle()
	Say.line_started.disconnect(skip_lines)
	_check(Cutscenes.fade_amount() == 0.0 and get_viewport().get_canvas_transform() == Transform2D.IDENTITY, "the courtyard shows as it was")
	_check(&"greybox_milestone" in GameState.memories, "the memory vista is remembered")
	await _shot("07_back_in_the_courtyard")
	print("[qa] video memory in the courtyard, the vista loaded: %.1f MiB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0))


## The journal (plan 005 slice 6): after reading the gravestone and seeing the
## statue's memory, its pages show what Unknown learned, the memory's still
## and line, and the scenes to watch again.
func _journal() -> void:
	await _enter(&"cemetery_grave")
	var skip_lines := func(_id: String, _speaker: String, _text: String) -> void: Say.skip.call_deferred()
	Say.line_started.connect(skip_lines)
	await Closeups.open(&"tombstone", Rooms.current.hotspots.get_node("Gravestone") as Hotspot)
	for spot in ["Name", "Inscription"]:
		await Interaction.click_at((Closeups.current.hotspots.get_node(spot) as Hotspot).focus_point())
		await _settle()
	await Closeups.close()
	await Rooms.goto(&"cathedral_nave", &"default", &"none")
	await _settle()
	Interaction.click_at((Rooms.current.hotspots.get_node("Statue") as Hotspot).focus_point())
	await Flashback.vision_finished
	await _settle()
	Say.line_started.disconnect(skip_lines)
	_check(FileAccess.file_exists(Journal.still_path(&"cathedral_statue")), "the memory's still was kept")
	await Menus.choose(&"journal")
	await get_tree().create_timer(0.3).timeout
	await _shot("01_who_am_i")
	await (Menus.screen as JournalScreen).show_memory(&"cathedral_statue")
	await get_tree().create_timer(0.3).timeout
	await _shot("02_the_saints_hand")
	Menus.screen.close()


## The cinematic toolkit as a reel for the movie writer (plan 005 slice 7): the
## opening skipped partway, the statue's vision, the chapel's playable memory,
## the courtyard's reveal (skipped halfway) and memory vista, and the journal.
## Lines play at reading pace. Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=toolkit_reel --force-draw
func _toolkit_reel() -> void:
	while get_tree().current_scene.get_node_or_null("CemeteryReveal") == null:
		await get_tree().process_frame
	Rooms.room_shown.connect(func(_room: Room) -> void: Rooms.player.get_node("IdleFidgets").set_process(false), CONNECT_ONE_SHOT)
	await get_tree().create_timer(5.0).timeout
	Cutscenes.skip_button.press()
	await Rooms.room_shown
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await Rooms.goto(&"cathedral_nave", &"default", &"fade")
	await _settle(false)
	await get_tree().create_timer(0.6).timeout
	Interaction.click_at((Rooms.current.hotspots.get_node("Statue") as Hotspot).focus_point())
	await Flashback.vision_finished
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await Rooms.goto(&"greybox_chapel", &"default", &"fade")
	await _settle(false)
	await _use("Altar", &"use")
	await _settle(false)
	await Rooms.player.walk_to(Vector2(600, 960))
	await get_tree().create_timer(0.6).timeout
	await Interaction.click_at((Rooms.current.hotspots.get_node("Carving") as Hotspot).focus_point())
	while Flashback.in_memory:
		await get_tree().process_frame
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await Rooms.goto(&"greybox_courtyard", &"default", &"fade")
	await _settle(false)
	_use("Path", &"use")
	while Cutscenes.current == null or get_tree().current_scene.get_node_or_null("GreyboxVista") == null:
		await get_tree().process_frame
	await get_tree().create_timer(6.0).timeout
	Cutscenes.skip()
	await _settle(false)
	await get_tree().create_timer(0.6).timeout
	await _use("Milestone", &"use")
	await _settle(false)
	await get_tree().create_timer(0.8).timeout
	await Menus.choose(&"journal")
	await get_tree().create_timer(2.5).timeout
	for id in [&"cathedral_statue", &"greybox_milestone"]:
		await (Menus.screen as JournalScreen).show_memory(id)
		await get_tree().create_timer(3.0).timeout
	Menus.screen.close()
	await get_tree().create_timer(1.0).timeout


## Holds the button on a hotspot until the verb coin opens, and lets go over
## `verb`; returns once the verb has run.
func _use(hotspot_name: String, verb: StringName) -> void:
	var world := (Rooms.current.hotspots.get_node(hotspot_name) as Hotspot).focus_point()
	Interaction.press_at(world, get_viewport().get_canvas_transform() * world)
	await get_tree().create_timer(Interaction.COIN_HOLD_SECONDS + 0.1).timeout
	var glyph := Interaction.coin.glyph_position(verb)
	Interaction.coin.point_at(glyph)
	await Interaction.release_at(world, glyph)


## Voice playback (plan 003 slice 5), with a tone made in memory until real
## lines exist: the Voice bus is there, a voiced line holds for its audio, its
## level follows the line's envelope and Unknown's body follows the level. In
## the browser it checks streamed playback; browser-qa.ts lets the page play
## sound before a click, as a player's first click does.
func _voice() -> void:
	await _enter(&"cathedral_nave")
	_check(AudioServer.get_bus_index(&"Voice") >= 0, "the Voice bus exists")
	var rate := 22050
	var data := PackedByteArray()
	data.resize(rate * 2)
	for i in rate:
		data.encode_s16(i * 2, int(sin(i * TAU * 220.0 / rate) * 6000.0))
	var tone := AudioStreamWAV.new()
	tone.format = AudioStreamWAV.FORMAT_16_BITS
	tone.mix_rate = rate
	tone.data = data
	var rising := PackedFloat32Array()
	for i in 30:
		rising.append(i / 29.0)
	Voice.register(&"CATH_ALTAR_LOOK_1", tone, rising)
	# The line's level and Unknown's, at their highest, and the longest frame:
	# the browser build mixes sound between frames, so long ones hold it back.
	var peaks := [0.0, 0.0, 0, Time.get_ticks_msec()]
	var body := Rooms.player.get_node("Body")
	var track := func() -> void:
		peaks[0] = maxf(peaks[0], Voice.level())
		peaks[1] = maxf(peaks[1], body.voice_level)
		var now := Time.get_ticks_msec()
		if Say.speaking:
			peaks[2] = maxi(peaks[2], now - peaks[3])
		peaks[3] = now
	get_tree().process_frame.connect(track)
	var id: String = await _click_for_line((Rooms.current.hotspots.get_node("Altar") as Hotspot).focus_point())
	var started := Time.get_ticks_msec()
	await Say.line_finished
	var held := (Time.get_ticks_msec() - started) / 1000.0
	get_tree().process_frame.disconnect(track)
	_check(id == "CATH_ALTAR_LOOK_1", "the altar's line plays voiced")
	_check(absf(held - 1.0) < 0.4, "it held for its audio's 1 s (%.2f s; longest frame %d ms)" % [held, peaks[2]])
	_check(peaks[0] > 0.7, "its audio played through the envelope (level peak %.2f)" % peaks[0])
	_check(peaks[1] > 0.7, "Unknown's voice level followed it (peak %.2f)" % peaks[1])
	await _settle()
	Voice.unregister(&"CATH_ALTAR_LOOK_1")


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


## A gallery of the game as it stands: the opening, the grave and its stone up
## close, the nave, Unknown's animations and a flashback, for showing progress.
func _screenshots() -> void:
	while get_tree().current_scene.get_node_or_null("CemeteryReveal") == null:
		await get_tree().process_frame
	for moment: Array in [[2.2, "01_opening_close"], [5.0, "02_opening_pull_back"], [4.6, "03_opening_title"]]:
		await get_tree().create_timer(moment[0]).timeout
		await _shot(moment[1])
	await Rooms.room_changed
	var unknown := Rooms.player
	unknown.get_node("IdleFidgets").set_process(false)
	while not Say.speaking:
		await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	await _shot("04_the_grave")
	await _settle()
	Interaction.click_at((Rooms.current.hotspots.get_node("Gravestone") as Hotspot).focus_point())
	while not Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(Closeups.SECONDS * 0.45).timeout
	await _shot("05_pushing_in")
	while Closeups.current == null or Closeups.busy:
		await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	await _shot("06_the_stone")
	for spot: Array in [["Name", "07_only_a_u"], ["Inscription", "08_your_dove"]]:
		Interaction.click_at((Closeups.current.hotspots.get_node(String(spot[0])) as Hotspot).focus_point())
		await get_tree().create_timer(0.8).timeout
		await _shot(spot[1])
		await _settle()
	Closeups.close()
	while Closeups.current:
		await get_tree().process_frame
	await _enter(&"cathedral_nave")
	await get_tree().create_timer(1.0).timeout
	await _shot("09_nave")
	unknown.walk_to(Vector2(1500, 1030))
	await get_tree().create_timer(1.3).timeout
	await _shot("10_walking")
	await unknown.walk_to(Vector2(1300, 1040))
	unknown.face(AnimNames.Dir.D)
	unknown.play(&"fidget_b")
	await get_tree().create_timer(1.4).timeout
	await _shot("11_studying_his_hand")
	await get_tree().create_timer(2.0).timeout
	unknown.face(AnimNames.Dir.R)
	unknown.play(&"pickup_low")
	await get_tree().create_timer(0.95).timeout
	await _shot("12_picking_up")
	await get_tree().create_timer(1.5).timeout
	var altar := Rooms.current.hotspots.get_node("Altar") as Hotspot
	var altar_screen := get_viewport().get_canvas_transform() * altar.focus_point()
	Interaction.press_at(altar.focus_point(), altar_screen)
	await get_tree().create_timer(Interaction.COIN_HOLD_SECONDS + 0.3).timeout
	Interaction.coin.point_at(Interaction.coin.glyph_position(&"look"))
	await get_tree().create_timer(0.1).timeout
	await _shot("13_verb_coin")
	Interaction.release_at(altar.focus_point(), Vector2.ZERO)
	while Interaction.locked > 0 or Say.speaking or unknown.is_walking:
		if Say.speaking:
			Say.skip()
		await get_tree().process_frame
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Say.line_started
	await get_tree().create_timer(0.8).timeout
	await _shot("14_talking")
	await Flashback.vision_started
	await get_tree().create_timer(1.7).timeout
	await _shot("15_memory_blooming")
	await get_tree().create_timer(2.6).timeout
	await _shot("16_the_past")
	await Flashback.vision_finished
	await get_tree().create_timer(0.5).timeout
	await _shot("17_back_in_the_present")


## The cathedral memory as a short clip: Unknown touches the statue and speaks,
## the past blooms with his lines, and drains back. Record with
##   --write-movie <file.avi> --fixed-fps 30 -- --qa=flashback_clip --force-draw
func _flashback_clip() -> void:
	await _enter(&"cathedral_nave")
	var unknown := Rooms.player
	unknown.get_node("IdleFidgets").set_process(false)
	unknown.global_position = Vector2(560, 1030)
	unknown.face(AnimNames.Dir.L)
	await get_tree().create_timer(1.2).timeout
	var statue := Rooms.current.hotspots.get_node("Statue") as Hotspot
	Interaction.click_at(statue.focus_point())
	await Flashback.vision_finished
	while Interaction.locked > 0:
		await get_tree().process_frame
	await get_tree().create_timer(1.5).timeout


## Waits until the player can act again: no transition, line or close-up move
## running. With `skip`, lines being spoken are cut short.
func _settle(skip := true) -> void:
	while Interaction.locked > 0 or Say.speaking or Closeups.busy:
		if skip and Say.speaking:
			Say.skip()
		await get_tree().process_frame


## Clicks `world` and returns the id of the first line that starts (a close-up's
## hotspots answer at once, before an await on the signal could catch it).
func _click_for_line(world: Vector2) -> String:
	var ids: Array[String] = []
	var collect := func(id: String, _speaker: String, _text: String) -> void: ids.append(id)
	Say.line_started.connect(collect)
	Interaction.click_at(world)
	while ids.is_empty():
		await get_tree().process_frame
	Say.line_started.disconnect(collect)
	return ids[0]


func _start_sampling() -> void:
	_samples.clear()
	_cpu_samples.clear()
	_gpu_samples.clear()
	_script_samples.clear()
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
		# The worst frame's own script and render times; what's left of it is
		# waiting (GPU, the browser, loading).
		"worst_script_ms": snappedf(_script_samples[worst], 0.01) if worst < _script_samples.size() else 0.0,
		"worst_render_cpu_ms": snappedf(_cpu_samples[worst], 0.01) if worst < _cpu_samples.size() else 0.0,
		"render_gpu_p95_ms": snappedf(_percentile(_gpu_samples, 0.95), 0.01),
	}


func _percentile(values: PackedFloat32Array, fraction: float) -> float:
	if values.is_empty():
		return 0.0
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[mini(int(sorted.size() * fraction), sorted.size() - 1)]


## Notes the step a scenario starts, with the time since launch.
func _mark(step: String) -> void:
	_at = step
	print("[qa] at %s (%.1f s)" % [step, Time.get_ticks_msec() / 1000.0])


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
		_failures.append("timed out" + (" at %s" % _at if not _at.is_empty() else ""))
	print("[qa] RESULT %s %s" % ["PASS" if _failures.is_empty() else "FAIL", ", ".join(_failures)])
	get_tree().quit(0 if _failures.is_empty() else 1)
