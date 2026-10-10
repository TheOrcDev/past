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
- **2026-10-10, slice 2:** the inventory overlay (`src/ui/inventory_panel.gd`).
  - **Opening:** a right-click opens a band of smoke along the bottom with the
    carried items. Another right-click, or a click outside, closes it.
  - **Holding:** left-clicking an item puts it on the cursor (custom cursor), and
    a right-click drops it.
  - **Combining:** left-clicking a second item combines the two, or plays a dry
    fallback line.
  - **Examining:** right-clicking an item shows a close-up and plays its look
    line.
  - **Using:** a held item on a hotspot runs `on_item(item)` or the room's
    `item_<id>(item)`, or falls back.
  - **Tests:** four integration tests. They click item slots directly, because
    GUT's runner panel covers the bottom of the headless screen.
- **2026-10-10, slice 3:** the verb coin (`src/ui/verb_coin.gd`).
  - Holding the left button on a hotspot for 0.3 s opens a drifting ring of
    smoke with three drawn glyphs: an eye, a hand and a speech wisp.
  - Releasing over a glyph runs that verb; releasing elsewhere cancels. A short
    click still runs the default verb, now on release.
  - The hold counts game time, so it agrees with time-scaled tests.
  - Three integration tests, and the coin is in the screenshots scenario.
  - **Also:** the silhouette shader samples its rings inline, because the
    Compatibility renderer objected to passing `TEXTURE` into a function.
- **2026-10-10, slice 4:** exits and cursors.
  - **`Exit`:** a hotspot whose default verb walks there and leaves for
    `target_room` and its entry marker. A double-click leaves at once.
    `new_room.gd` builds one from an `exit` block in a room spec.
  - **Cursors** (drawn in code): a pale dot for walking, a ring over hotspots,
    and an arrow over exits pointing the way out.
  - **Bug fixed:** using an exit left input locked forever. Changing rooms
    freed the exit while `Interaction.use` waited on its verb. Verbs that change
    rooms now defer the change (documented on `Hotspot.handle`), and
    transitions survive `Rooms.clear()`.
  - **Tests:** four.
  - **QA:** a `flashback_clip` scenario records the cathedral memory, and
    `--force-draw` keeps the movie writer fed when the window is covered.
- **2026-10-10, slice 5:** dialogue choices.
  - **API check:** against Dialogue Manager 4.1.0's source. `DialogueLine`
    carries `responses`; each response has `text`, `next_id`, `is_allowed` and
    `static_id`. Response conditions are written `[if expression /]`.
  - **Flow:** `Say` speaks the prompt, then `ChoiceList` (`src/ui`) shows the
    allowed responses as pale lines on a band of smoke. Unknown speaks the one
    picked, and the conversation follows its `next_id`.
  - **Exhausted options:** an option guarded by a `GameState` flag disappears
    once used.
  - **Lint:** responses need an `[ID:]`, because Unknown speaks them.
  - **Tests:** an integration test plays a branching fixture conversation.
- **2026-10-10, slice 6:** saves.
  - **State:** `GameState` holds the full dictionary at `save_version` 2:
    flags (dialogue variables included), the inventory, room states, memories
    seen, hint progress and play time. `to_dict()` and `from_dict()` convert
    it to and from plain JSON values. The cathedral's vision records
    `cathedral_statue` as seen.
  - **Slots:** the `Saves` autoload writes `user://saves/slot_<n>.json` with a
    320×180 thumbnail. A save adds the room, the entry, Unknown's position and
    the era. Loading places him while the screen is still black. Slot 0 is the
    autosave, written when each room is shown, once `main.gd` has started a
    game.
  - **Migrations:** `_migrate_from_<n>` steps up to the current version. Version
    1 (flags and inventory) gains the new fields, and a save naming no room
    resumes in the first room. Newer or broken saves are refused.
  - **Browser:** saves survive a page reload. The `saves` QA scenario saves and
    loads in pass 1, and in pass 2 finds the save and its thumbnail.
    `browser-qa.ts` now marks each pass with `qa-pass=<n>` in the URL.
  - **Tests:** five integration tests cover the round trip, the cursor
    emptying on load, the autosave, migration and refusal. 77 GUT tests pass.
- **2026-10-10, slice 7:** settings.
  - **`Settings`** keeps them in `user://settings.cfg` and applies each as soon
    as it is set:
    - volumes on the Voice, Music, Ambience and SFX buses, re-applied when the
      bus layout changes (plan 003 makes the buses);
    - subtitles on or off, their size, and text speed, read by `Say`;
    - Reduce flashing and Reduce camera motion;
    - fullscreen;
    - Render at 1080p.
  - **Reduce camera motion:** the opening holds the close shot and crossfades
    to the vista at the middle of the move. A vision doesn't drift, and a
    close-up crossfades in full screen without the push.
  - **Render scale became "Render at 1080p".** Godot 4.7 has no 2D render scale
    for the root viewport. The supported lever is the `viewport` stretch mode,
    which draws at 1920×1080 and scales to the window: on a high-DPI screen,
    up to 4× fewer pixels. Going lower would need a SubViewport pipeline, which
    isn't worth it at today's frame rates (`technical-plan.md` §6.9).
  - **Isolation:** a GUT pre-run hook (`test/hooks/pre_run.gd`) and QA runs give
    settings their own file at the defaults, so a player's choices never change
    a test.
  - **Checks:** five integration tests; 82 GUT tests pass. A `reduced_motion`
    QA scenario passes on desktop and in the browser.
- **2026-10-11, slice 8:** the top bar and menus.
  - **`Menus` autoload:** `TopBar` slides down when the cursor pushes against
    the top edge while the player is free to act. It offers Journal, Save,
    Load, Settings, Reveal hotspots and Quit; the browser build has no Quit.
  - **Pages:** each is a `MenuScreen` over the paused game, closed by Esc, a
    right-click or ‹.
    - The save and load pages (`SlotsScreen`) show each slot's thumbnail,
      room, date and play time. Saving over a used slot takes a second click.
      The load page starts with the autosave, and empty slots can't be picked.
    - The settings page (`SettingsScreen`) has sliders and click-to-cycle
      choices.
    - The journal is a placeholder, and Quit asks first.
  - **Thumbnails:** the save page captures the game a frame after the bar
    hides, so the menu never appears in the picture. `Saves.save()` takes that
    picture.
  - **Reveal hotspots:** marks every usable hotspot for 2.6 s, with the cursor's
    ring or exit arrow and the name, kept on screen.
  - **Fix:** `Interaction` lets go of the custom cursor at shutdown. The
    renderer used to report a leaked texture when the game quit.
  - **Checks:** six integration tests; 88 GUT tests pass. A `menus` QA scenario
    passes on desktop and in the browser.
- **2026-10-11, slice 9:** the hint on Unknown.
  - **Asking:** clicking Unknown runs `Hints.ask()`. Actors now hit-test the
    trimmed box of their current frame (`Actor.contains_point`), and hovering
    Unknown shows his name with the ring cursor.
  - **Goals:** `content/hints/goals.gd` lists them in order: read the stone
    (`tombstone_read`, set by the inscription), find the cathedral
    (`cathedral_visited`, set on entering), touch the statue (the
    `cathedral_statue` memory). This is a placeholder chain until the
    prologue's script.
  - **Lines:** `content/dialogue/hints.dialogue` holds three per goal, each more
    direct, plus `none`. The count of asks lives in `GameState.hints`, so it
    saves.
  - **Checks:** four integration tests; 92 GUT tests pass. The `grave` QA
    scenario now asks for a hint after the stone and gets the cathedral one,
    on desktop and in the browser.

