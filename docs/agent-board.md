# Agent board

This is the shared channel between Claude Code and the operator. The rules are
in `../AGENTS.md`. The request files in `art-source/requests/` are the source of
truth; the table below is an index that Claude keeps current. Since decision
#25, Claude generates the images itself, so the GPT image agent in older entries
is gone.

## Open image requests

From plan 008 on, the full list is `../art-source/requests/INDEX.md`, rebuilt by
`bun tools/images/index.ts`. The table below covers plan 002.

| ID | Title | Status | Operator approval | Plan |
|---|---|---|---|---|
| IMG-0001 | Cathedral nave, now (A/B: Flare) | **accepted: v1** (style key) | approved | 002 |
| IMG-0002 | Cathedral nave, now (A/B: Sunburst) | rejected (A/B reference) | — | 002 |
| IMG-0003 | Unknown turnaround, with tendrils | **accepted: v3** | approved | 002 |
| IMG-0004 | Unknown turnaround, without tendrils | **accepted: v4** | approved | 002 |
| IMG-0005 | Cathedral nave, then | **accepted: v1** | approved | 002 |
| IMG-0006 | Cemetery vista, ring 0 (outer) | **accepted: v1** | approved | 002 |
| IMG-0007 | Cemetery vista, ring 1 (2× detail) | **accepted: v1** | — | 002 |
| IMG-0008 | Cemetery vista, ring 2 (4× detail) | **accepted: v2** | — | 002 |

## Open operator decisions

| # | Question | Raised | Needed by |
|---|---|---|---|
| 4 | ElevenLabs plan tier and credit ceiling for the audio spike. The operator is getting a 12-month plan and will post the details. It must be a paid tier (Starter or above), because Free is non-commercial and requires attribution. | 2026-10-09 | Plan 003 |
| 6 | An Apple Developer account for macOS signing and notarization: yes or no? | 2026-10-09 | First public desktop build |
| 7 | Do you publish as an individual or as a company? This sets the ElevenLabs tier needed for music (`audio-pipeline.md` §2). | 2026-10-09 | Plan 003 |

## Log

Append-only. Newest at the bottom. UTC.

- 2026-10-09T21:36Z **Claude → @Operator @GPT:** The planning pass is done. The
  design, pipeline and technical docs are in `docs/`, and the executable plans
  are in `plans/`. Image requests start with plan 002. @GPT: the protocol is in
  `AGENTS.md` and the request template is `art-source/requests/_TEMPLATE.md`.
  Please add a line here when you are connected.
- 2026-10-09T22:00Z **Claude → @Operator:** Two stack decisions are recorded
  after the research:
  - Godot 4.7.2 with our own adventure core and Dialogue Manager 4. Popochiu is
    dropped (`decisions.md` #19).
  - The full game ships on desktop, and the prologue is the browser demo (#20).

  The technical plan, plan 001 and the roadmap are updated to match.
- 2026-10-09T22:05Z **Claude → @Operator:** Answers recorded and decisions #1–#3
  closed:
  - the repository is `github.com/TheOrcDev/past` (`decisions.md` #22);
  - Claude keyframes Unknown's motion (#23);
  - memory is color is confirmed (#24).

  ElevenLabs (#4) is waiting for the operator's plan details.
- 2026-10-09T22:40Z **Claude → @Operator @GPT:** Plan 001 is DONE.
  - **Running:** Godot 4.7.2, Dialogue Manager 4.1.0 and GUT 9.7.1 are pinned.
    The adventure-core walking skeleton runs in the sandbox room as a macOS app
    and in the browser.
  - **Checks:** tests, lint and the macOS QA run pass. Evidence is in
    `docs/qa/001/`.
  - **To try it:** `tools/build/export.sh macos`, then open
    `build/macos/Past.app`.
  - **Next:**
    - plan 002 needs the GPT image agent to be connected;
    - plan 003 needs the ElevenLabs plan and key (#4).
- 2026-10-09T22:55Z **Claude → @Operator:** Image generation moved in-house
  (`decisions.md` #25 and #26).
  - Claude runs GPT Image 2.5 through the Vercel AI Gateway with `tools/images`,
    under a $50 budget for plan 002.
  - The GPT image agent is dropped. The request, receipt and approval flow
    stays.
  - **Waiting on:** #8, copying the gateway key into `.env`.
- 2026-10-10T08:14Z **Claude → @Operator:** The first image batch is done:
  `IMG-0001` to `IMG-0004`, 8 images for $0.19 of the $50 budget.
  - **Credentials:** the gateway runs on the Videorc project's Vercel OIDC token
    (`decisions.md` #27). Its key is marked Sensitive and pulls empty.
  - **A/B result:** Flare for new images, Sunburst for edits (#28, proposed).
  - **Review sheets:** `art-source/work/review/`.
  - **Waiting on (#9):** the cathedral style key (v1 recommended) and Unknown's
    model sheet (a leaner revise is suggested).
- 2026-10-10T09:03Z **Claude → @Operator:** Approvals recorded:
  - IMG-0005 v1 (then);
  - Unknown model sheet: IMG-0003 v3 and IMG-0004 v4;
  - IMG-0006 v1 (ring 0).

  The operator delegated art approvals to Claude's recommendations
  (`decisions.md` #29), so plan 002 continues without approval stops.
- 2026-10-10T10:00Z **Claude → @Operator:** Plan 002 slice 4 is done: Unknown
  is rendered from a keyframed Blender silhouette.
  - **In the game:** a black silhouette with a rim light, glowing eyes that
    blink, and verlet smoke tendrils that stream behind him. It replaces the
    placeholder in every room.
  - **Decision #30:** one-byte mask frames take 21.4 MiB of video memory
    (budget 128 MiB). The walk is 15 fps with steps locked to the frames.
  - **For review:** `docs/qa/002/unknown-walk-12-vs-15fps.mp4`. Say if you
    prefer 12 fps; it is a one-command repack.
- 2026-10-10T10:30Z **Claude → @Operator:** Plan 002 slice 6 is done. The game
  now opens on the cemetery reveal: close on Unknown on the path, a pull-back to
  the whole vista with the title, then the cathedral. A click skips it. Frames
  are in `docs/qa/002/cemetery-reveal.jpg`. Next is slice 7: measure, record,
  then the look gate.
- 2026-10-10T10:45Z **Claude → @Operator:** Plan 002 slice 7 is done, and the
  look gate is yours to sign (`decisions.md` #31).
  - **Watch:** `docs/qa/002/first-light-tour.mp4`, 50 s of the whole slice.
  - **Numbers:** `docs/qa/002/README.md`.
    - Chrome holds 60 fps at 1080p, and still does at a 4K-size canvas.
    - macOS holds 120 fps.
    - Video memory is 87.6–101.7 MiB.
    - The browser download is 22.6 MB gzipped.
    - Image spend is $0.456 of $50.
  - **Recommendation:** pass. Unknown's Blender-silhouette route works, and the
    cut-out fallback is not needed.
  - **After sign-off:** plan 004 (verb coin, inventory, dialogue UI, saves,
    settings) and the story interviews.
- 2026-10-10T11:00Z **Claude → @Operator:** Loose end from plan 002: Unknown's
  eyes now flare as a flashback opens and again as it closes
  (`UnknownBody.flare`, called by `Flashback`).
- 2026-10-10T11:15Z **Claude → @Operator:** Unknown's renders now carry
  per-frame events. The walk fires `step` on each heel strike, ready for
  footstep sounds in plan 003 and grab moments in the coming pickups.
- 2026-10-10T11:25Z **Claude → @Operator:** Unknown can hold an item at a hand
  anchor (`SpriteBody.hold` / `release`), ready for pickups and plan 004's
  inventory.
- 2026-10-10T11:45Z **Claude → @Operator:** Unknown talks with his hands: two
  gesture loops, `talk_a` (right hand) and `talk_b` (both hands), alternate line
  by line while he speaks standing still. One-shot animations can now be
  interrupted by a walk.
- 2026-10-10T12:00Z **Claude → @Operator:** Unknown fidgets when left alone. He
  shifts his weight and looks down, studies his own hand, or looks around, every
  9–18 s of idling, but never during a cutscene or a line (`IdleFidgets`).
- 2026-10-10T12:15Z **Claude → @Operator:** Unknown can pick things up:
  `pickup_low` (a crouch to the floor) and `pickup_high` (an overhead reach onto
  his toes), each with a `grab` event at the moment his hand closes.
- 2026-10-10T19:30Z **Claude → @Operator:** Unknown is rebuilt after your
  feedback, aiming at IMG-0003 v1 (`decisions.md` #32).
  - **Body:** a CC0 realistic base mesh, with a powerful build and a smooth
    skull.
  - **Frames:** lit renders (near-black skin, cold rim light, glowing eyes),
    kept as grey + alpha and GPU-compressed. They measure 127.4 MiB in game.
  - **Smoke:** translucent wisps.
  - **Compare:** `build/screenshots/new-look/00_concept_old_new.jpg`.
  - **New animations:** `use` and `give` arrive with this render.
- 2026-10-10T20:00Z **Claude → @Operator:** Plan 004 (the point-and-click core) is
  written and started under your "continue all slices" instruction. Slice 1,
  the inventory core, is done: `ItemDef`, an `Inventory` autoload (add,
  remove, hold, drop, combine), with the carried items kept in `GameState`.
- 2026-10-10T20:40Z **Claude → @Operator:** Unknown look polish.
  - **Skin:** hands and feet lose their sheen, so toes no longer glint.
  - **Wisps:** from the front they now spread out behind both shoulders, as in
    the concept.
  - **Flare:** a new one-shot (a sharp breath, the head lifting, arms tensing)
    plays as a flashback opens, with the eye flare.
  - **Memory:** 36 animation sets hold 99.2 MiB of texture data (Godot's
    monitor reads 132.4 MiB for the same load).
- 2026-10-10T20:45Z **Claude → @Operator:** Plan 004 slice 2 is done: the
  inventory overlay. A right-click opens a band of smoke holding his items; pick
  one onto the cursor, combine two, examine one, or use it on a hotspot.
- 2026-10-10T21:10Z **Claude → @Operator:** Plan 004 slice 3 is done: the verb
  coin. Hold the mouse on a hotspot and a ring of smoke opens with Look, Use
  and Talk; release over one to act. The hold time is 0.3 s, a recommended
  default you can change.
- 2026-10-10T22:10Z **Claude → @Operator:** Plan 004 slice 4 is done.
  - **Exits:** a click walks there and leaves; a double-click leaves at once.
  - **Cursors:** a walk dot, a hotspot ring and exit arrows.
  - **Bug fixed:** exits used to leave input locked after changing rooms.
  - **Your video:** `build/videos/church-flashback.mp4`, the cathedral memory
    with its lines, 27 s at 1080p.
- 2026-10-10T22:30Z **Claude → @Operator:** Plan 004 slice 5 is done:
  dialogue choices. Responses appear as lines on a band of smoke, Unknown
  speaks the one you click, and used questions disappear.
- 2026-10-10T21:00Z **Claude → @Operator:** Your grave opening has started as
  plan 007.
  - **Images:** IMG-0009 v1 (the grave room) and IMG-0010 v1 (the tombstone
    close-up). The close-up keeps only the "U" of the name, with "I KNOW YOU
    ARE HAPPY NOW." and "YOUR DOVE" below it. $0.11 from plan 002's image
    budget.
  - **Next:** the close-up system, the grave room, and the new start.
  - **Token:** the gateway OIDC token was refreshed and is valid until
    2026-10-11T08:20Z.
- 2026-10-10T21:20Z **Claude → @Operator:** Plan 007 slice 2 is done: close-up
  views. A hotspot opens one by pushing in until it fills the screen. Its
  details answer clicks, and a right-click, Esc or ‹ backs out.
- 2026-10-10T21:35Z **Claude → @Operator:** Plan 007 slice 3 is done: the game
  now starts at Unknown's grave.
  - **The start:** the opening hands off to the grave. Unknown says "Cold.
    Quiet. And for some reason, this spot feels like mine."
  - **The stone:** clicking it pushes in until the close-up fills the screen.
    Only the U survives; below it reads "I KNOW YOU ARE HAPPY NOW." and "YOUR
    DOVE". The U, the inscription and the dove each get a line from Unknown.
  - **The push-in:** reworked so the close-up stays on the stone as the camera
    closes in, with soft edges. It no longer looks like a picture laid over
    the room.
  - **The way on:** an exit east leads to the cathedral, and a breach on the
    cathedral's left leads back.
  - **Checks:** desktop, the macOS app and the browser all pass. Chrome holds
    60 fps through the close-up.
- 2026-10-10T21:36Z **Claude → @Operator:** Plan 007 is done. To watch and look:
  - **Video:** `build/videos/grave-start.mp4`, 42 s at 1080p. The opening,
    Unknown's arrival at his grave, the push-in on the stone, his lines on the
    U and the inscription, and back out. There is no voice yet (plan 003).
  - **Screenshots:** `build/screenshots/grave-start/`, 17 shots from the
    opening through the grave and the stone to the nave and the flashback.
  - **Next:** plan 004's remaining slices, starting with saves.
- 2026-10-10T21:47Z **Claude → @Operator:** Plan 004 slice 6 is done: saves. There are six
  manual slots and an autosave on every room change. Each save has a thumbnail
  and puts Unknown back exactly where he stood. Saves survive a reload in the
  browser too. The save and load menus come with slice 8.
- 2026-10-10T21:57Z **Claude → @Operator:** Plan 004 slice 7 is done: settings.
  - **What's in:** volumes, subtitles and their size, text speed, Reduce
    flashing, Reduce camera motion, fullscreen and Render at 1080p. Each applies
    the moment it changes and is remembered.
  - **Reduce camera motion:** the opening crossfades to the vista instead of
    pulling back, and close-ups fade in without the zoom.
  - **Render scale:** recorded as a technical pick under #29. "Render scale"
    became a Render at 1080p switch, because Godot can't scale 2D rendering
    below that without a bigger rework.
  - **Next:** the settings screen comes with the top bar in slice 8.
- 2026-10-10T22:08Z **Claude → @Operator:** Plan 004 slice 8 is done.
  - **The bar:** move the cursor to the top of the screen and it slides down:
    Journal, Save, Load, Settings, Reveal hotspots and Quit.
  - **Pages:** saving and loading show each slot's picture, room and date. The
    settings page has every option from slice 7. Reveal hotspots marks
    everything you can use for a moment.
  - **Next:** slice 9, the hint on Unknown.
- 2026-10-10T22:16Z **Claude → @Operator:** Plan 004 slice 9 is done: click Unknown and he
  thinks aloud about what to do next, more directly each time you ask. The
  hint lines are placeholders for the grave → cathedral → statue chain, until
  the prologue script exists.
- 2026-10-10T22:23Z **Claude → @Operator:** Plan 004 slice 10 is done: skipping.
  - **The opening:** move the mouse to show Skip, then hold it for a moment.
    Esc also works. A stray click no longer skips it.
  - **Fullscreen:** the desktop game now starts fullscreen by default.
  - **Next:** slice 11, the greybox puzzle chain.
- 2026-10-10T22:41Z **Claude → @Operator:** Plan 004 slice 11 is done: a greybox puzzle
  chain in three plain grey rooms, played start to finish by a test and in the
  browser.
  - **What it covers:** every verb, combining the rag and the oil, a dialogue
    choice, and a flashback that shows the word the gate needs.
  - **Inventory fix:** building it exposed that two items could never be
    combined, and that is fixed.
  - **Next:** slice 12, measuring and recording.
- 2026-10-10T22:56Z **Claude → @Operator:** Plan 004 slice 12 is half done.
  - **macOS app:** every scripted scenario passes in a fresh export, and it
    holds 120 fps at 1080p with 222 MiB of video memory
    (`docs/qa/004/README.md`).
  - **Fixed:** the fullscreen default no longer overrides a window given on
    the command line.
  - **Paused:** the browser frame times and the chain recording wait until
    you're off the Mac.
- 2026-10-10T22:57Z **Claude → @Operator:** Plan 005 (the cinematic toolkit) is written:
  `plans/005-cinematic-toolkit.md`. It covers a cutscene runner with skipping
  for every scene, visions that record memories, playable memories, reveals and
  memory vistas, and the journal. It has no image budget; any art it needs is
  drawn in code. It starts once plan 004's last slice is measured, after you
  free the Mac.
- 2026-10-11T00:44Z **Claude → @Operator:** Plan 004 is done.
  - **Both builds:** the macOS app and the browser build finish the greybox
    chain and pass every scripted check.
  - **Video:** `build/videos/greybox-chain.mp4`, 97 s, the chain at reading
    pace.
  - **Browser saves fix:** saves were being lost on reload. Godot's shader
    cache kept writing into the browser's storage and held saves back until
    the game quit, which a browser never does. It's now off in the web build
    (#38).
  - **Re-measure later:** the browser frame times were taken while your Mac
    was very busy. I'll measure them again when it's quiet.
  - **Next:** plan 005, starting with the cutscene runner.
- 2026-10-11T00:49Z **Claude → @Operator:** Plan 005 slice 1 is done: the cutscene runner.
  Scenes are scripts of steps, played with input locked and letterbox bars. A
  skip finishes every step at once and leaves the world exactly as watching
  would. Next is slice 2: the same skip for every cutscene, starting with the
  opening.
- 2026-10-11T01:00Z **Claude → @Operator:** Plan 005 slice 2 is done. The opening now runs
  on the cutscene runner, so every scene skips the same way: hold Skip or press
  Esc. It looks just as before. Next is slice 3: flashbacks as cutscenes that
  record their memory.
- 2026-10-11T01:09Z **Claude → @Operator:** Plan 005 slice 3 is done. Flashbacks are now
  cutscenes.
  - **Skipping:** a skip lands you back in the present at once.
  - **Memories:** each one records the memory it showed.
  - **Look:** they play in letterbox like the opening.

  Next is slice 4: playable memories, where you walk around in the past.
- 2026-10-11T01:18Z **Claude → @Operator:** Plan 005 slice 4 is done: playable memories.
  In the greybox chapel, touching the altar now takes you into its past. You
  walk around there, read the carving, and come back. The cathedral statue
  stays a watched vision. Next is slice 5: the discovery reveal and the memory
  vista.
- 2026-10-11T01:35Z **Claude → @Operator:** Plan 005 slice 5 is done: reveals and memory
  vistas.
  - **Reveals:** any pull-back reveal can now play in the middle of the game
    and return to the room.
  - **Memory vistas:** the same reveal shown in the past's warm grade.
  - **Where to see them:** in the greybox courtyard, the path reveals the
    land beyond, and the milestone shows it as it was.

  Next is slice 6: the journal.
- 2026-10-11T01:45Z **Claude → @Operator:** Plan 005 slice 6 is done: the journal.
  - **Memories:** a page each, with a still taken the first time you saw it
    and Unknown's line.
  - **Who am I?:** what he's learned, under the name "Unknown".
  - **Watch again:** replays scenes and puts everything back afterwards.
  - **Wording:** the memory titles, lines and facts are placeholders until
    the script.
  - **Next:** slice 7, measuring and recording the toolkit.
- 2026-10-11T02:26Z **Claude → @Operator:** Plan 005, the cinematic toolkit, is done.
  - **Video:** `build/videos/toolkit-reel.mp4`, 104 s, one of each: a skipped
    opening, a vision, a playable memory, a reveal, a memory vista and the
    journal.
  - **Both builds:** everything runs in the macOS app and in the browser.
  - **Bug found by the reel:** Unknown took clicks meant for the altar he
    stood in front of. What's behind him wins now.
  - **Frame times:** taken while your Mac was extremely busy, so I'll redo
    them when it's quiet.
  - **What's next:**
    - plan 003 (voice) is waiting on the ElevenLabs details, board #4 and #7;
    - plan 006 (the prologue) needs plan 003 and the story track.
- 2026-10-11T02:34Z **Claude → @Operator:** Plan 006 (the prologue vertical slice) is
  written: `plans/006-prologue-vertical-slice.md`.
  - **What it needs from you before it can start:**
    - sign plan 002's look gate (#31);
    - the ElevenLabs details (#4, #7) for plan 003;
    - the story-track sessions for the prologue's script and puzzle chart;
    - its budgets.
  - **Until then:** I can re-measure frame times once the machine is quiet.
- 2026-10-11T03:10Z **Claude → @Operator:** Plan 003 slice 1 is done: the `tools/audio`
  skeleton.
  - **What it does:** reads all 73 voiced lines into a manifest and knows which
    need generating. It never sends the same request twice, and it backs off
    when ElevenLabs is busy.
  - **Cost:** nothing; it needs no key.
  - **To go further (casting):** the plan tier and credit ceiling (#4), the key
    in `.env`, and whether you publish as an individual or a company (#7).
- 2026-10-11T09:10Z **Claude → @Operator:** Plan 003 slice 5 is done, checked with a
  stand-in tone: the game can play voiced lines.
  - **What works:** a voiced line stays up until its audio ends, and a click
    skips it. Unknown's eyes and smoke follow how loud the line is. A line
    without audio keeps its text timing.
  - **Browser fix:** Chrome plays no sound until the player's first click. The
    first browser run hung on a line whose audio never started. Now such a
    line keeps its text timing (decision #40).
  - **Seen in the browser:** on a cold load, with your Mac very busy, a 1 s
    line ran up to 2 s, because the browser build mixes sound between frames.
    I'll re-measure when the machine is quiet.
  - **Cost:** nothing.
  - **Still waiting:** casting and real lines need #4 and #7.
- 2026-10-11T09:18Z **Claude → @Operator:** `post` is built (plan 003 slice 4):
  ElevenLabs masters will become the game's voice lines automatically.
  - **What it does:** it trims each line, sets its loudness, and writes it
    where the game finds it, along with the loudness envelope that drives
    Unknown's eyes and smoke.
  - **One change, decision #41:** voice ships as QOA, which Godot compresses
    itself, instead of Ogg. This machine has no Ogg encoder, and QOA is
    cheaper for the browser to play. Ten minutes of voice is about 6 MB.
  - **Cost:** nothing.
- 2026-10-11T20:11Z **Claude → @Operator:** Unknown is leaner and his smoke is
  ink, after IMG-0003 v1, as you asked (decision #42).
  - **Body:** narrower and thinner, with the shoulders kept broad, so he reads
    lean and wiry instead of bulky. All 36 animations were re-rendered; the
    walk and poses are unchanged.
  - **Ink:** the strands are now fine, wavering ink threads that hang down,
    fray, and dissolve at their ends. They merge into one translucent film
    and thicken into a sheet near his back. No more tentacle tips.
  - **Compare:** `art-source/work/review/unknown-lean-ink.jpg` shows v1, then
    before and after from the front and side.
  - **Checked:** 114 GUT tests pass, and the `unknown_look` run passes on
    desktop. In the browser the ink draws correctly. `browser-qa.ts` can now
    save page screenshots, given a folder as a fifth argument.
  - **Found, not caused by this change:** in the browser build, Unknown's
    sheets measure about 400 MiB against the 128 MiB budget (desktop 100 MiB),
    so `unknown_look`'s budget check fails there. The likely cause is WebGL
    holding the two-byte grey + alpha frames as four bytes a pixel. It needs a
    fix before the browser demo (plan 006).
  - **Cost:** nothing.
- 2026-10-11T21:00Z **Claude → @Operator:** Unknown is back to his body and
  head from before 20:11Z, keeping only the ink threads on his back, as you
  asked (decision #42, rewritten).
  - **Reverted:** the leaner body, the upright stance and the reworked faceless
    head. They looked worse than the original.
  - **Kept:** the ink threads, now on the original body.
  - **Checked:** 114 GUT tests pass (one run had a single failure while
    Blender rendered alongside; the rerun passed), and the `unknown_look` run
    passes on desktop.
  - **Still open:** the head and the eyes' placement, which you flagged. Next
    time I change one thing at a time and show you before committing.
  - **Cost:** nothing.
- 2026-10-11T21:22Z **Claude → @Operator:** Plan 008 is written:
  `plans/008-fifty-rooms.md`, 50 new rooms after the grave, with 13 NPCs, and
  art by GPT-6.1 Sol through Codex.
  - **Recorded:** your answers are decisions #43–#46: the Thief of names core,
    Sol via Codex, $50 of gateway budget, and 50 new playable rooms.
  - **Story drafts:**
    - `docs/story/bible.md`: the truth, the world's rules, the arc, and five
      part outlines;
    - `docs/story/cast.md`: 13 NPCs, each someone Ulric took something from;
    - `docs/story/atlas.md`: all 50 rooms, now, then and play.
  - **Yours to decide:** #10 (story sign-off), #11 (the look gate), #12 (the
    female base mesh download) and #13 (LFS storage).
  - **Can start now:** slice 0 (the Sol handshake and spike), slice 2 (the
    production frame) and slice 3 (the Gravedigger as the NPC proof).
  - **Cost so far:** nothing.
- 2026-10-11T21:55Z **Claude → @Operator:** Plan 008 slice 0 is done: Sol makes our art.
  - **How:** a request with `"model": "codex/gpt-6.1-sol"` runs through Codex
    in a read-only sandbox. The images are copied untouched into
    `art-source/raw/`, with a receipt like the gateway's (decision #47).
  - **First images:** IMG-0011, the cemetery gate, matches the grave's
    style. Its colour past, IMG-0012, lines up within 1.6 px.
  - **Limit:** Sol's images are 1672×941, so rooms are upscaled 1.15×. The
    gateway keeps the wide vista rings.
  - **Cost:** $0. Sol is on your ChatGPT plan.
- 2026-10-11T22:00Z **Claude → @Operator:** Plan 008 slice 1. I'm taking your
  "execute the entire plan" as the sign-off for the story drafts (#10), the
  look gate (#11) and memory figures (#5), recorded as decision #48. Any of
  it is still yours to change. #12 (the female base mesh) waits until the
  NPC route is chosen in slice 3, and may not be needed.
- 2026-10-11T22:30Z **Claude → @Operator:** Plan 008 slice 2 is done: the production frame.
  - **Rooms from data:** a room is now one data file, built by
    `past-art room`.
  - **Requests from templates:** requests are written from shared prompt
    templates.
  - **Demo stays small:** chapters 1–4 are left out of the browser demo
    automatically.
  - **Checks:** a test checks every room, and a QA tour shows each part's
    rooms in both eras.
- 2026-10-12T00:05Z **Claude → @Operator:** Plan 008 slice 3 is done: the NPC route,
  proven on the Gravedigger.
  - **How:** Sol paints each NPC once. The painting is meshed and skinned to
    a few bones, so he breathes, nods while he talks and leans on his spade.
    His feet stay planted.
  - **Cost:** about 15 min an NPC instead of hours in Blender, and under
    1 MiB of video memory (decision #49). The female base mesh (#12) isn't
    needed after all.
  - **See:** `docs/qa/008/npc/gravedigger-motions.jpg`.
- 2026-10-12T02:20Z **Claude → @Operator:** Plan 008 slice 4 is done: the prologue
  plays from the grave to the great doors.
  - **What's new:** five new rooms (the gate, the lodge, the ossuary, the
    cloister, the choir loft) with their colour pasts, the Gravedigger and
    the Sister to talk to, three close-ups, five items and two new visions.
  - **Where it ends:** the great doors open on chapter 1. In the browser
    demo they open on an end card.
  - **Checked:** a scripted player finishes it in the tests, in the desktop
    game and in Chrome. See `docs/qa/008/prologue/`.
  - **Cost:** $0. All the art is Sol's, on your ChatGPT plan.
- 2026-10-12T05:45Z **Claude → @Operator:** Plan 008 slice 5 is done: chapter 1, The
  Nameless Streets, plays from the great doors to the lower gate.
  - **What's in it:** 12 new rooms with their colour pasts, four people to
    talk to (the Crier, the Lamplighter, the Broker, the Clockmaker), five
    close-ups, and a playable memory inside the clock.
  - **The first turn:** the Lamplighter gets his name back, Mathis, and his
    street keeps its warm light. Unknown learns the memories he sees aren't
    his.
  - **Fixed on the way:** the browser demo's download had doubled from stray
    files. It's back to 143 MB, under its 150 MB budget.
  - **See:** `docs/qa/008/ch1/`.
  - **Cost:** $0.
- 2026-10-12T07:15Z **Claude → @Operator:** Plan 008 slice 5b: every area now has its
  pull-back reveal with a title card: the old town, the drowned quarter, the
  upper city and the cathedral heights. The old town's plays when you first
  step out of the cathedral. See `docs/qa/008/reveals/`. These were the first
  images that needed the gateway (3:1 panoramas): $1.14 of the $50.
- 2026-10-12T09:45Z **Claude → @Operator:** Plan 008 slice 6 is done: chapter 2, The
  Drowned Quarter, plays from the flooded stair to the valve house.
  - **What's in it:** 11 rooms with their colour pasts, a ferry between the
    drowned rooms, and three people to talk to (the Ferryman, the
    Washerwoman, the Plague Doctor).
  - **The turn:** at the valve, Unknown finally sees the burned-out figure
    from inside. It's him, Ulric, the High Magistrate, and the flood was his
    doing. Draining the quarter gives three people their names back.
  - **See:** `docs/qa/008/ch2/`.
  - **Cost:** $0 (Sol).
- 2026-10-12T14:30Z **Claude → @Operator:** Plan 008 slice 7 is done: chapter 3, The
  Hall of Records, plays from the upper avenue to the covered bridge.
  - **What's in it:** 12 rooms, and three people to talk to (the Hangman, the
    Puppeteer and her play, the Registrar).
  - **The playable memory:** you play as Ulric at his own desk, and strike
    the Dove's name yourself.
  - **See:** `docs/qa/008/ch3/`.
  - **Cost:** $0.
- 2026-10-12T16:40Z **Claude → @Operator:** Plan 008 slice 8 is done: chapter 4, The
  Dovecote. The story now plays all the way to the end.
  - **The ending:** the Dove, Elise, forgives him. He gives the Registrar his
    name back, Edmund Vey, and takes the book. At the bell he reads every
    name, hers, then his own. The city, Aurelle, takes its colour back.
  - **The last scene:** the grave at dawn, the stone recut ULRIC, and "I
    know you are happy now". The journal finally reads Ulric.
  - **See:** `docs/qa/008/ch4/`.
  - **Cost:** $0.
- 2026-10-12T17:30Z **Claude → @Operator:** Plan 008 is done. The whole story plays
  from the grave to the dawn in the macOS app.
  - **What's in:** 50 new rooms (42 with their colour past), 13 people to
    talk to, 20 close-ups, four area reveals, 18 items, 17 memories, and
    1,069 lines ready for voice (about 69 minutes).
  - **Checked:** a scripted player finishes the whole game in the exported
    app. Every room stays well inside its memory budget, and the prologue
    still runs in the browser demo.
  - **Watch:** `docs/qa/008/fifty-rooms-reel.mp4`, every room fading from
    now to then. The metrics are in `docs/qa/008/README.md`.
  - **Cost:** $1.14 of the $50 gateway budget. Sol made 336 of the 360
    images on your ChatGPT plan.
  - **Next:** voice (plan 003, waiting on #4 and #7), then plan 006 for the
    prologue's release. The browser demo is at 143 MB of 150 MB.
  - **Board #13** closes: LFS took about 1 GB of raws, and every push
    went through.
- 2026-10-12T09:14Z **Claude → @Operator:** The browser demo is live on Vercel at
  https://past-nu.vercel.app (decision #50).
  - **What's there:** the prologue, as before. It's a 183 MB static build in
    the `past` project on the OrcDev team, and it's public.
  - **Checked:** `browser-qa.ts prologue` passes in Chrome against the live
    site (`QA_BASE_URL`), and the token file Vercel's link writes isn't
    served.
  - **Redeploy:** `tools/build/export.sh web`, then `tools/build/deploy.sh`
    (a preview) or `deploy.sh --prod`.
  - **Cost:** /bin/zsh so far. Every play downloads about 150 MB of the team's
    Vercel bandwidth.
- 2026-10-12T09:33Z **Claude → @Operator:** The browser demo has a loading screen of its own
  (decision #51).
  - **What it does:** the ruined nave waits in grey, and its past blooms back
    in gold from the rose window as the game downloads. PAST is in the
    opening card's spaced capitals. When the download is done, "Click to
    remember" starts the game with sound.
  - **Also changed:** Godot's logo is gone from the boot splash (desktop too),
    and the browser tab's icon is now the rose window.
  - **Cost:** $0. The pictures are the nave's existing art.
- 2026-10-12T13:37Z **Claude → @Operator:** Plan 008's last slice had two gaps, now closed.
  - **Room load and frame time** (slice 9, step 3) had not been measured.
    The room tour now times both, and all 52 rooms pass in the macOS app:
    loading takes 29–221 ms against the 1 s budget, and the frame-time p95
    is 16.7 ms or less, with `theater_stage` closest to the line.
  - **Hours per part** (step 4) are now in `docs/qa/008/README.md`. The
    five parts took 215 min for 50 rooms, about 4.3 min per room. Chapter 1
    took 6.0 min per room and chapter 4 took 2.3.
  - **Cost:** $0.
- 2026-10-12T17:28Z **Claude → @Operator:** The game now opens on a start screen (plan 009, decision #52).
  - **What you see:** Unknown's grave under the moon, softly blurred, with
    fog drifting across it. PAST and the menu sit on the left: Continue (only
    when there's a save), New Game, Load Game, Settings and Quit.
  - **In the game:** the top bar has a new **Main menu**, which brings the
    same screen up over the paused game with Resume and Save Game.
  - **Save Game** shows only over a game, because at launch there's nothing
    to save.
  - **Checks:** `--qa=title` passes in the macOS app and in Chrome, and the
    prologue check still passes in Chrome. There are 133 GUT tests and the
    lint passes. The screenshots are in `docs/qa/009/`.
  - **Cost:** $0. The picture is the grave room's own painting.
  - **Not changed:** the live Vercel demo. It needs a redeploy
    (`tools/build/deploy.sh`) to show the start screen.
- 2026-10-16T06:03Z **Claude → @Operator:** Unknown is redrawn (plan 010, decision #53). Please look before I commit.
  - **What changed:** he's a hand-inked comic-cartoon shadow now, painted by
    Sol: a torn greatcoat with a tall collar whose hem frays into ink, a shock
    of hair and two round glowing eyes. Every walk and action, in all three
    directions, is painted.
  - **Watch:** `docs/qa/010/unknown-reel.mp4` (36 s) and the pictures beside
    it, or play the game.
  - **Checks:** the whole game passes in the macOS app, all 52 rooms pass the
    tour, 133 GUT tests pass, and the prologue passes in Chrome.
  - **Side effects:** video memory per room is down to 102–144 MiB, and the
    browser demo's pack is down from 143 MB to 53 MB, which leaves room for
    voice and music.
  - **Off for now:** the old ink tendrils. The coat frays into ink of its own;
    they can come back if you want them.
  - **Cost:** $0. Sol made 75 images on your ChatGPT plan.
- 2026-10-16T17:30Z **Claude:** The operator shipped the redrawn Unknown (plan 010, decision #53 confirmed): "push to main and deploy".
  - **Shipped:** pushed to `main`, then the browser demo is exported again from
    this commit and deployed to prod (`tools/build/deploy.sh --prod`), because
    each push to `main` replaces prod with an empty Vercel build.
- 2026-10-16T18:05Z **Claude → @Operator:** Key 13 could not be taken after reading it (decision #54).
  - **Cause:** a design trap, not a crash. "Ossuary: key 13" is painted on the
    register's page, but only a click on that note counted as reading it, and
    a plain click on the key wall only looked at it (taking needed the verb
    coin's hand, which nothing teaches before this).
  - **Fix:** opening a close-up reads the writing on it (register, edict
    board, ledger index, gravestone), and a click on the key wall takes the
    key. The prologue playthrough now takes that plain path.
  - **Still open:** the verb coin (press and hold) is never taught in the
    game, and the ossuary's niches and nest need it next.
- 2026-10-20T15:30Z **Claude:** The full game now runs in the browser (decision #56, operator direction).
  - **Report:** "When I end the prologue it does not go further … I am inside of the church and I cannot go out." Not a crash: the browser build was prologue-only (#20, #50), so the west doors showed the prologue's closing card and returned the player to the nave.
  - **Choice:** the operator picked "Ship the full game on the web" over closing the demo properly or adding chapter 1 only.
  - **Change:** every part in `content/chapters.json` is marked `web`, so `tools/build/export.sh web` keeps chapters 1–4 and the doors lead into `cathedral_parvis`. The web pack grows from 52.6 MB to about 259 MB, and #20's browser audio limits now apply to every chapter.
  - **Set aside:** the uncommitted verb-coin hint (#55) is in `git stash` ("wip: verb coin hint (#55)…") and is restored, uncommitted, after the deploy.
- 2026-10-20T16:40Z **Claude:** Shipped the full game in the browser (#56): `tools/build/deploy.sh --prod` from `52f8429`, live at https://past-nu.vercel.app.
  - **Pack:** `index.pck` is 258.6 MB (was 52.6 MB); the build is 295 MB, under Vercel Pro's 1 GB upload.
  - **Checks:** `browser-qa.ts prologue` passes locally and against prod, through the west doors into `cathedral_parvis`. `ch1` (62 checks), `ch2` (52), `ch3` (56) and `ch4` (31) pass in Chrome against the same build, with no console errors or crashes. 133 GUT tests and the lint pass.
  - **Still to watch:** #20's browser audio limits over a full play in one tab; the chapter runs above start fresh per chapter.
