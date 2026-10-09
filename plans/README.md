# Implementation plans

Execute the plans in the order below unless the dependencies say otherwise. Read
a plan fully before starting, honor its STOP conditions, and update its row here
when it is done. Milestones are described in `../docs/roadmap.md`.

Status values: TODO | IN PROGRESS | DONE | BLOCKED (one-line reason) |
REJECTED (one-line rationale).

| Plan | Title | Milestone | Effort | Depends on | Status |
|---|---|---|---|---|---|
| [001](001-foundations.md) | Foundations: repo, pinned engine, adventure-core skeleton, desktop and browser builds, tests | M0 | M–L | — | TODO |
| [002](002-first-light-look-spike.md) | First light: prove the look of *Past* | M1 | L | 001; GPT agent connected | TODO |
| [003](003-voice-of-the-world-audio-spike.md) | Voice of the world: ElevenLabs pipeline spike | M2 | M | 001; ElevenLabs key and credit ceiling (board #4) | TODO |
| 004 | Point-and-click core: verb coin, inventory, dialogue UI, saves, settings | M3 | L | 002 look gate | Not written. Written when 002 closes. |
| 005 | Cinematic toolkit: flashbacks, reveals, cutscene runner, journal | M4 | L | 002, 004 | Not written |
| 006 | Prologue vertical slice | M5 | XL | 003, 005, story track | Not written |

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
