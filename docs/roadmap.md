# Past — Roadmap

Every milestone ends in something the operator can play or watch in a desktop
build and in the browser demo build. The full game ships on desktop, and the
prologue doubles as the free browser demo (decision #20). The order puts the
biggest risks first:

1. Can the GPT-image + Claude pipeline produce this look, with an animated
   Unknown, at a cost we can sustain?
2. Can our own adventure core on Godot carry the interface and the cinematics,
   on desktop and in the browser demo?
3. Do ElevenLabs voices hold up across a long game?

Plans are written one milestone ahead. Plans 001–003 exist now. Plan 004 onward
is written when the milestone before it closes, because each one depends on what
the spikes measure.

## M0 — Foundations · [plan 001](../plans/001-foundations.md)

- A git repository with LFS, pinned Godot 4.7.2, Dialogue Manager 4 and GUT,
  and the project settings from `technical-plan.md`.
- The walking skeleton of our adventure core: rooms, walking with depth scaling,
  hotspots and a Dialogue Manager line.
- macOS and browser export presets, a local web server script and a headless
  test runner.
- A placeholder room where a placeholder Unknown walks and one hotspot answers
  Look.

**Exit:** that room runs as a macOS app and in a local Chrome tab, and the
headless tests pass.

## M1 — First light: the look · [plan 002](../plans/002-first-light-look-spike.md)

The "does it look like *Past*?" milestone.

- The cathedral nave at final quality as a living painting, with both the now
  and then versions.
- Unknown idling and walking (right, up and down, with left mirrored), with his
  eyes and smoke tendrils.
- Clicking a memory anchor plays the flashback: color blooms and the ruins
  restore, then the reverse.
- A 20–30 s pull-back reveal through a nested zoom stack.

**Exit:** 60 fps on the operator's Mac in the macOS build and in the browser
build, with a time log per asset. **Gate:** the operator approves the look and Unknown's animation
route (decision #17).

## M2 — Voice of the world · [plan 003](../plans/003-voice-of-the-world-audio-spike.md)

- A scripted ElevenLabs pipeline with a manifest and a cache.
- Unknown's voice and one NPC voice, chosen by the operator. 20–30 lines with
  subtitles, and voice-reactive eyes and smoke.
- Ambience loops and one-shot effects.
- The cathedral theme in a now and a then arrangement.

**Exit:** all of it plays in the M1 cathedral in the browser and desktop builds,
and the credit spend is logged against the ceiling.

M2 does not depend on M1's art and can run in parallel.

## M3 — Point-and-click core · plan 004

This is the rest of our adventure core, on top of the M0 skeleton:

- The verb coin, inventory, item combination and dialogue trees (Dialogue
  Manager with our own balloon and choice UI).
- Hotspot labels and hotspot reveal.
- Save and load (desktop and browser storage), settings, skipping, and a hint
  when you click Unknown.

**Exit:** a 2–3 room greybox puzzle chain can be finished with the mouse alone,
on desktop and in the browser. The core's unit and integration tests pass.

## M4 — Cinematic toolkit · plan 005

- The flashback system (vision, playable memory, memory vista).
- The discovery-reveal template.
- A cutscene runner with skip, letterbox and rewatching from the journal.
- The Reduce flashing and Reduce camera motion settings.

**Exit:** one of each runs in the desktop and browser builds.

## S — Story track (parallel, starts once M1's look is approved)

- A story bible that answers `game-design.md` §13.
- A chapter outline with areas, flashbacks and reveals.
- The cast and their silhouettes.
- The prologue's puzzle dependency chart and its full script, with voice
  direction.

Run this as interview sessions with the operator (`grill-me`). Claude drafts and
the operator decides.

**Exit:** the prologue can be produced without inventing story on the fly.

## M5 — Prologue vertical slice · plan 006

- The first area at final quality: rooms, at least one flashback of each type it
  needs, a discovery reveal, full voice, music and sound.
- 10–20 minutes of play.
- Published to a private itch.io page as desktop downloads, plus the same
  prologue as the browser demo, which fits itch.io's browser limits.

**Exit:** the slice is published, and real production metrics exist (hours and
credits per room, flashback, reveal and minute of voice). The operator then sets
the number of chapters.

## M6 — Production hardening

- Content lint: every spoken line voiced, every hotspot described, every room
  walkable.
- Automated imports.
- Save versioning.
- Build and deploy automation (`butler` for itch.io).

## M7+ — Chapters

One milestone per chapter:

1. script;
2. puzzle chart;
3. greybox;
4. image requests;
5. assembly;
6. voice;
7. polish;
8. playtest.

Each chapter ships playable.

## Release

- Performance and size budgets.
- Store pages with AI-content disclosure, using the receipts and manifests.
- macOS signing and notarization (Apple Developer account), Windows and Linux
  builds.
- Steam integration through GodotSteam (desktop only), if Steam is a store.
- Launch.
