extends RefCounted
## The goals Unknown's hints follow (src/systems/hints.gd), in order. A goal is
## current until its flag is set or its memory seen. The prologue's chain is in
## docs/story/prologue-puzzles.md (plan 008 slice 4); each chapter's follows.

const GOALS: Array[Dictionary] = [
	{"goal": &"stone", "flag": &"tombstone_read"},
	{"goal": &"gravedigger", "flag": &"gd_met"},
	{"goal": &"register", "flag": &"register_read"},
	{"goal": &"ossuary_key", "flag": &"got_ossuary_key"},
	{"goal": &"crypt", "flag": &"ossuary_open"},
	{"goal": &"glass", "flag": &"got_lantern_glass"},
	{"goal": &"mend", "flag": &"gd_lantern_mended"},
	{"goal": &"sister", "flag": &"sister_met"},
	{"goal": &"dove", "flag": &"sister_dove"},
	{"goal": &"book_request", "flag": &"sister_wants_book"},
	{"goal": &"singer", "memory": &"prologue_singer"},
	{"goal": &"book", "flag": &"got_hymn_book"},
	{"goal": &"west_key", "flag": &"got_west_door_key"},
	{"goal": &"doors", "flag": &"west_doors_open"},
]
