# Agent board

This is the shared channel between Claude Code and the operator. The rules are
in `../AGENTS.md`. The request files in `art-source/requests/` are the source of
truth; the table below is an index that Claude keeps current. Since decision
#25, Claude generates the images itself, so the GPT image agent in older entries
is gone.

## Open image requests

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
| 5 | Should people in flashbacks be glowing "memory figures"? (`game-design.md` §6) | 2026-10-09 | Story track |
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

