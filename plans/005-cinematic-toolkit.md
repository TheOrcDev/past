# 005 — Cinematic toolkit: cutscenes, flashbacks, reveals, journal

Status: written 2026-10-11, one milestone ahead (plans/README.md). Owner:
Claude. Started 2026-10-11, once plan 004 was done.

## Goal

The toolkit that every story beat in the prologue (plan 006) is built from
(`roadmap.md` M4, `technical-plan.md` §6.1–6.3 and §6.7):

- **Cutscenes:** a cutscene runner with letterbox, skip and rewatching.
- **Flashbacks:** all three kinds, vision, playable memory and memory vista.
- **Reveals:** the discovery-reveal template.
- **Journal:** keeps the memories and lets the player rewatch.

**Exit:** one of each runs in the desktop build and in the browser build.

## Depends on

- Plan 002: `Flashback.vision`, `Reveal`, `Letterbox`, the cemetery opening.
- Plan 004: `Interaction`, `Say`, saves and settings (Reduce flashing, Reduce
  camera motion), the Skip button, the top bar's journal page (a placeholder
  until this plan), and the greybox rooms.

## Not in this plan

- **Story content** is plan 006 and the story track. Everything here is
  demonstrated on the existing rooms and the greybox chain, with placeholder
  lines.
- **Voice** is plan 003. Lines keep text timing until then.
- **Paid images.** This plan has no image budget. Any art it needs, such as a
  memory vista's rings or journal frames, is drawn in code or reuses accepted
  images. If real art becomes necessary, that is a STOP condition.

## Slices

Each slice ends with tests passing, a commit and a push.

### Slice 1 — Cutscene runner

1. A cutscene is a script with `run(c)` that awaits steps on `c`:
   - `c.walk(actor, point)`, `c.face(actor, point)`, `c.anim(actor, base)`;
   - `c.say(file, cue)`, `c.wait(seconds)`;
   - `c.shot(camera, animation)`, `c.fade(alpha, seconds)`, `c.era(room, era)`.
2. The `Cutscenes` autoload plays one:
   - it locks `Interaction` and brings the letterbox bars in;
   - it hands control back when `run` returns.
3. Tests: steps run in order, input stays locked throughout, and the bars come
   and go.

### Slice 2 — Skipping every cutscene

1. Plan 004's Skip button (a 0.6 s hold) and Esc skip any cutscene, not only
   the opening.
2. Skipping fast-forwards. Every step after the skip finishes at once:
   - walks teleport to their end;
   - lines stop;
   - animations seek to their end;
   - tweens and camera paths complete.

   The script's own logic still runs, so the world ends exactly as a watched
   run leaves it.
3. The opening moves onto the runner and keeps its Reduce camera motion
   crossfade.
4. Tests: a skipped cutscene and a watched one leave identical `GameState` and
   positions.

### Slice 3 — Visions on the runner

1. `Flashback.vision(id, …)` becomes a cutscene named by its memory id. The
   transition in, the past, the lines and the transition out are its steps.
2. Finishing a vision, watched or skipped, records the memory in `GameState`.
   This replaces the room scripts' own `GameState.remember` calls.
3. A skipped vision returns to the present at once, in the right era, with
   Unknown where he stood.
4. The cathedral statue and the greybox altar use it.
5. Tests.

### Slice 4 — Playable memory

1. `Flashback.enter_memory(id, room, done)` switches the room to the past for
   play. Unknown walks and uses the past's hotspots and walk area. It returns
   when `done` (a flag, or a callable) holds, then transitions back.
2. Then-era hotspots and walk areas come from the room spec (`era` on
   hotspots, `walk.then`). Extend `new_room.gd` only if a piece is missing.
3. A greybox playable memory in the chapel: in the past, find something that
   only exists then. It must be a clue the present needs.
4. Tests and a QA scenario.

### Slice 5 — Discovery reveal and memory vista

1. **Discovery reveal:** a template for a pull-back reveal as a cutscene, so it
   gets letterbox, skip, rewatch and the Reduce camera motion crossfade.
   `new_reveal.gd` builds its scene from a spec.
2. **Memory vista:** a reveal played in the then era. A greybox vista with
   rings drawn in code demonstrates it.
3. Tests: a reveal skipped and a reveal watched end the same way, and Reduce
   camera motion cuts instead of travelling.

### Slice 6 — Journal

1. **Memories:** the top bar's journal page lists them, one page each.
   - Each page has a still and one line.
   - The still is captured from the flashback when it is first seen, and kept
     in `user://journal/` beside the save data.
2. **Who am I?:** a page built from facts recorded in `GameState`. Its name
   field reads "Unknown" until the end.
3. **Rewatch:** every registered cutscene the player has seen can be played
   again from the journal. Rewatching never changes `GameState`.
4. Tests.

### Slice 7 — Measure and record

1. One of each kind (a cutscene, a vision, a playable memory, a reveal, a
   memory vista and the journal) runs in the desktop build and in the browser
   build.
2. Frame rate and memory hold the budgets in `technical-plan.md` §10.
3. Record a short reel of the toolkit with the movie writer. Update the docs
   and decisions.

## STOP conditions

- A step can't fast-forward without leaving the world different from a watched
  run. Stop and report which, rather than special-casing skips in scripts.
- The browser build can't do something the toolkit needs, such as a capture
  for the journal's stills or a crossfade. Stop and report the options.
- Real art becomes necessary (a memory vista that code-drawn rings can't
  stand in for). Ask the operator for an image budget.

## Definition of done

- One of each kind runs, and can be skipped, in both builds.
- Skipped and watched cutscenes leave the same world.
- The journal shows every memory seen and rewatches every cutscene seen.
- The unit and integration tests pass.

## Effort

About 4–6 working sessions.

## Execution record
- **2026-10-11, slice 1:** the cutscene runner.
  - **Pieces:** `Cutscene` (a script whose `run(c)` awaits steps) and
    `CutsceneSteps`, whose steps are walk, face, anim, say, wait, shot, fade
    and era. The `Cutscenes` autoload plays a scene with input locked, the
    letterbox bars in and its own Skip button armed.
  - **A skip** makes the step under way and every later one finish at once:
    - walks put the actor where the walk would have ended;
    - lines run through without holding, through the new
      `Say.fast_forward`, so their mutations still happen;
    - waits end and fades snap;
    - shots jump to their last frame.
  - **Skip button:** it can now `reset()` between scenes.
  - **Tests:** two integration tests. A watched scene runs its steps in order
    with input locked and the bars in, and a skipped one ends in the same
    state: the same flag set, and Unknown where the walk ends. 96 GUT tests
    pass.
  - **Drafted early:** the code was written while the operator had the Mac,
    and tested once testing resumed.
- **2026-10-11, slice 2:** skipping every cutscene.
  - **One Skip:** the runner's Skip button (a 0.6 s hold) and Esc skip any
    cutscene, through the fast-forward built in slice 1.
  - **The opening on the runner:** `cemetery_reveal.tscn` is now a passive
    stage: the zoom stack, Unknown, the pull-back animation and the title.
    `opening.gd` plays it as a cutscene: it fades in, plays the pull-back as a
    shot, then fades to black. The stage keeps the Reduce camera motion
    crossfade. Its own fade, letterbox and Skip button are gone.
  - **Hand-off:** `main.gd` plays the opening through `Cutscenes`. Once the
    first room's own fade has taken over, `Cutscenes.clear_fade()` drops the
    opening's black.
  - **Tests:**
    - the opening's tests now run it on the runner: watched to black with
      the title shown, a full hold of Skip, and a short press against Esc;
    - a new test finds a skipped scene and a watched one leave the same
      `GameState` (all but play time) and the same position.

    97 GUT tests pass. The `cemetery_reveal`, `skip` and `reduced_motion` QA
    scenarios pass on desktop and in the browser.
- **2026-10-11, slice 3:** visions on the runner.
  - **`Vision`:** a cutscene named by its memory id.
    `Flashback.vision(id, room, anchor, during)` plays it.
    `Flashback.open_past()` and `close_past()` are its steps, and `during`
    gets the cutscene's steps, so the lines and waits inside the past skip
    too.
  - **Skipping:** a skipped vision steps its transition tweens straight to
    their end (`Tween.custom_step`). The room is in the present at once, with
    the dissolve cleared and Unknown where he stood.
  - **Memories:** finishing a vision, watched or skipped, records its memory.
    The cathedral statue and the greybox altar no longer call
    `GameState.remember` themselves.
  - **Letterbox:** visions now have the letterbox bars, like every
    non-interactive scene (`technical-plan.md` §6.3).
  - **Tests:** two new ones check that a vision records its memory and that a
    skipped vision returns to the present at once. 99 GUT tests pass. The
    `greybox` and `screenshots` QA scenarios pass on desktop, and `greybox`
    passes in the browser.
- **2026-10-11, slice 4:** playable memory.
  - **`Flashback.enter_memory(id, room, anchor, done)`:** the past blooms in
    as a short cutscene, through `StepsCutscene`, which runs a callable as its
    steps, and with no camera drift. Then the room stays in the past era for
    play. Unknown walks the past's walk area and uses its era-tagged
    hotspots, and the room's exits are shut. When `done` holds (a flag, or a
    callable), the past drains back, the exits return and the memory is
    recorded.
  - **No saving inside a memory:** the top bar stays shut, because a save
    there couldn't resume.
  - **The greybox altar** now steps into the chapel's past instead of showing
    a vision. There a then-only "Carving" hotspot gives the word. The room
    spec needed nothing new: `era` on hotspots and `walk.then` were already
    there. The cathedral statue stays a vision, so both kinds are in the game.
  - **Tests:** a new test covers the past being playable, the exits and menu
    shut, and the return once done. The greybox chain's playthrough plays the
    memory. 100 GUT tests pass, and `greybox` passes on desktop and in the
    browser.
- **2026-10-11, slice 5:** discovery reveal and memory vista.
  - **`RevealStage`:** a stage built by `new_reveal.gd`, now its default
    script. It took over the cemetery stage's title and Reduce camera motion
    crossfade.
  - **`RevealCutscene`** plays any stage as a cutscene. In the middle of play
    it fades out of the room and back. The opening is a `RevealCutscene` that
    starts and ends on black.
  - **Memory vista:** a `RevealCutscene` with era "then" plays under the
    past's grade and records its memory.
  - **The greybox vista:** two rings drawn in code by
    `art-source/work/greybox/build.py`: mountains, a town with a tower, and a
    road from the courtyard. Using the courtyard's way on plays it as a
    discovery reveal. Using the new milestone plays it as a memory vista.
  - **Bug found:** a reveal in the middle of play left the view where its
    freed camera had been. The reveal now switches its camera off and hands
    the view back to the room.
  - **Tests:** four new ones:
    - a reveal in play returns to the room;
    - a skip ends as a watch does;
    - the memory vista uses the past's grade and is remembered;
    - Reduce camera motion cuts between the close shot and the vista with no
      travel.

    103 GUT tests pass. A `vista` QA scenario passes on desktop and in the
    browser.

