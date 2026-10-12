# Plan 008 — evidence and production metrics

Fifty new rooms after the grave, and the whole story playable from the
prologue to the epilogue in the desktop build. Measured 2026-10-12.

## Watch

- `fifty-rooms-reel.mp4`: 140 s. Every room in story order, now, then
  dissolving to then where it has a past.
- `game/`: the whole game's checkpoints, shot by the `game` QA scenario in
  the exported macOS app.
- `prologue/`, `ch1/` … `ch4/`: each part's playthrough checkpoints.
- `reveals/`: the four area reveals, close, pulling back and the full
  vista.
- `npc/gravedigger-motions.jpg`: the skinned-painting NPC route
  (decision #49).

## Checks

| Check | Result |
|---|---|
| The whole game in the exported macOS app (`--qa=game`, five playthroughs back to back) | PASS: grave to dawn in 475 s, with lines skipped as they start. 15 memories, 11 facts. |
| Each part's playthrough in GUT (`test_prologue.gd`, `test_ch1.gd` … `test_ch4.gd`) | PASS |
| Each part's tour in the macOS app (`--qa=rooms --part=…`): every room in both eras, and every hotspot answers Look | PASS, all 52 rooms |
| Video memory per room, with Unknown, the NPCs and both eras loaded | 182–224 MiB, against the 400 MiB budget |
| The prologue in Chrome on the web export (`browser-qa.ts prologue`) | PASS |
| The browser demo pack, with chapters 1–4 left out | 143 MB of its 150 MB budget |
| Content lint: every line has an ID, no duplicate ID or cue, every room is whole | PASS |

## Production metrics

| What | Count |
|---|---|
| New rooms | 50, 42 with a then image |
| NPCs | 13 |
| Close-ups | 20 new |
| Area reveals | 4, three rings each |
| Inventory items | 18 new |
| Memories in the journal | 17 new |
| Voiced lines written | 1,069, about 69 minutes of voice (`audio-source/voice/manifest.json`), 39 with voice direction tags at the turning points |
| Image requests | 144 accepted (IMG-0011–0154) |
| Generations | 360 images in 144 calls: 336 by Sol in 132 calls, 24 by the gateway in 12 calls |
| Then-edits aligned on their first round | all of them, p90 1.02–2.35 px (gate 3 px) |
| Gateway spend | $1.14 of the $50 budget, all on the 3:1 reveal rings Sol can't paint |
| Sol spend | $0 in dollars, on the operator's ChatGPT plan |
| Raw images added to Git LFS | about 1 GB (`art-source/raw` is 1.1 GB in all) |
| Elapsed time, plan written to finale pushed (commit timestamps) | about 4.5 hours |

## Notes for what comes next

- **Voice casting:** the manifest lists five NPCs under two names each,
  their role and their returned name: Lamplighter/Mathis, Ferryman/Corin,
  Washerwoman/Maud, Plague Doctor/Isolde, Registrar/Edmund, Dove/Elise. Each
  pair is one voice. Every NPC's base direction is in
  `docs/story/cast.md`.
- **The browser demo** is at 143 MB of 150 MB. Plan 006's voice and music for
  the prologue need room, so the demo's pack should drop any asset the
  prologue doesn't use before they go in.
