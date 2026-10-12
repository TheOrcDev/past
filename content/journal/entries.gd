extends RefCounted
## What the journal shows (plan 005 slice 6; the prologue's from plan 008
## slice 4). The greybox entries stay for the greybox chain.

## A page per memory: its title and the cue of its one line in
## content/dialogue/journal.dialogue.
const MEMORIES := {
	&"cathedral_statue": {"title": "The saint's hand", "cue": &"cathedral_statue"},
	&"prologue_edict": {"title": "The edict", "cue": &"prologue_edict"},
	&"prologue_singer": {"title": "The singer", "cue": &"prologue_singer"},
	&"ch1_wedding": {"title": "The wedding", "cue": &"ch1_wedding"},
	&"ch1_toast": {"title": "A toast", "cue": &"ch1_toast"},
	&"ch1_apprentice": {"title": "The apprentice", "cue": &"ch1_apprentice"},
	&"ch1_old_town": {"title": "The old town", "cue": &"ch1_old_town"},
	&"ch2_petition": {"title": "The petition", "cue": &"ch2_petition"},
	&"ch2_oath": {"title": "The oath", "cue": &"ch2_oath"},
	&"ch2_dedication": {"title": "The dedication", "cue": &"ch2_dedication"},
	&"ch2_quarter": {"title": "The quarter as it was", "cue": &"ch2_quarter"},
	&"ch2_signing": {"title": "The signing", "cue": &"ch2_signing"},
	&"greybox_altar": {"title": "Mercy", "cue": &"greybox_altar"},
	&"greybox_milestone": {"title": "The road as it was", "cue": &"greybox_milestone"},
}

## What Unknown can learn about himself, for the "Who am I?" page.
const FACTS := {
	&"name_u": "My name may start with a U. The rest was smashed off my own grave.",
	&"a_dove": "Somebody who called themselves my dove believed I was happy.",
	&"registrar_order": "A dove paid for my stone. The Registrar ordered my name taken off it.",
	&"moss_on_the_u": "The Gravedigger hid the U under moss, because the dove asked him to.",
	&"the_singer": "The dove was a singer. She sang a list of names in the cathedral.",
	&"memories_not_mine": "The memories I see aren't mine. The wedding was Mathis's. I've been carrying other people's lives.",
	&"i_am_ulric": "My name was Ulric. I was the High Magistrate, and I took the city's names.",
	&"the_flood": "I struck the sluice keepers' names. They forgot the gates, and the lower city drowned.",
	&"my_seal": "The seal on my ring is the seal on the aqueduct, and on every edict.",
	&"high_magistrate": "Someone called the High Magistrate made names a privilege. The city stopped at eleven bells, with his name in the headline.",
}

## Cutscenes that can be watched again: a title, and either the script that
## makes them or the room whose rewatch_<id>() does.
const REWATCH := {
	&"cemetery_reveal": {"title": "The cemetery", "script": "res://content/cutscenes/cemetery_reveal/opening.gd"},
	&"cathedral_statue": {"title": "The saint's hand", "room": &"cathedral_nave"},
	&"prologue_edict": {"title": "The edict", "room": &"ossuary"},
	&"prologue_singer": {"title": "The singer", "room": &"choir_loft"},
	&"old_town_reveal": {"title": "The Nameless Streets", "room": &"cathedral_parvis"},
	&"ch1_wedding": {"title": "The wedding", "room": &"market_square"},
	&"ch1_toast": {"title": "A toast", "room": &"tavern_lost_name"},
	&"ch1_old_town": {"title": "The old town", "room": &"clock_face"},
	&"drowned_quarter_reveal": {"title": "The Drowned Quarter", "room": &"flooded_stair"},
	&"ch2_petition": {"title": "The petition", "room": &"sluice_house"},
	&"ch2_oath": {"title": "The oath", "room": &"drowned_chapel"},
	&"ch2_dedication": {"title": "The dedication", "room": &"aqueduct_foot"},
	&"ch2_quarter": {"title": "The quarter as it was", "room": &"aqueduct_channel"},
	&"ch2_signing": {"title": "The signing", "room": &"valve_house"},
	&"greybox_vista": {"title": "The land beyond", "room": &"greybox_courtyard"},
	&"greybox_milestone": {"title": "The road as it was", "room": &"greybox_courtyard"},
}
