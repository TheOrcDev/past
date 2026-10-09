class_name ActorBody
extends Node2D
## How an Actor looks. Subclasses play `<anim>_<dir>` animations; the Actor
## chooses names and mirroring through AnimNames.

signal animation_finished(anim: StringName)


func has_animation(_anim: StringName) -> bool:
	return false


func play_animation(_anim: StringName, _flip: bool) -> void:
	pass
