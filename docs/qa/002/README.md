# Plan 002 — measurements and evidence

Measured 2026-10-10 on the operator's Mac (Apple M4, 32 GB, built-in Liquid
Retina XDR display, AC power). Other apps were running, so the timings carry
some noise.

## Files here

| File | What |
|---|---|
| `first-light-tour.mp4` | The whole slice as a player sees it, recorded in Godot's movie writer at 1080p and 30 fps: the cemetery opening, walking the nave, the statue's flashback, and back (50 s). |
| `cemetery-reveal.jpg` | The opening: close shot, pull-back, title card, then the hand-off to the cathedral. |
| `unknown-in-the-nave.jpg` | Unknown facing front, side and back, walking right and left, and at the far walk line. |
| `unknown-walk-12-vs-15fps.mp4` | Walk cadence comparison; 15 fps was chosen (decision #30). |
| `flashback-sequence.jpg`, `cathedral-now.jpg`, `cathedral-then.jpg` | Slice 3 and 5 captures. |

## Frame time at 1080p

Measured by the `perf` QA scenario (`src/core/qa.gd`), which plays the opening,
walks Unknown round the nave, and plays the flashback.

| Build | Opening | Nave, walking | Flashback | Video memory |
|---|---|---|---|---|
| macOS release, 1920×1080 window | 120 fps (display limit); 4 slow frames, the worst 150 ms on the first frame, under black | 120 fps; worst frame 14.6 ms | 120 fps; no slow frames | 87.6 MiB |
| Chrome 155, visible window, 1891×1065 canvas, warm pass | 60 fps (display limit); 22 slow frames, all in the first 0.5 s, under black | 60 fps; no slow frames | 60 fps; no slow frames | 101.7 MiB |
| Chrome 155, 4276×2407 canvas, warm pass | 60 fps; 23 slow frames at the start | 60 fps; 1 slow frame | 60 fps; 4 slow frames, the worst 41 ms | 139.0 MiB |

- **Render CPU:** the renderer's CPU time per frame is about 2.5 ms at the 95th
  percentile on macOS and about 1 ms in Chrome. The Compatibility renderer
  reports no GPU time.
- **Shader warm-up:** the first measurements had a hitch at the start of the
  flashback: 32 ms on macOS and 141 ms in Chrome, while the past's shaders
  compiled. `Flashback.warm_up` now draws the past once while a room fades in
  from black (`Rooms.while_black`), and the hitch is gone in both builds.
- **Cold browser runs:** the first pass in a fresh Chrome profile still shows
  scattered 120–140 ms frames. Shader compilation and the profile's own startup
  work both play a part, so the warm second pass is the one quoted.
- **Canvas size:** the browser holds 60 fps even at 4276×2407 on this Mac, so
  the canvas is not capped. A render-scale setting belongs with the settings in
  plan 004, for weaker GPUs.
- **How to repeat:**
  - desktop: `build/macos/Past.app/Contents/MacOS/Past --resolution 1920x1080 -- --qa=perf --qa-out=<dir>`;
  - browser: `bun tools/build/serve.ts`, then `bun tools/build/browser-qa.ts perf 1920x1080 2`.

## Downloads

| Build | Size |
|---|---|
| Browser | 52.5 MB: `index.wasm` 39.5 MB and `index.pck` 12.7 MB. Gzipped it is 22.6 MB: the wasm drops to 10.1 MB, while the pack, already compressed images, stays 12.5 MB. |
| macOS | 174 MB app: a 170 MB universal engine binary and a 12.7 MB pack. |

## Banding

The `banding` QA scenario captures both eras with film grain on and off.
- **By eye:** no banding is visible in the fog, even with the contrast pushed
  hard. The painted texture hides the 8-bit steps.
- **Measured:** in the smoothest 5% of the present-day image, 22.6% of pixels
  sit on flat 8-bit plateaus with grain off, against 5.3% with grain on. The
  past is in color and sits at 11.2% and 5.6%.
- **Verdict:** grain covers the risk. Forward+ for desktop is not worth testing
  for banding (`technical-plan.md` §2).

## Cost per asset

The image dollars are gateway-billed, from `art-source/raw/ledger.json`. Hours
are estimates of agent time, because the session log does not time steps
separately.

| Asset | Requests | Rounds | Images | Dollars | Hours |
|---|---|---|---|---|---|
| Cathedral, now (style key) | IMG-0001 and the Sunburst A/B, IMG-0002 | 1 each | 4 | $0.112 ($0.056 without the A/B) | about 1.5 h for both eras: processing, room build and effects |
| Cathedral, then | IMG-0005 | 1 | 2 | $0.079 | (included above) |
| Cemetery rings 0–2 | IMG-0006, -0007, -0008 | 1 each | 6 | $0.101 ($0.034 per ring) | about 0.9 h: requests, ring preparation, reveal scene |
| Unknown model sheet | IMG-0003, IMG-0004 | 2 each | 8 | $0.164 | (included below) |
| Unknown: body, rig and keyframes | — | several contact-sheet rounds | — | $0 | about 1.5 h |
| Unknown: walk, idle, look-around | — | — | — | $0 | rendering takes 4 s; most of the 1.5 h went into the walk |
| Unknown: Godot body, eyes, smoke | — | — | — | $0 | about 0.7 h |

Total image spend for plan 002 is **$0.456 of $50**. Every accepted image took
one round, except Unknown's model sheet, which took two.
