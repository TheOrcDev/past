extends Closeup
## The Plague Doctor's chart of her sleepers (plan 008, chapter 2): no names.


func look_rows() -> void:
	await Say.line(&"ch2/aqueduct", &"chart_rows_look")

func look_names() -> void:
	await Say.line(&"ch2/aqueduct", &"chart_names_look")
