extends Closeup
## The vault's empty lectern (plan 008, chapter 3).


func look_dust() -> void:
	await Say.line(&"ch3/records", &"lectern_dust_look")

func look_chains() -> void:
	await Say.line(&"ch3/records", &"lectern_chains_look")
