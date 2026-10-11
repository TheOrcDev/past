# Past — Game Design Document

Status: draft, 2026-10-09. The story is deliberately open; it is settled in the
story track (see `roadmap.md`). Confirmed operator decisions are listed in
`decisions.md`, and anything marked *proposal* here still needs the operator's
approval.

## 1. Concept

**Genre:** Point-and-click adventure in the LucasArts / *The Curse of Monkey
Island* tradition: verb coin, inventory, dialogue trees, no deaths, no dead ends.
**Platform:** Desktop. The full game ships as macOS / Windows / Linux downloads,
and the prologue also runs in the browser as a free demo.
**Controls:** Mouse only.
**Length:** Long, in several chapters. The scope is set in the story track.
**Tone:** Dark gothic mystery with dry humor. *Grim Fandango* is the closest
reference: a grim world with wry characters.
**Look:** Monochrome gothic matte paintings with fog, black silhouettes and a
ruined cathedral city. The past is shown in full warm color. Concepts are in
`reference/`.
**Audio:** Fully voiced. Voice, sound effects and music are made with ElevenLabs.

**Logline (draft):** A shadow wakes in a dead, grey city with no memory and no
name, so he calls himself Unknown. The places he passes still remember what they
were, and one flashback at a time they show him who he was.

| Concept | What it shows |
|---|---|
| ![](reference/concept-01-cemetery-vista.png) | Moonlit cemetery above the cathedral city. This is the scale a discovery reveal pulls back to. |
| ![](reference/concept-02-cathedral-now.png) | Cathedral nave now: ruined, grey and flooded. |
| ![](reference/concept-05-cathedral-then.png) | The same nave then, in a flashback: whole, golden, in color. |
| ![](reference/concept-03-swamp-ruins.png) | Drowned forest with a ruined aqueduct. |
| ![](reference/concept-04-city-triptych.png) | City streets, a canal bridge and an archway. |

## 2. Unknown

- **Look:** a lean shadow in the shape of a man, pure black, with glowing white
  eyes. Smoke-like tendrils stream from his shoulders and back like a torn
  cloak. He has no visible mouth and no face detail.
- **Name:** he calls himself Unknown because he does not know who he is.
- **Acting:** without a face, he performs through his eyes (glow strength and
  shape), his posture and his smoke (calm drift, agitation, drooping), plus his
  voice. When he speaks, the eye glow and smoke react to the voice line. Mouth
  lip sync is not needed for him.
- **Personality (proposal):** observant, quiet and dryly funny about his own
  situation. Humor is how he copes. Most of the game's jokes live in his look
  descriptions and dialogue options.
- **Who he really is:** the central mystery. The answer goes in the story bible,
  not in this document.

## 3. Design pillars

1. **Memory is color.** The present is monochrome: grey fog, black silhouettes,
   ruins. The past is in full warm color: gold light, stained glass, life. Every
   flashback floods color back into the world. Confirmed by the operator
   (decision #24). A possible escalation for the story track: as Unknown
   remembers more, some color stays in the present.
2. **Every arrival is a reveal.** A new area opens with a scenic establishing
   shot. The camera pulls back until the whole landscape is visible, then
   settles into the playable room. Flashbacks get the same scenic treatment in
   color.
3. **The past solves the present.** Flashbacks are mostly cinematic, but each
   one carries information: where something was, who someone was, how a
   mechanism worked. A few key flashbacks are playable.
4. **Mouse only, LucasArts rules.** A verb coin, an inventory and dialogue
   trees. No deaths, no dead ends and no pixel hunts: hotspots have hover labels
   and can be revealed.
5. **Dark, never dour.** A grim world told in a wry voice. Everything is voiced
   and subtitled, and every cutscene can be skipped and rewatched.

## 4. Core loop

```
Arrive in a new area → establishing shot (pull-back reveal) → control returns
  → explore: look / use / talk through the verb coin; collect items
  → find a memory anchor (an object or place tied to Unknown's past)
  → flashback: the area in color, as it was (cinematic; sometimes playable)
  → use what the past showed to solve the present-day puzzle
  → the journal records the memory fragment; a new question about Unknown opens
  → the way to the next area opens
```

## 5. World structure

- **Game → chapters → areas → rooms.**
- **Area:** a region with its own landscape vista and its own music theme in two
  arrangements (present and past). It has a few rooms and at least one
  flashback.
- **Room:** one playable screen, sometimes scrolling sideways, in its
  present-day state. Most rooms also carry a **past layer** that flashbacks use.
- Candidate areas from the concepts (not commitments): the moonlit cemetery, the
  cathedral nave, the drowned forest and aqueduct, and the city streets, canals
  and bridges.

## 6. Flashbacks

Operator decision: **mostly cinematic, with a few playable ones.**

| Type | What happens | When |
|---|---|---|
| **Vision** (default) | The room's past layer fades in and the camera moves. Figures from the past act out a moment and Unknown reacts in voice-over. 30–90 s, skippable, rewatchable from the journal. | Most memory anchors |
| **Playable memory** | The past version of the room becomes interactive for a short sequence, with its own hotspots and possibly items. What Unknown learns or does there pays off in the present. | Key story and puzzle beats only |
| **Memory vista** | The landscape in its golden age, shown with a pull-back reveal. | Area and chapter milestones |

**Triggers:** always caused by the player, by examining or using a memory anchor
or by entering a place after a story beat. They are never random and never
interrupt dialogue.

**Look and sound:**

- **In:** Unknown's eyes flare. The sound drops to a heartbeat and a rising
  tone. Color blooms outward from the anchor while the ruins restore in place;
  the now and then images share one composition, so walls rebuild where they
  stand. The music moves to the area's past arrangement.
- **In the past:** a warm grade, a soft vignette, floating dust and slightly
  dreamlike edges.
- **Out:** color drains back toward the anchor, the ruins return, a sting plays,
  and Unknown comments.
- A **Reduce flashing** setting softens the flare.

**People in the past (proposal, decide in the story track).** Show them as
luminous *memory figures*: glowing, featureless silhouettes in warm light, not
fully detailed characters. This fits the theme, since faces are what Unknown
cannot remember. It also matches the silhouette art style and avoids detailed
facial animation. Particular people can gain detail as Unknown remembers them.

**Unknown inside a flashback (open):** an observing shadow in the colored past,
absent, or replaced by his past self. This is a story decision.

## 7. Discovery reveals

- The first entry into an area plays its reveal. It can be skipped and
  rewatched.
- **Shot grammar:** start close on Unknown at the area's threshold. Pull back
  through two or three nested paintings, each covering twice the area of the
  last, until the whole landscape shows. Hold on the area's title card, then
  push back into the first playable room. A variant is a slow pan across a wide
  panorama.
- Letterbox bars (2.39:1) mark every non-interactive sequence.
- **Living painting:** drifting fog layers, parallax between depth layers,
  birds, ash or rain, flickering light and water shimmer.

## 8. Controls (mouse only)

| Action | Mouse |
|---|---|
| Walk | Left-click the ground |
| Leave quickly | Double-click an exit |
| Default action | Left-click a hotspot. Doors open, people talk, everything else is looked at. |
| Verb coin | Press and hold left on a hotspot, then release over Look, Use or Talk |
| Inventory | Right-click. Right-click again or click outside to close it. |
| Use an item on something | Pick the item in the inventory, then left-click a hotspot or another item |
| Drop the held item | Right-click while holding an item |
| Dialogue | Click a line. Left-click skips the line being spoken. |
| Skip a cutscene | Move the mouse to show Skip, then press and hold it |
| Menu | Push the cursor against the top edge to reveal a bar: Journal, Save, Load, Settings, Reveal hotspots, Quit |
| Hint | Click Unknown himself and he thinks aloud about the current goal |

The keyboard is never required.

## 9. Interface

- **Verb coin:** a ring of smoke with three glyphs: an eye (Look), a hand (Use,
  covering take, open and push) and a speech wisp (Talk). Unknown has no mouth,
  so the third glyph is not a mouth.
- **Hover:** the hotspot name appears near the cursor, and the cursor changes
  shape over hotspots and exits.
- **Inventory:** an overlay panel. The exact form, such as a satchel or items
  suspended in Unknown's smoke, is decided in M3. Items can be examined, which
  shows a close-up with a voiced description. They can also be combined, used on
  hotspots or given to people.
- **Dialogue:** branching options. Exhausted options disappear and important
  questions stay. Subtitles are on by default and colored per speaker.
- **Journal:** Unknown's scrapbook. Each recovered memory has a frame from its
  flashback and one voiced line. A *Who am I?* page collects what he has learned
  about himself, and its name field reads "Unknown" until the end. Every
  cutscene, flashback and reveal can be rewatched from here.

## 10. Puzzle design rules

- No deaths and no dead ends.
- Every puzzle can be solved from information in the game. For flashback
  puzzles, the past shows and the present tests.
- Each chapter gets a **puzzle dependency chart** before any art is produced.
- Run several puzzle threads in parallel per area, so one stuck puzzle never
  stops all progress.
- Hints come from Unknown, never from a walkthrough screen.

## 11. Audio direction

- **Present:** sparse and cold. Wind, distant bells, dripping water, crows.
  Music: low strings, choir pads, solo cello, slow tempos.
- **Past:** warm and full. Crowd murmur, birdsong, organ, choir, harp. Music:
  the same themes in warmer arrangements.
- **Voice:** Unknown sounds hollow, quiet and slightly echoing. Every NPC voice
  is distinct.
- Production details are in `audio-pipeline.md`.

## 12. Accessibility and settings

Separate volumes for voice, music, effects and ambience. Subtitles on/off and
size. Text speed. Reduce flashing. Reduce camera motion, which shortens or
crossfades the reveal moves. Fullscreen. Hotspot reveal. Every cutscene is
skippable.

## 13. Story track: open questions

These are settled with the operator before the prologue's script is written.
The draft answers are in `story/bible.md`, built on the operator's "Thief of
names" core (decision #43), and they wait on board #10:

1. Who was Unknown? This is the answer the whole game builds toward.
2. What happened to the city, and why is the present grey and ruined?
3. What is Unknown: a ghost, a shadow torn from someone, a curse? What are the
   rules of his existence?
4. Who else is in the present-day city, and what do they want?
5. How do flashbacks work in the world? Does the city remember, or does Unknown?
6. The chapter list, the areas in each chapter, and the ending.
7. The target play time.

## 14. Scope and production approach

- The game is produced chapter by chapter, and each chapter ends playable in the
  desktop build. The prologue is also the browser demo.
- A **prologue vertical slice** comes first. It measures what a room, a
  flashback, a reveal and a minute of voice-over really cost. That measurement
  turns "a long game" into a number of chapters we can actually make.
