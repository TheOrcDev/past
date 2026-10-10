# 004 — Point-and-click core: verb coin, inventory, dialogue, saves, settings

Status: written 2026-10-10. Owner: Claude. Started on the operator's
instruction to continue through all slices (2026-10-10). Plan 002's look review
(#31, with Unknown rebuilt under #32) runs alongside.

## Goal

Finish our adventure core on top of the plan 001 skeleton, so that a short
puzzle chain can be played start to finish with the mouse alone, on desktop
and in the browser build (`roadmap.md` M3). The rules come from
`game-design.md` §8–10 and `technical-plan.md` §5.4–5.7 and §6.6–6.9.

## Depends on

- Plan 001's core: rooms, actors, hotspots, `Interaction`, `Say`, `GameState`.
- Plan 002's Unknown: one-shot animations (`pickup_*`, `use`, `give`), the
  `grab`, `use` and `give` events, and `SpriteBody.hold`.

## Not in this plan

- Voice and the `Voice` envelope (plan 003).
- The journal and a general cutscene runner with rewatching (plan 005). This
  plan only needs the opening to be skippable.
- Story, final rooms and final art (plan 006 and the story track). The puzzle
  chain here is greybox.

## Slices

Each slice ends with tests passing, a commit and a push.

### Slice 1 — Inventory core

1. An `ItemDef` resource: id, name, icon, look line, and its combinations
   (item id → result item id, or a dialogue cue).
2. An `Inventory` autoload with `add`, `remove`, `has`, `items`, the `held`
   item, and signals for the UI.
3. Its contents live in `GameState`, so they save with everything else.
4. Unit tests.

### Slice 2 — Inventory overlay

1. A right-click opens an overlay. Recommended form: items suspended in
   Unknown's smoke, as dark glass-like icons with names on hover. A right-click
   again, or a click outside, closes it.
2. Picking an item makes it the held item, and the cursor shows it.
3. A held item used on a hotspot calls `on_item(item)` (or the room's
   `item_<hotspot>(item)`); used on another item it combines; a right-click
   drops it.
4. Examining an item shows a close-up and speaks its look line.
5. Integration tests with synthetic input.

### Slice 3 — Verb coin

1. Holding the left button for 300 ms or more on a hotspot opens a coin of
   smoke with three glyphs: an eye (Look), a hand (Use) and a speech wisp (Talk).
2. Releasing over a glyph runs that verb; releasing elsewhere cancels.
3. A short click still runs the default verb.
4. Tests for the threshold, the glyph hit areas and cancelling.

### Slice 4 — Hover, cursors and exits

1. Cursor shapes for walking, hotspots and exits.
2. The hotspot label follows the cursor without leaving the screen.
3. A double-click on an exit leaves at once.
4. Tests.

### Slice 5 — Dialogue choices

1. Check Dialogue Manager 4.1.0's response API against its source.
2. Our balloon shows the line over the speaker in that speaker's colour (as
   `Say` does now) and lists choices as smoke-edged lines.
3. Exhausted options disappear and important ones stay (`GameState` flags).
4. Integration tests with a branching test conversation.

### Slice 6 — Saves

1. `GameState` grows to the full versioned dictionary in `technical-plan.md`
   §5.7: flags, inventory, room and entry, era, memories seen, hint progress
   and dialogue variables.
2. Save slots as JSON at `user://saves/slot_<n>.json`, each with a thumbnail,
   plus an autosave on every room change.
3. Migrations keyed by `save_version`.
4. Check that browser storage persists across a reload (IndexedDB behind
   `user://`).
5. Round-trip and migration tests.

### Slice 7 — Settings

1. A `Settings` autoload stored in `user://settings.cfg`. It holds:
   - volumes (voice, music, ambience, effects);
   - subtitles and their size;
   - text speed;
   - Reduce flashing and Reduce camera motion;
   - fullscreen;
   - render scale.
2. Each setting applies live (`Flashback.reduce_flashing`, window mode, canvas
   scale and so on).
3. Tests.

### Slice 8 — Top bar and menus

1. Pushing the cursor against the top edge reveals a bar: Journal (a
   placeholder until plan 005), Save, Load, Settings, Reveal hotspots, Quit.
2. Save and load screens show the slots with their thumbnails. The settings
   screen covers slice 7.
3. Reveal hotspots marks every hotspot briefly.
4. Tests.

### Slice 9 — Hint on Unknown

1. Clicking Unknown makes him think aloud about the current goal.
2. Hint lines are keyed by `GameState` progress and get more direct when asked
   again.
3. Tests.

### Slice 10 — Skipping

A held Skip button, shown when the mouse moves, fast-forwards the opening; Esc
also works. This uses the opening's existing fast-forward. Plan 005
generalises it to every cutscene.

### Slice 11 — Greybox puzzle chain

1. Two or three greybox rooms. They are cheap value-study images with real
   walk areas, hotspots and exits.
2. A small puzzle chain that needs every verb, an item combination, a dialogue
   choice and a flashback clue.
3. An integration test plays it to the end with synthetic mouse input.
4. A QA scenario does the same in the desktop and browser builds.

### Slice 12 — Measure and record

1. The desktop and browser builds both finish the chain.
2. Frame rate and memory still hold the plan 002 budgets.
3. Record the chain with the movie writer, and update the docs and decisions.

## STOP conditions

- Dialogue Manager's API differs from what the balloon needs. Check the pinned
  source and adapt; do not fork the addon without a plan change.
- Browser saves do not persist across a reload. Stop and report the options.
- The verb coin's feel (hold time, size) needs the operator. Ship the
  recommended defaults, record them, and adjust after the operator's review.

## Definition of done

- The greybox chain can be finished with the mouse alone, on desktop and in the
  browser build.
- Saves, settings, skipping and the hint work in both builds.
- The core's unit and integration tests pass.

## Effort

About 4–6 working sessions.

## Execution record
- **2026-10-10, slice 1:** `ItemDef` (id, name, icon, look line, combinations)
  and the `Inventory` autoload: `add`, `remove`, `has`, `items`, `hold`,
  `drop`, and `combine`, which works either way round. Carried ids live in
  `GameState.inventory`. Three unit tests.
