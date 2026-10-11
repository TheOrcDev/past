extends RevealCutscene
## The prologue's opening (plan 002 slice 6, on the runner since plan 005 slice
## 2). It opens close on Unknown on the cemetery path, the camera pulls back
## across the zoom stack to the whole vista, and the title card shows. It
## starts and ends on black, ready for the first room. With Reduce camera
## motion the pull-back is one crossfade to the vista.


func _init() -> void:
	super(&"cemetery_reveal", preload("res://content/cutscenes/cemetery_reveal/cemetery_reveal.tscn"))
	starts_on_black = true
	ends_on_black = true
	fade_in_seconds = 1.5
