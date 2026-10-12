extends Closeup
## The lamplighter's tally wall (plan 008, chapter 1): one mark for every name
## he can't remember.


func look_marks() -> void:
	await Say.line(&"ch1/streets", &"ledger_marks_look")


func look_last() -> void:
	await Say.line(&"ch1/streets", &"ledger_last_look")
