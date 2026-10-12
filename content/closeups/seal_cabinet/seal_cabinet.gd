extends Closeup
## The Broker's cabinet (plan 008, chapter 1): a heavy seal ring that bites.


func look_ring() -> void:
	await Say.line(&"ch1/tower", &"cabinet_ring_look")


func look_lock() -> void:
	await Say.line(&"ch1/tower", &"cabinet_lock_look")


func look_glass() -> void:
	await Say.line(&"ch1/tower", &"cabinet_glass_look")
