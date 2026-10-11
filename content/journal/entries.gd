extends RefCounted
## What the journal shows (plan 005 slice 6). Placeholder wording until the
## prologue's script.

## A page per memory: its title and the cue of its one line in
## content/dialogue/journal.dialogue.
const MEMORIES := {
	&"cathedral_statue": {"title": "The saint's hand", "cue": &"cathedral_statue"},
	&"greybox_altar": {"title": "Mercy", "cue": &"greybox_altar"},
	&"greybox_milestone": {"title": "The road as it was", "cue": &"greybox_milestone"},
}

## What Unknown can learn about himself, for the "Who am I?" page.
const FACTS := {
	&"name_u": "My name may start with a U. The rest was smashed off my own grave.",
	&"a_dove": "Somebody who called themselves my dove believed I was happy.",
}

## Cutscenes that can be watched again: a title, and either the script that
## makes them or the room whose rewatch_<id>() does.
const REWATCH := {
	&"cemetery_reveal": {"title": "The cemetery", "script": "res://content/cutscenes/cemetery_reveal/opening.gd"},
	&"cathedral_statue": {"title": "The saint's hand", "room": &"cathedral_nave"},
	&"greybox_vista": {"title": "The land beyond", "room": &"greybox_courtyard"},
	&"greybox_milestone": {"title": "The road as it was", "room": &"greybox_courtyard"},
}
