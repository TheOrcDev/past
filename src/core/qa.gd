extends Node
## Scripted smoke runs for builds and the editor. Run the game with
##   -- --qa=sandbox_smoke --qa-out=/absolute/dir
## and it plays a short sequence, saves screenshots, prints a result line and
## quits with exit code 0 on success. Without --qa this node does nothing.

const TIMEOUT_SECONDS := 60.0

var _out_dir := ""
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
	_out_dir = args.get("qa-out", OS.get_user_data_dir().path_join("qa"))
	DirAccess.make_dir_recursive_absolute(_out_dir)
	get_tree().create_timer(TIMEOUT_SECONDS, true, false, true).timeout.connect(_finish.bind("timeout"))
	_run.call_deferred(args["qa"])


func _run(scenario: String) -> void:
	match scenario:
		"sandbox_smoke":
			await _sandbox_smoke()
		_:
			_failures.append("unknown scenario %s" % scenario)
	_finish("done")


func _sandbox_smoke() -> void:
	while Rooms.current == null or Rooms.current.room_id != &"sandbox" or Interaction.locked > 0:
		await get_tree().process_frame
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
