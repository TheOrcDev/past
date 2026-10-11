extends Cutscene
## The prologue's opening (plan 002 slice 6, on the runner since plan 005 slice
## 2). It opens close on Unknown on the cemetery path, the camera pulls back
## across the zoom stack to the whole vista, and the title card shows. It ends
## on black, ready for the first room. With Reduce camera motion the pull-back
## is one crossfade to the vista.

const STAGE := preload("res://content/cutscenes/cemetery_reveal/cemetery_reveal.tscn")
const FADE_IN := 1.5
const FADE_OUT := 1.0

## The stage while the opening plays (QA and tests look at it).
var stage: Node2D


func _init() -> void:
	id = &"cemetery_reveal"


func run(c: CutsceneSteps) -> void:
	var tree := Engine.get_main_loop() as SceneTree
	stage = STAGE.instantiate()
	# Under the main scene in the game (QA looks for it there); tests have none.
	(tree.current_scene if tree.current_scene else tree.root).add_child(stage)
	stage.reveal.camera.make_current()
	await c.fade(1.0, 0.0)
	c.fade(0.0, FADE_IN)
	if Settings.reduce_camera_motion:
		stage.crossfade_to_vista(c)
	await c.shot(stage.animation, &"reveal")
	await c.fade(1.0, FADE_OUT)
	stage.queue_free()
