extends Closeup
## The tavern's slate of debts (plan 008, chapter 1): every name scratched out.


func look_names() -> void:
	await Say.line(&"ch1/streets", &"tally_names_look")


func look_sums() -> void:
	await Say.line(&"ch1/streets", &"tally_sums_look")


func look_sums_right() -> void:
	await look_sums()
