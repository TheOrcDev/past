# PAST

![Unknown touches the saint's statue and the ruined nave blooms back into the gold cathedral it was](docs/readme/hero.jpg)

**A point-and-click adventure where memory is color.**

A shadow wakes in a dead, grey city with no memory and no name, so he calls
himself Unknown. The places he passes still remember what they were, and one
flashback at a time they show him who he was.

**[Play it in your browser →](https://past-nu.vercel.app)** (the whole game, desktop Chrome recommended)

---

## The game

| Now | Then |
|---|---|
| ![The market square at night, grey and empty](docs/readme/market-now.jpg) | ![The same market square at sunset, in full color, with petals on the cobbles](docs/readme/market-then.jpg) |

- **Memory is color.** The present is a monochrome gothic ruin of fog, moonlight
  and black silhouettes. Touch a memory anchor and the past blooms out of it in
  warm color, then drains away again. Most rooms are painted twice, as they are
  and as they were.
- **A whole city to walk.** A prologue and four chapters across 52 hand-painted
  rooms (43 of them with a past): the cemetery and the cathedral, the Nameless
  Streets, the Drowned Quarter, the Hall of Records and the Dovecote.
- **People who forgot themselves.** 13 characters to talk to, with dialogue
  trees: a gravedigger, a crier, a plague doctor, a hangman, a puppeteer and
  more.
- **Look closer.** 21 close-ups push the camera into gravestones, ledgers,
  edicts and clockwork, and the clues in them are written on the page.
- **Every arrival is a reveal.** New areas open with the camera pulling back
  over the city, and memories carry what you need to solve the present.
- **Mouse only, LucasArts rules.** Click to act; hold for the verb coin (look,
  use, talk). No deaths, no dead ends and no pixel hunts: hotspots have hover
  labels and can be revealed.
- **A journal** keeps every memory recovered, with a still and a line, and
  plays them again.

| | |
|---|---|
| ![Close-up of the smashed gravestone: "U... Is that me? It's a start."](docs/readme/gravestone.jpg) | ![Unknown and the Plague Doctor in the hospice on stilts: "No. Nobody can. That's rather the point of my job, at the moment."](docs/readme/plague-doctor.jpg) |
| *His own grave, with only a U left on it* | *The Plague Doctor, who forgot why she promised* |
| ![The verb coin open over the clock's escapement: an eye, a hand and a wisp](docs/readme/verb-coin.jpg) | ![Close-up of the edict board: "By order of the High Magistrate: a name is a privilege, not a right"](docs/readme/edict-board.jpg) |
| *Hold the button for the verb coin* | *Close-ups carry the clues* |
| ![Memory at the aqueduct: a sunny day, banners and a ribbon across the arch](docs/readme/memory-aqueduct.jpg) | ![Memory in the tavern: firelight, candles and a full house](docs/readme/memory-tavern.jpg) |
| *The aqueduct's dedication, remembered* | *The tavern on the night everyone forgot a name* |
| ![Unknown walking past the giant clock face, the city beyond it](docs/readme/clock-face.jpg) | ![The heights reveal: the city under the moon and the title THE DOVECOTE](docs/readme/reveal-dovecote.jpg) |
| *Inside the clock tower* | *The Dovecote, the cathedral's heights* |

## Status

The whole story plays from the grave to the dawn epilogue, on desktop and in the
browser. Voice and music are not in yet: lines are subtitled and the game is
silent for now, while the ElevenLabs pipeline is built
([plan 003](plans/003-voice-of-the-world-audio-spike.md)). Progress by plan is
in [`plans/README.md`](plans/README.md), and the milestones are in
[`docs/roadmap.md`](docs/roadmap.md).

## Run it from source

You need [Git LFS](https://git-lfs.com) (every image is in LFS),
[Godot 4.7.2](https://godotengine.org/download/archive/) and
[Bun](https://bun.sh) for the tools.

```sh
git lfs install && git clone https://github.com/TheOrcDev/past.git && cd past
tools/godot.sh            # play
tools/godot.sh -e         # open the editor
tools/test.sh             # import, GUT tests and the content lint
```

`tools/godot.sh` looks for Godot at
`~/Applications/Godot-4.7.2.app`; set `GODOT_BIN` to use another path.

| Command | Does |
|---|---|
| `tools/build/export.sh macos` | Builds `build/macos/Past.app` |
| `tools/build/export.sh web` | Builds the browser version into `build/web` |
| `bun tools/build/serve.ts` | Serves `build/web` at http://localhost:8060 |
| `tools/build/deploy.sh [--prod]` | Uploads `build/web` to Vercel |
| `tools/godot.sh -- --qa=game` | Plays the whole game by itself, grave to dawn, and checks it |

The scripted runs (`--qa=<scenario>`) are listed at the top of
[`src/core/qa.gd`](src/core/qa.gd) and in
[`docs/technical-plan.md`](docs/technical-plan.md) §9.

## How it's made

- **Engine:** Godot 4.7.2 with the Compatibility renderer, so the same game runs
  on desktop and in the browser. GDScript only.
- **Adventure core:** our own (rooms, walking with depth scaling, hotspots, verb
  coin, inventory, close-ups, saves), with
  [Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) 4.1
  for dialogue and [GUT](https://github.com/bitwes/Gut) 9.7 for tests.
- **Art:** painted by GPT-6.1 Sol and GPT Image through
  [`tools/images`](tools/images). Every picture has a request file in
  [`art-source/requests`](art-source/requests), so it can be traced back to its
  prompt, and processing writes to `art-source/work`.
- **Voice, sound and music:** ElevenLabs, through [`tools/audio`](tools/audio)
  ([`docs/audio-pipeline.md`](docs/audio-pipeline.md)).
- **Team:** OrcDev decides the story, the budgets and the look; Claude Code
  writes the code, scenes, tools, art requests and docs.

| Path | What |
|---|---|
| `src/` | The adventure core: `core/`, `systems/` (flashbacks, close-ups, cutscenes, journal), `ui/`, `shaders/` |
| `content/` | Rooms, close-ups, characters, dialogue, cutscenes and the story's playthroughs |
| `addons/` | Dialogue Manager, GUT and our editor tools (`past_tools/`, which scaffold rooms and close-ups) |
| `tools/` | Command-line tools: images, audio, art processing, builds |
| `test/` | GUT tests |
| `docs/` | Design, technical plan, pipelines, decision log and QA evidence |
| `plans/` | Implementation plans, executed in order |

Start with [`docs/game-design.md`](docs/game-design.md),
[`docs/technical-plan.md`](docs/technical-plan.md) and the decision log
[`docs/decisions.md`](docs/decisions.md).
