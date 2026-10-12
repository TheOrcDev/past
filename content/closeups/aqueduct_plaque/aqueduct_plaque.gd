extends Closeup
## The aqueduct's dedication plaque (plan 008, chapter 2): the words gone, the seal sharp.


func look_seal() -> void:
	await Say.line(&"ch2/aqueduct", &"seal_closeup_look")

func look_words() -> void:
	await Say.line(&"ch2/aqueduct", &"plaque_words_look")
