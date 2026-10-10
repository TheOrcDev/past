# QA — plan 007, the grave

Evidence for the new start at Unknown's grave and the close-up views,
2026-10-10.

## Files

| File | What it shows |
|---|---|
| `grave-start.jpg` | The `grave` QA scenario: the arrival line, the push-in, the stone with its U and its inscription, Unknown's lines over it, the pull back out, and the return from the cathedral. |
| `push-in.jpg` | The push-in, one frame every 1/6 s, from the movie writer: the camera closes on the stone, the close-up fades in over it with soft edges, then fills the screen. |
| `grave-start.mp4` | The start, 42 s at 1080p from the `grave_clip` scenario: the opening reveal, Unknown's arrival at the grave, the push-in on the stone, his lines on the U and the inscription, and the pull back out. Text timing only; voice comes with plan 003. |

## Checks

- **GUT:** 72 tests pass, 5 of them new in `test/integration/test_grave.gd`.
  They cover the arrival line playing once, the gravestone opening its close-up
  after Unknown walks there, the stone's three details, each detail picked at
  its centre, and the exits both ways. Content lint passes.
- **`grave` scenario:** passes in the editor, the exported macOS app and the
  browser build.

## Frame time at 1080p

Measured by the `perf` QA scenario. It plays the opening, walks Unknown to the
gravestone and opens and closes its close-up, takes the exit to the cathedral,
walks the nave, and plays the flashback.

| Build | Opening | Gravestone close-up | Nave, walking | Flashback | Video memory |
|---|---|---|---|---|---|
| macOS editor run, 1600×900 window, second run | 120 fps; 8 slow frames, the worst 148 ms on the first frame, under black | 2 slow frames, the worst 23 ms | no slow frames | no slow frames | — |
| Chrome, visible window, 1891×1065 canvas, warm pass | 60 fps; 8 slow frames at the start, under black | 60 fps; no slow frames | 60 fps; no slow frames | 60 fps; no slow frames | 246.2 MiB |

- **Preloading the close-up:** the close-up's background is a lossless
  1920×1080 image. Loading it when the stone was clicked cost a 41 ms frame in
  Chrome. The grave room now preloads the close-up, so the image loads under the
  room's fade.
- **Video memory:** 246 MiB in Chrome, within the 400 MiB budget per room. It
  was 102 MiB in plan 002; Unknown's new sheets (decision #32) account for most
  of the rise.
- **Covered windows:** a covered Chrome window on macOS counts as hidden, and
  its game stops. That made the second browser pass hang. `browser-qa.ts` now
  starts Chrome with backgrounding switched off.
- **How to repeat:**
  - desktop: `tools/godot.sh -- --qa=perf --qa-out=<dir> --force-draw`;
  - browser: `bun tools/build/serve.ts`, then `bun tools/build/browser-qa.ts perf 1920x1080 2`.
