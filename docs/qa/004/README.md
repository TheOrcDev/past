# QA — plan 004, the point-and-click core

Slice 12's measurements, 2026-10-11. The browser frame times and the
recording of the greybox chain are still to come: the operator needed the Mac,
and both runs open windows.

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
