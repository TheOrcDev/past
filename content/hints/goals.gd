extends RefCounted
## The goals Unknown's hints follow (src/systems/hints.gd), in order. A goal is
## current until its flag is set or its memory seen. A placeholder chain until
## the prologue's script: read the grave, find the cathedral, touch the statue.

const GOALS: Array[Dictionary] = [
	{"goal": &"stone", "flag": &"tombstone_read"},
	{"goal": &"cathedral", "flag": &"cathedral_visited"},
	{"goal": &"statue", "memory": &"cathedral_statue"},
]
