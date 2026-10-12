extends Room
## The upper avenue (plan 008, chapter 3 room 1): the upper city's reveal, and
## the Magistrate's headless statue. docs/story/ch3-puzzles.md. Hotspot verbs
## are methods named <verb>_<hotspot_id>.

const DIALOGUE := &"ch3/city"
const REVEAL := preload("res://content/cutscenes/upper_city_reveal/upper_city_reveal.tscn")


func _on_shown() -> void:
	if not GameState.get_flag(&"ch3_arrived"):
		GameState.set_flag(&"ch3_arrived")
		await Cutscenes.play(rewatch_upper_city_reveal())
		await Say.line(DIALOGUE, &"avenue_arrival")


func rewatch_upper_city_reveal() -> RevealCutscene:
	return RevealCutscene.new(&"upper_city_reveal", REVEAL)


func use_statue() -> void:
	await Say.line(DIALOGUE, &"statue_use")


func look_statue() -> void:
	await Say.line(DIALOGUE, &"statue_look")

func look_plinth() -> void:
	await Say.line(DIALOGUE, &"plinth_look")

func look_lamps() -> void:
	await Say.line(DIALOGUE, &"lamps3_look")
