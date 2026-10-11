# QA — plan 004, the point-and-click core

Slice 12's measurements, 2026-10-11.

## Files

| File | What it shows |
|---|---|
| `greybox-chain.mp4` | The greybox puzzle chain played to the end at reading pace, 97 s at 1080p from the `greybox_clip` QA scenario: every verb, the rag and oil combined, the gatekeeper's choice, the flashback that shows "MERCY", the gate opening and the courtyard. |

## The exported macOS app

A fresh release export ran every scripted scenario. All passed:

| Scenario | What it covers |
|---|---|
| `greybox` | The greybox puzzle chain to the end: every verb, an item combination, a dialogue choice, a flashback clue |
| `saves`, then `saves --qa-pass=2` | Save, change room, load back; then, in a second launch, the save and its thumbnail are still there |
| `reduced_motion` | The opening crossfades instead of pulling back; the close-up crossfades in without a camera push |
| `skip` | Holding Skip fast-forwards the opening to the grave |
| `grave` | The start, the gravestone close-up, its lines, the hint after the stone, the exits both ways |
| `menus` | The top bar, Reveal hotspots, and the save, load, settings, journal and quit pages |

## Frame time at 1080p

`build/macos/Past.app/Contents/MacOS/Past --resolution 1920x1080 -- --qa=perf`,
second of two runs, on the Apple M4. The display runs at 120 Hz, so a frame of
8.3 ms is the display's own pace.

| Part | Mean | 95th percentile | Worst | Frames over 17.2 ms |
|---|---|---|---|---|
| Opening (15 s) | 9.9 ms | 16.7 ms | 150 ms, on the first frame, under black | 58 |
| Gravestone close-up (3.4 s) | 8.1 ms | 9.3 ms | 20.9 ms | 1 |
| Nave, walking (9 s) | 8.4 ms | 10.4 ms | 78.2 ms, once | 4 |
| Flashback (12.8 s) | 8.2 ms | 10.0 ms | 22.2 ms | 1 |

- **Video memory:** 222.2 MiB, within the 400 MiB budget per room
  (`technical-plan.md` §10). Unknown's sheets (decision #32) are most of it.
- **Render CPU:** about 5 ms per frame at the 95th percentile.
- **The opening's slow frames** fall in its first second, while the shaders
  compile under black, as in plan 002.
- **A first, wrong measurement:** the first run drew a 4763×2680 fullscreen
  window, because the exported game's fullscreen default overrode
  `--resolution`. A window given on the command line, or a QA run's, is now
  kept at start-up (decision #35).

## The browser build

Chrome, a visible window with a 1891×1065 canvas, served locally.

- **Scenarios:** every one passes: `greybox`, `saves` over two passes,
  `reduced_motion`, `skip`, `grave` and `menus`.
- **Saves were being lost.** At first the `saves` check failed in 4 of 5 runs,
  though it passed in slice 6. Probing IndexedDB during the run showed why:
  - Godot's shader cache kept writing compiled shaders into `user://` as
    shaders compiled;
  - while it did, a save made during play didn't reach IndexedDB until the game
    quit, and a browser player never quits.

  The web build now turns the shader cache off (decision #38). A save then
  reaches IndexedDB within about 1–2.5 s of further play, and the check passes
  3 of 3. Pass 1 now plays on for 4 s after saving, so the check tests what a
  player does, not a race with the reload. Closing the tab within a second or
  two of a save can still lose it, because the engine has no hook for a page
  that is closing.
- **Frame time, warm pass:**

  | Part | 95th percentile | Worst | Frames over 17.2 ms |
  |---|---|---|---|
  | Opening | 18.1 ms | 150 ms on the first frame, under black | 49 |
  | Gravestone close-up | 16.7 ms | 119 ms | 6 |
  | Nave, walking | 16.7 ms | 142 ms | 8 |
  | Flashback | 16.7 ms | 50 ms | 29 |

  - **The 95th percentile holds 60 fps** everywhere but the opening's
    shader-compiling first second.
  - **The worst frames move between runs.** They were measured under heavy
    load: load averages of 44, 35 and 38 on 10 cores, from Rust builds, other
    Claude sessions and another project's Electron QA run. For example, the
    nave walk's worst frame spent 31 ms in scripts that take under 2 ms
    otherwise. Slice 3's run on a quiet machine had no slow frames in these
    parts, so they get measured again once the machine is quiet.
- **Video memory:** 300 MiB, within the 400 MiB budget per room.
- **Perf report:** it now gives each part's worst frame with its script time
  and render CPU time (`worst_script_ms`, `worst_render_cpu_ms`), so a slow
  frame shows whether the scripts, the drawing or the waiting took the time.

