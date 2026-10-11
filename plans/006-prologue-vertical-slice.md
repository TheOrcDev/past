# 006 — Prologue vertical slice

Status: written 2026-10-11, one milestone ahead (plans/README.md). Owner:
Claude. It can't start until everything under "Before it starts" is in place.

## Goal

The first area at final quality (`roadmap.md` M5):

- **Content:** the prologue's rooms, at least one flashback of each kind it
  needs, a discovery reveal, and full voice, music and sound.
- **Length:** 10–20 minutes of play.
- **Release:** published to a private itch.io page as desktop downloads, plus
  the same prologue as the browser demo, which fits itch.io's browser limits.

**Exit:** the slice is published, and real production metrics exist: hours and
credits per room, flashback, reveal, and minute of voice. The operator then
sets the number of chapters.

## Before it starts

- **Plan 002's look gate is signed** (decision #31).
- **Plan 003 (voice, music and sound pipeline) is done.** It waits on board
  #4 (the ElevenLabs tier and credit ceiling) and #7 (individual or company).
- **The story track has reached its exit:** the story bible, the prologue's
  puzzle dependency chart, and its full script with voice direction. The
  prologue is never invented on the fly.
- **The operator has set this plan's budgets:** images, ElevenLabs credits,
  and any outside help.

## Depends on

- Plan 004's core: interaction, inventory, dialogue, saves, settings, menus and
  hints.
- Plan 005's toolkit: cutscenes, visions, playable memories, reveals and the
  journal.
- Plan 007's start at the grave and its close-ups. The grave room and the
  gravestone close-up are the prologue's first scene, unless the script
  changes it.

## Not in this plan

- Chapters after the prologue, which wait on the operator's chapter count.
- Platform signing, unless the operator settles board #6 (an Apple Developer
  account) before release.

## Slices

Each slice ends with tests passing, a commit and a push. Rooms, characters and
scenes go one per slice.

### Slice 1 — Production breakdown

1. Turn the script and the puzzle chart into a list:
   - rooms, close-ups, characters and items;
   - each flashback and its kind (vision, playable memory, memory vista);
   - each reveal;
   - each line, with its speaker.
2. Estimate the cost: images (now, then, rings and close-ups), minutes of voice,
   music cues and sound. The operator sets the budgets from it. **STOP** until
   they are set.
3. A puzzle playthrough script, like the greybox one, that the tests and a QA
   scenario will play once the rooms exist.

### Slice 2 onwards — One room at a time

For each room:
1. Image requests, now and then if it has a past, through `tools/images`.
2. Its build script, scaffold, walk area, scale zones, occluders and effects.
3. Its hotspots and exits, its script, and its lines in Dialogue Manager with
   IDs.
4. Its hint goals in `content/hints/goals.gd`.
5. Tests and a QA scenario for the room.

### Characters

For each character in the cast, built the way the story track describes them:
1. A silhouette design.
2. The render pipeline, like Unknown's (decision #32) unless the look gate says
   otherwise.
3. The animations the script needs, and the body's voice reactions.

### Flashbacks, reveals and close-ups

Each one is built with plan 005's toolkit:
- the then images, aligned with the now ones as edits of one composition
  (decision #18);
- the rings for reveals and memory vistas;
- the close-ups;
- the journal entry for each memory.

### Voice, music and sound

- Every line is voiced through plan 003's pipeline: takes, the loudness
  envelope, and subtitles timed to the audio.
- Music per area, with now and then versions, plus ambience and effects. Mixed
  on the buses, with ducking under voice (`audio-pipeline.md` §7).

### Title, continue and credits

A title screen with New game and Continue (from the autosave), plus settings and
credits.

### Builds and release

1. Desktop downloads for macOS, Windows and Linux.
2. The browser demo within itch.io's limits: 500 MB total, 200 MB per file.
3. A private itch.io page. Publishing is an outward action, so it waits for the
   operator's go-ahead.

### Measure and record

1. The prologue played to the end in both builds, by the playthrough script.
2. Frame rate and memory within `technical-plan.md` §10 on a quiet machine.
3. Production metrics: hours and credits per room, flashback, reveal and minute
   of voice.
4. A reel of the slice.

## STOP conditions

- The script leaves a gap the puzzle chart needs filled. Ask the operator; never
  invent story.
- Any budget reaches 80%. Stop and report.
- The browser demo doesn't fit itch.io's limits. Stop and report the options.
- Publishing, or any other outward action, without the operator's go-ahead.

## Definition of done

- The prologue plays start to finish, voiced and scored, in the desktop and
  browser builds.
- It is on a private itch.io page.
- The production metrics are recorded for the operator's chapter decision.

## Effort

XL. Slice 1 turns it into an estimate in hours and credits.

## Execution record
