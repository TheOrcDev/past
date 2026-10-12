extends Closeup
## The Magistrate's desk, close (plan 008, chapter 3).


func look_book() -> void:
	await Say.line(&"ch3/records", &"desk_book_look")

func look_inkwell() -> void:
	await Say.line(&"ch3/records", &"desk_inkwell_look")

func look_blotter() -> void:
	await Say.line(&"ch3/records", &"desk_blotter_look")
