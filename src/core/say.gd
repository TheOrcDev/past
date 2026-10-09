extends Node
## Speaks Dialogue Manager lines over the speaking actor (docs/technical-plan.md
## §5.6). This is the placeholder balloon: text above the speaker, held for a
## time based on its length, skipped with a left click. Voice joins in plan 003
## and choices in plan 004.

signal line_started(static_id: String, speaker: String, text: String)
signal line_finished(static_id: String)

const DIALOGUE_PATH := "res://content/dialogue/%s.dialogue"

var speaking := false

var _label: Label
var _skip := false


func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 60
	add_child(layer)
	_label = Label.new()
	_label.add_theme_font_size_override(&"font_size", 36)
	_label.add_theme_color_override(&"font_outline_color", Color.BLACK)
	_label.add_theme_constant_override(&"outline_size", 12)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.custom_minimum_size.x = 900.0
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.visible = false
	layer.add_child(_label)


## Runs a cue from content/dialogue/<file>.dialogue.
func line(file: StringName, cue: StringName) -> void:
	var resource := load(DIALOGUE_PATH % file) as DialogueResource
	if resource == null:
		push_error("Dialogue not found: %s" % file)
		return
	await run(resource, String(cue))


## One of Unknown's dry answers when nothing handles a verb.
func fallback(verb: StringName) -> void:
	await line(&"core", StringName("fallback_%s" % verb))


func run(resource: DialogueResource, cue: String) -> void:
	speaking = true
	Interaction.locked += 1
	var current: DialogueLine = await DialogueManager.get_next_dialogue_line(resource, cue)
	while current != null:
		if not current.responses.is_empty():
			push_warning("Dialogue choices arrive in plan 004; stopping at %s" % current.static_id)
			break
		await _speak(current)
		current = await DialogueManager.get_next_dialogue_line(resource, current.next_id)
	_label.visible = false
	Interaction.locked -= 1
	speaking = false


## Ends the line on screen now, as a click does.
func skip() -> void:
	_skip = true


func _unhandled_input(event: InputEvent) -> void:
	if speaking and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		skip()


func _speak(dialogue_line: DialogueLine) -> void:
	var actor := _actor_named(dialogue_line.character)
	_label.text = dialogue_line.text
	_label.add_theme_color_override(&"font_color", actor.subtitle_color if actor else Color.WHITE)
	_label.reset_size()
	_place_over(actor)
	_label.visible = true
	line_started.emit(dialogue_line.static_id, dialogue_line.character, dialogue_line.text)
	await _hold(clampf(1.2 + dialogue_line.text.length() * 0.055, 2.0, 9.0))
	line_finished.emit(dialogue_line.static_id)


## Waits `seconds` of game time (so Engine.time_scale applies) or until skipped.
func _hold(seconds: float) -> void:
	_skip = false
	var elapsed := 0.0
	while not _skip and elapsed < seconds:
		await get_tree().process_frame
		elapsed += get_process_delta_time()


func _actor_named(speaker: String) -> Actor:
	if Rooms.current == null:
		return null
	for child in Rooms.current.actors.get_children():
		if child is Actor and child.speaker_name == speaker:
			return child
	return null


func _place_over(actor: Actor) -> void:
	var view := get_viewport().get_visible_rect().size
	var anchor := Vector2(view.x / 2.0, 160.0)
	if actor:
		anchor = actor.get_global_transform_with_canvas() * actor.speech_offset
	_label.position = Vector2(
		clampf(anchor.x - _label.size.x / 2.0, 20.0, view.x - _label.size.x - 20.0),
		clampf(anchor.y - _label.size.y, 20.0, view.y - _label.size.y - 20.0))
