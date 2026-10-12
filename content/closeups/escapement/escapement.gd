extends Closeup
## The clock's escapement (plan 008, chapter 1): a loose pin, and a wheel with
## a hundred teeth.


func look_wheel() -> void:
	await Say.line(&"ch1/tower", &"wheel_look")


func look_pin() -> void:
	await Say.line(&"ch1/tower", &"pin_look")
