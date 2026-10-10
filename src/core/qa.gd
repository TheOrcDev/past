extends Node
## Scripted smoke runs for builds and the editor. Run the game with
##   -- --qa=sandbox_smoke --qa-out=/absolute/dir
## and it plays a short sequence, saves screenshots, prints a result line and
## quits with exit code 0 on success. Without --qa this node does nothing.

const TIMEOUT_SECONDS := 60.0

var _out_dir := ""
var _scenario := ""
var _failures: PackedStringArray = []
var _finished := false


func _ready() -> void:
	var args := {}
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--") and "=" in arg:
			args[arg.substr(2).get_slice("=", 0)] = arg.get_slice("=", 1)
	if not args.has("qa"):
		set_process(false)
		return
	_scenario = args["qa"]
	_out_dir = args.get("qa-out", OS.get_user_data_dir().path_join("qa"))
	DirAccess.make_dir_recursive_absolute(_out_dir)
	get_tree().create_timer(TIMEOUT_SECONDS, true, false, true).timeout.connect(_finish.bind("timeout"))
	_run.call_deferred(args["qa"])


## Scenarios about rooms start straight in the first room, without the opening.
func skips_opening() -> bool:
	return not _scenario.is_empty() and _scenario != "cemetery_reveal"


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
	await RenderingServer.frame_post_draw
	var used := Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) - before
	print("[qa] Unknown's sheets: %.1f MiB of video memory, %d animations" % [used / 1048576.0, fresh.frames.get_animation_names().size()])
	_check(used > 0.0 and used < 128.0 * 1048576.0, "Unknown's frames fit 128 MiB")


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


func _check(ok: bool, what: String) -> void:
	print("[qa] %s %s" % ["PASS" if ok else "FAIL", what])
	if not ok:
		_failures.append(what)


func _shot(shot_name: String) -> void:
	await RenderingServer.frame_post_draw
	var path := _out_dir.path_join("%s.png" % shot_name)
	var err := get_viewport().get_texture().get_image().save_png(path)
	_check(err == OK, "screenshot %s" % path)


func _finish(reason: String) -> void:
	if _finished:
		return
	_finished = true
	if reason == "timeout":
		_failures.append("timed out after %d s" % TIMEOUT_SECONDS)
	print("[qa] RESULT %s %s" % ["PASS" if _failures.is_empty() else "FAIL", ", ".join(_failures)])
	get_tree().quit(0 if _failures.is_empty() else 1)
