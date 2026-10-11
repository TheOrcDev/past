# QA — plan 005, the cinematic toolkit

Slice 7's measurements, 2026-10-11.

## Files

| File | What it shows |
|---|---|
| `toolkit-reel.mp4` | Every kind of scene, 104 s at 1080p from the `toolkit_reel` QA scenario. It runs: the opening, skipped partway with the Skip button; the cathedral statue's vision; the greybox chapel's playable memory, where Unknown walks the past and reads the carving; the courtyard's discovery reveal, skipped halfway, then its memory vista; and the journal's pages. |

## One of each, in both builds

The exported macOS app and the browser build (Chrome, served locally) pass
the same scripted scenarios:

| Kind | Scenario |
|---|---|
| Cutscene (the opening) and skipping | `cemetery_reveal`, `skip` |
| Vision | `screenshots` (macOS), the journal run |
| Playable memory | `greybox` |
| Discovery reveal and memory vista | `vista` |
| Journal, with a captured still | `journal` |
| Reduce camera motion | `reduced_motion` |

## Budgets

- **Video memory:** the greybox courtyard with the vista loaded (two
  3072×1072 rings) uses 222 MiB on macOS and 318 MiB in Chrome, within the
  400 MiB budget per room. The perf run's rooms use 235 MiB on macOS.
- **Frame time:** measured while the machine was overloaded, with load
  averages of 69, 64 and 45 on 10 cores from other work.
  - The macOS app held about 55 fps at 1080p (95th percentile 19–23 ms).
    Earlier the same day, on a quieter machine, the same paths held 120 fps
    (`docs/qa/004/README.md`).
  - The extra time sits in script time inflated by CPU contention: 27–35 ms
    on the worst frames, against under 5 ms of render CPU.
  - Both builds get measured again on a quiet machine.

## Found by the reel

- **The bug:** Unknown took clicks meant for what he stood in front of. In the
  chapel he enters in front of the altar, so a press on the altar asked him
  for a hint and the memory never began.
- **The fix:** a hotspot behind him now wins. He answers a hint only where
  nothing usable is behind him, such as his legs over the floor. Hovering
  follows the same rule. Decision #39.
