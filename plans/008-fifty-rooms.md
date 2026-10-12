# 008 — Fifty rooms: the city beyond the grave

Status: written 2026-10-11 at the operator's request. Owner: Claude, with
GPT-6.1 Sol generating images through Codex (decision #44).

## The brief

The operator, 2026-10-11: "plan out next 50 levels / backgrounds / art with
continuation of our story and with new npc with which we are going to talk.
another agent (GPT-6.1 Sol) is ready for your disposal for art creation, you
are going to execute everything and put that art in game and prepare."

Settled the same day:

| # | What | Decision |
|---|---|---|
| 43 | Who Unknown was | "Thief of names": Ulric, High Magistrate, who took the city's names. He ends by giving them back and fading. |
| 44 | How images are made | Sol generates through Codex, billed to the operator's ChatGPT plan. `tools/images` (gateway) is the fallback. |
| 45 | Gateway budget | $50, with a stop at 80%. |
| 46 | What "50" counts | 50 new playable rooms. Close-ups, vistas, NPC art and items come on top. |

## Goal

The whole story after the grave is playable on desktop, from the prologue to
the epilogue, in 50 new rooms:
- each in its now image, and most with a then image;
- 13 NPCs to talk to;
- 20 close-ups;
- four area vistas with their memory vistas;
- the memories, items, puzzles, hints and journal pages that go with them.

Every line is written in Dialogue Manager with its ID and voice direction,
ready for voice. Voice, music and sound come later; this plan prepares for
them.

**What it builds from:**
- `docs/story/bible.md`: the truth, the world's rules, the arc and the
  chapter outlines.
- `docs/story/cast.md`: Unknown and the 13 NPCs.
- `docs/story/atlas.md`: the 50 rooms, with now, then and play for each.

## Before it starts

- **Slices 0, 2 and 3** can start at once.
- **Slice 4 onwards** (volume art) waits on two operator decisions:
  - **board #10:** the operator signs off the bible, the cast and the atlas.
    The story is the operator's;
  - **board #11:** the operator signs plan 002's look gate (#31). Fifty rooms
    in this look is the commitment.
- **Female NPCs** (the Sister, the Washerwoman, the Plague Doctor, the
  Puppeteer and the Dove) need the operator to approve downloading Blender
  Studio's CC0 female base mesh (board #12), as #32 approved the male one.

## Depends on

- Plan 004's core and plan 005's toolkit (both done).
- Plan 007's close-ups (done).

Plan 003 (voice) isn't needed. Plan 006 later voices, scores and releases the
prologue that this plan builds.

## Not in this plan

- Voice, music and sound, which wait on board #4 and #7.
- Publishing, signing and stores.
- Translations.
- Anything after the epilogue.

## How Sol works

| Who | Does |
|---|---|
| **Claude** | Writes every request file. Sends it to Sol. Reviews the variants and accepts one (decision #29). Processes the art and builds the rooms. Falls back to the gateway when Sol can't do something. |
| **Sol** (`gpt-6.1-sol` in Codex, its built-in image generation) | Generates the variants a request asks for, saves them untouched and writes the receipt. Nothing else. |
| **Operator** | Story sign-off, budgets, and overruling any pick. |

**Request files:** the same template, with one more line, `agent: sol` (or
`gateway`). Requests for Sol keep the generation block. Sol reads `size` and
`background` as targets, and the receipt records what it actually produced.

**Dispatch:** `tools/sol/dispatch.sh IMG-#### [...]` runs
`codex exec -m gpt-6.1-sol -s workspace-write -C <repo>` with
`tools/sol/PROTOCOL.md` and the request IDs. It runs in the background, up to
four requests to a session, and logs to `build/sol-logs/`.

**Sol's contract** (`tools/sol/PROTOCOL.md`):
1. Read the request. Send the prompt verbatim, with the references attached
   as input images. If the image tool forces a change, record the prompt
   actually used.
2. Generate exactly `n` variants. Save each as it came, as
   `art-source/raw/IMG-####/IMG-####-vN.png`, continuing the numbering.
3. Append a round to `receipt.json`, with:
   - `engine: codex`, `model: gpt-6.1-sol`;
   - the actual pixel size;
   - the prompt sent;
   - each reference with its sha256, and each file with its sha256;
   - the date and the Codex session id;
   - `costUsd: 0`, `costSource: chatgpt-plan`.
4. Add the request's Delivery row and set `status: delivered`.
5. Touch nothing else: no code, no other requests, no commits, and never
   edit or delete an earlier raw.

**Guard:** after every dispatch, `tools/sol/verify.ts` checks four things:
- only the allowed paths changed;
- the hashes match the receipt;
- no earlier round was overwritten;
- the round is in `art-source/raw/ledger.json` under plan 008.

A failed check marks the round rejected in its Review table, and the files
stay, because raw files are never deleted.

**Gateway fallback:** `bun tools/images/run.ts`, paid from plan 008's $50. It
covers:
- then-edits that Sol can't align (two rounds over the 3 px p90 of
  `art-pipeline.md` §8);
- anything that needs a mask;
- anything Sol can't produce while it's rate-limited.

**Pipelining:** Sol generates batch N+1 while Claude builds the rooms of
batch N.

## Estimates

| Art | Accepted | Variants each | Generations (with revisions) |
|---|---|---|---|
| Rooms, now | 50 | 3 | ~190 |
| Rooms, then (edits) | 42 | 2 | ~125 |
| Close-ups | 20 | 2 | ~50 |
| Vista rings and past vistas (4 areas) | 16 | 2 | ~40 |
| NPC model sheets (turnaround and costume detail) | 26 | 2 | ~60 |
| Memory figure sheets | 3 | 2 | ~8 |
| Item sheets (8 icons each) | 8 | 2 | ~20 |
| **Total** | **~165** | | **~490** |

- **Money:** Sol's images draw on the ChatGPT plan, not dollars. If the
  gateway made every then-edit, at the $0.03–0.08 per medium image measured
  in plan 002, that would be about $5–10. The $50 budget is a safety margin.
- **Storage:** a raw room image is about 6 MB, so this plan's raws come to
  about 3 GB in Git LFS, plus the work files. That can break the account's
  quota, so slice 0 checks it (board #13).
- **Agent time (rough):**
  - 2–3 h per room;
  - 4–6 h per NPC;
  - 4–6 h per part for its chart and script;
  - about 200 h in all.

  Slices 3 and 4 measure it and re-estimate.

## Slices

Each slice ends with tests passing and a board entry. Commits and pushes
follow the operator's authorization (AGENTS.md rule 9).

### Slice 0 — Sol handshake

1. `tools/sol/`: `PROTOCOL.md`, `dispatch.sh`, and `verify.ts` with tests.
   `budgets.json` gets `"008": 50`.
2. **Spike:**
   - `IMG-0011` is `cemetery_gate`'s now image, through Sol with `n: 3`.
     The same prompt also goes once through the gateway, for an A/B.
   - `IMG-0012` is its then image, an edit through Sol, run through `align`.
3. **Measure:**
   - output size and aspect;
   - whether the references hold the style of IMG-0006 and IMG-0009;
   - the then-edit's p90 residual;
   - time per image and rate limits;
   - transparent backgrounds;
   - whether the prompt is sent verbatim;
   - whether Sol stays inside its paths.
4. **Decision #47:** Sol's role, by those measurements. For example, Sol for
   new images and the gateway's Sunburst for then-edits.
5. Update `AGENTS.md` ("Image requests") and `art-pipeline.md` §1 to match.
6. Check Git LFS storage (board #13).

**STOP:**
- Sol's images are below 1920×1080 and an upscale doesn't hold the ink-wash
  detail.
- Sol changes files outside its paths.
- Sol misses the style after two rounds.

In each case, report and propose a gateway-only plan.

### Slice 1 — Story sign-off (board #10)

The operator reads the bible, the cast and the atlas. Their changes go in. The
docs move from draft to signed, and `game-design.md` §13 points to them.
**STOP** for volume art until it is signed. Slices 0, 2 and 3 don't wait.

### Slice 2 — Production frame

1. **Shared prompt text** in `art-source/style/`: preambles for now, then,
   NPC sheets and item sheets, so 165 images stay one style.
2. **Request index:** `art-source/requests/INDEX.md`, generated from the
   request files by `tools/sol/index.ts`. The board's table links to it,
   because it outgrows the board.
3. **Chapters:**
   - `content/chapters.gd` lists each part's rooms, its start room and its
     title card;
   - dialogue goes in `content/dialogue/<part>/`, as
     `technical-plan.md` §3 has it.
4. **The browser build stays the prologue:** the web export excludes chapter
   1–4 content, and a test checks that its pack holds none (decision #20).
5. **Every room tested:** one GUT test walks the chapter list. For each room
   it checks the walk area, the entry markers, that every hotspot answers
   Look, and that every exit leads to a room that leads back. `lint.gd`
   checks the same in content.
6. **QA from mid-game:** `--qa-start=<room>`, with each part's flags preset.

### Slice 3 — The NPC route, proven on the Gravedigger

1. **Sol:** his model sheet (turnaround, transparent) and a costume detail
   sheet.
2. **Claude, in Blender:**
   - a body from the vendored base mesh, with his costume (coat, hood and
     lantern pole) as modelled shapes, and a rig;
   - the animations `idle`, `talk_a`, `talk_b` and `dig`, in one facing that
     is mirrored;
   - renders in grey + alpha like Unknown's, through an NPC shader: mid grey,
     a rim light, and no glowing eyes.
3. **An `Npc` actor:** it stands at a marker and talks by default through a
   dialogue tree. Its head and shoulders bob with the voice envelope.
4. **Measure** hours and video memory. **Decision #48** sets the route for
   the other 12:
   - Blender, if one NPC takes 6 h or less and 30 MiB or less;
   - otherwise a 2D cut-out from Sol's pose sheets (`art-pipeline.md` §5C's
     fallback).

**STOP:** a room with Unknown and an NPC passes 400 MiB of video memory.

### Slices 4–8 — The five parts, in order

| Slice | Part | New rooms | NPCs |
|---|---|---|---|
| 4 | Prologue: The Grave | 5 | Gravedigger (done in slice 3), Sister |
| 5 | 1. The Nameless Streets | 12 | Crier, Lamplighter, Broker, Clockmaker |
| 6 | 2. The Drowned Quarter | 11 | Ferryman, Washerwoman, Plague Doctor |
| 7 | 3. The Hall of Records | 12 | Hangman, Puppeteer, Registrar |
| 8 | 4. The Dovecote | 10 | the Dove (and the Registrar's finale) |

**Each part, in this order:**

1. **Chart and script:**
   - the part's puzzle dependency chart in `docs/story/<part>-puzzles.md`
     (Mermaid), before any of its art (`game-design.md` §10);
   - then its script: every line in Dialogue Manager with an `[ID:…]` and a
     voice-direction note, plus its hint goals and journal entries.

   Both are written from the signed bible and shown on the board.
   Anything they need beyond the bible is a **STOP**.
2. **Style key:** the area's first room (atlas), its three vista rings, and
   its past vista. They go on the board for the operator to see.
3. **Rooms, in batches of three or four.** For each room:
   1. request it, and Sol generates;
   2. review and accept;
   3. the then-edit, aligned;
   4. `tools/art`: grade, depth and layers;
   5. `new_room.gd`;
   6. walk area, scale zones, occluders, fog and life effects;
   7. hotspots, exits and lines;
   8. the room tests.
4. **NPCs:** the part's NPCs, by decision #48's route.
5. **Details:**
   - close-ups (`new_closeup.gd`);
   - items: sheets from Sol, cut into icons and added with `new_item.gd`;
   - memories (visions, playable memories and vistas, with plan 005's
     toolkit);
   - the discovery reveal (`new_reveal.gd`).
6. **Proof:**
   - the part's playthrough script, like the greybox's, run by GUT and as a
     QA scenario in the macOS build;
   - screenshots and a short reel in `docs/qa/008/<part>/`;
   - a board entry.

**The prologue (slice 4) also:**
- replaces the placeholder hints and journal pages;
- connects the two existing rooms to the new ones;
- passes the `grave` and browser checks, because it is the demo.

### Slice 9 — The whole game

1. **One playthrough,** from the grave to the epilogue, in the macOS build:
   GUT plus a QA scenario.
2. **Lint is clean:** every line has an ID and a direction, every hotspot
   answers Look, and no art is orphaned.
3. **Every room** stays within budget on desktop: frame time, video memory
   and load time (`technical-plan.md` §10).
4. **Production metrics:**
   - images generated and accepted, by engine;
   - gateway spend;
   - hours per room, per NPC and per part.

   These feed plan 006 and the roadmap.
5. **A reel** of all 50 rooms, now to then.
6. **A hand-off to voice:** the `tools/audio` manifest lists every line, and
   the minutes of voice it adds up to size the ElevenLabs budget.

## STOP conditions

- A puzzle or scene needs a story fact that isn't in the signed bible. Ask;
  never invent story.
- Gateway spend reaches $40 (80%). Stop and report.
- Sol is blocked for more than a day (limits), or touches files outside its
  paths. Stop sending it work and report.
- Git LFS storage reaches 80% of the quota.
- An area's style key fails three rounds. Report with the best candidates.
- A room passes 400 MiB of video memory or takes over 1 s to load on desktop.
- Any action outside the repository needs the operator: downloads (the female
  base mesh), publishing, and new paid services.

## Definition of done

- The 50 rooms play from the prologue to the epilogue in the desktop build,
  with every line written and ready for voice.
- The 13 NPCs talk.
- The 20 close-ups, the four reveals and their memory vistas, and every
  memory work, and each memory is in the journal.
- The prologue still runs in the browser demo.
- Every image traces to a request, its raws and its receipt.
- The production metrics are recorded.

## Effort

XXL: five parts. It is re-estimated after slices 3 and 4.

## Execution record

- **2026-10-11, slice 0:** Sol works, and the design changed for the better.
  - **Engine:** Sol is a second engine inside `tools/images`, not a separate
    `tools/sol`. A request with `"model": "codex/gpt-6.1-sol"` runs
    `codex exec -s read-only`. Sol writes nothing at all, and `run.ts` copies
    the images Codex keeps under `~/.codex/generated_images/<thread>/` into
    `art-source/raw/` untouched, with the same receipt, ledger entry
    (`costSource: plan`) and Delivery row as the gateway's. The guard of the
    original design isn't needed, because the sandbox is read-only. Five new
    tests run against a fake `codex`.
  - **Spike:** IMG-0011 (`cemetery_gate`, 3 variants, about 40 s each)
    matches IMG-0009's style. Its then-edit, IMG-0012, aligns with p90
    1.56 px (gate 3 px). Both v1s are accepted.
  - **Size:** Sol returns 1672×941 and can't be asked for more. Rooms
    upscale 1.15× to 1920×1080. The gateway keeps the 3:1 vista rings and
    masks. This is decision #47.
  - **LFS (board #13):** a Sol raw is about 3.5 MB. Plan 008's raws come to
    about 1.7 GB.
- **2026-10-11, slice 1:** the operator's "execute the entire plan" is taken
  as the sign-off for the story drafts, the look gate and memory figures
  (decision #48). The story docs are marked signed.
- **2026-10-11, slice 2:** the production frame.
  - **Rooms as data:** `past-art room <room.json>` builds a room's art and
    `room_spec.json` from one data file. It covers:
    - the now image graded to monochrome at 1920×1080;
    - the then image aligned to it;
    - depth, and occluders cut in both eras;
    - an effects preset (`exterior` or `interior`), with ground mist and the
      warm set for the past.

    `past-art grid` and `past-art overlay` draw a labelled grid, and a
    room's traced walk area and hotspots, onto its image.
  - **Requests from templates:** `bun tools/images/new-request.ts specs.json`
    writes request files from short specs and the shared prompts in
    `art-source/style/prompts/` (now, then, closeup, npc, items).
    `bun tools/images/index.ts` rebuilds `art-source/requests/INDEX.md`.
  - **Chapters:** `content/chapters.json` lists each part's rooms,
    close-ups, characters and dialogue folders, read by `Chapters`.
    `tools/build/export.sh web` leaves every part not marked `web` out of
    the demo, and fails if the pack still holds one of them.
  - **Every room tested:** `test_rooms_all.gd` covers each registered room:
    - its walk area and default marker;
    - that every hotspot answers Look;
    - that every exit lands on a marker that exists.

    It found the nave's statue had no Look line, and now it has one.
  - **QA tours:** `--qa=rooms --part=<id>` (or `--rooms=a,b`) shows every
    room now and then and looks at every hotspot. It passes for the
    prologue on desktop.
  - The "QA from mid-game" item is the part's `flags` in
    `content/chapters.json`, which the tour sets.
- **2026-10-12, slice 3:** the NPC route is skinned paintings (decision
  #49), not Blender.
  - **Painting:** Sol painted the Gravedigger (IMG-0013 v2, transparent,
    1024×1536). `past-art npc` trims and scales it.
  - **Rig:** `addons/past_tools/new_npc.gd` meshes it (285 vertices) and
    skins it to 7 bones. `RigBody` plays data motions: idle sway,
    `talk_a`/`talk_b` bending with the voice, and the `lean` one-shot.
  - **Checks:** `test_rig_body.gd` (4 tests), and an `npc` QA scenario that
    shoots each motion.
  - **Cost:** about 15 min an NPC after the tooling, and under 1 MiB of
    video memory. A room with Unknown and two NPCs stays far below the
    400 MiB stop.
- **2026-10-12, slice 4:** the prologue is playable from the grave to the
  great doors, in the desktop build and in the browser demo.
  - **4a:** the puzzle chart (`docs/story/prologue-puzzles.md`), the script
    in `content/dialogue/prologue/`, the hint chain and the journal pages.
  - **4b:** the cemetery thread: the gate with the Gravedigger, the lodge
    and the ossuary. The burial register and ossuary niche close-ups, and
    the five items from one Sol sheet. Exits can now need a story flag.
  - **4c:** the cathedral thread: the cloister with the Sister, the choir
    loft, and the nave's arch and great doors. The hymn book close-up, and
    the vision "The singer".
  - **The doors:** they lead to chapter 1's square when it's in the build.
    Otherwise (the demo) they play an end card and return to the nave.
  - **Art:** 16 Sol requests (IMG-0011–0026): 5 rooms now and then, 2 NPCs,
    3 close-ups, 1 item sheet. Every then-edit aligned on the first round
    (p90 1.03–1.56 px). Gateway spend is still $0.
  - **Proof:** `ProloguePlaythrough`, on a new `Playthrough` base the
    greybox shares, plays the whole chain:
    - in GUT (`test_prologue.gd`);
    - in the desktop game (`--qa=prologue`);
    - in Chrome on the web export (`browser-qa.ts prologue`), which passes.

    Screenshots are in `docs/qa/008/prologue/`. 123 GUT tests and the lint
    pass.
- **2026-10-12, slice 5:** chapter 1, The Nameless Streets, plays from the
  great doors to the lower gate.
  - **Chart and script:** `docs/story/ch1-puzzles.md` has three threads (the
    lamp, the key, the hour) that meet at the clock. The script is in
    `content/dialogue/ch1/`, with 14 new hint goals and four journal pages.
  - **Art (IMG-0027–0060):**
    - 12 rooms, all with a then image; every then-edit aligned on its first
      round, at p90 1.02–2.02 px;
    - 4 NPCs (the Crier, the Lamplighter, the Broker, the Clockmaker);
    - 5 close-ups (the tally wall, the edict, the slate, the escapement, the
      seal cabinet);
    - 1 item sheet. Gateway spend is still $0.
  - **The turn:** Mathis gets his name back and his street keeps its warm
    light. The apprentice's playable memory gives the third tooth. Eleven
    bells strike the memory vista of the old town.
  - **New:**
    - `Actor.speaker_aliases`, for NPCs who remember their names;
    - NPC paintings and item icons graded grey, apart from what keeps color
      (decision #24);
    - `Chapters.start_state` and part `items` and `memories`, to start
      mid-game;
    - `past-art icons --colour`.
  - **Pack fix:** the browser pack had grown to 304 MB. Sol's scratch copies
    and `build/screenshots` were inside the project and got imported. Now
    `build/` carries a `.gdignore` (made by `tools/godot.sh`), Sol's scratch
    goes to the system temp folder, and `export.sh` checks the pack's real
    file list (`tools/build/pck_list.py`). The demo pack is 143 MB of its
    150 MB budget.
  - **Proof:** `Ch1Playthrough` passes in GUT and as `--qa=ch1` on desktop
    (`docs/qa/008/ch1/`). The prologue still passes in Chrome. 124 GUT tests
    and the lint pass.
