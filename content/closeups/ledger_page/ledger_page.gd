extends Closeup
## The Ledger's first and last lines (plan 008, chapter 4).


func look_last() -> void:
	await Say.line(&"ch4/finale", &"ledger_page_look")

func look_first() -> void:
	await Say.line(&"ch4/finale", &"ledger_first_look")
