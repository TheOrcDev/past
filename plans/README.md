# Implementation plans

Execute the plans in the order below unless the dependencies say otherwise. Read
a plan fully before starting, honor its STOP conditions, and update its row here
when it is done. Milestones are described in `../docs/roadmap.md`.

Status values: TODO | IN PROGRESS | DONE | BLOCKED (one-line reason) |
REJECTED (one-line rationale).

| Plan | Title | Milestone | Effort | Depends on | Status |
|---|---|---|---|---|---|
| [001](001-foundations.md) | Foundations: repo, pinned engine, adventure-core skeleton, desktop and browser builds, tests | M0 | M–L | — | DONE: 19 GUT tests pass, lint passes, macOS QA passes, browser check passes |
| [002](002-first-light-look-spike.md) | First light: prove the look of *Past* | M1 | L | 001; `AI_GATEWAY_API_KEY` in `.env`; $50 image budget (#26) | GATE: slices 1–7 done, 41 GUT tests pass, measurements in `docs/qa/002/`; waiting for the operator's look-gate sign-off |
| [003](003-voice-of-the-world-audio-spike.md) | Voice of the world: ElevenLabs pipeline spike | M2 | M | 001; ElevenLabs key and credit ceiling (board #4) | IN PROGRESS: slices 1 (`tools/audio` skeleton) and 5 (runtime, checked with a stand-in tone) and slice 4's `post` done 2026-10-11; slice 2 waits on board #4 and #7 |
| [004](004-point-and-click-core.md) | Point-and-click core: verb coin, inventory, dialogue UI, saves, settings | M3 | L | 002 | DONE 2026-10-11: 96 GUT tests pass; both builds finish the greybox chain; measurements in `docs/qa/004/` |
| [005](005-cinematic-toolkit.md) | Cinematic toolkit: flashbacks, reveals, cutscene runner, journal | M4 | L | 002, 004 | DONE 2026-10-11: 109 GUT tests pass; one of each kind runs in both builds; reel in `docs/qa/005/` |
| [006](006-prologue-vertical-slice.md) | Prologue vertical slice | M5 | XL | 003, 005, story track | TODO: written 2026-10-11; waits on plan 003 (board #4, #7), the story track, the look gate (#31) and budgets |
| [007](007-the-grave.md) | The grave: start at Unknown's grave, close-up views | M5 (early) | M | 002, 004 | DONE 2026-10-10 (operator request) |
| [008](008-fifty-rooms.md) | Fifty rooms: the story after the grave, 13 NPCs, art by GPT-6.1 Sol | Story track + M7 (early) | XXL | 004, 005, 007; story sign-off (board #10) and look gate (#11) before volume art | IN PROGRESS: slices 0–1 done (Sol engine, decision #47; story signed, #48) |

## Dependency notes

- Stack: Godot 4.7.2 with our own adventure core and Dialogue Manager 4.
  Popochiu was evaluated and dropped (`docs/decisions.md` #19). The full game
  ships on desktop and the prologue is the browser demo (#20).
- 002 and 003 are independent after 001 and can run in parallel. 003's results
  are wired into 002's cathedral when both are done.
- The story track has no plan file. It runs as interview sessions with the
  operator and starts when 002's look gate passes. Its outputs (story bible,
  chapter outline, prologue script and puzzle chart) go in `docs/story/`.
- Plans 004–006 are written one milestone ahead, because they depend on what 002
  and 003 measure.
- Plan 008 (operator request, 2026-10-11) holds the story track's drafts in
  `docs/story/` and builds the 50 rooms after the grave without voice. Plan 006
  then voices, scores and releases the prologue that 008 builds.
