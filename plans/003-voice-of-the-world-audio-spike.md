# 003 — Voice of the world: ElevenLabs pipeline spike

Status: planned 2026-10-09. Owner: Claude. The operator chooses the ElevenLabs
plan and credit ceiling, casts the voices and listens to the key lines.

## Goal

A scripted, cached ElevenLabs pipeline that takes lines written in the game
scripts and plays them voiced, subtitled and voice-reactive in the browser and
desktop builds. It also produces the first sound effects and a now/then music
pair, and measures the credit cost of all of it.

## Depends on

- Plan 001 is done.
- The operator has:
  - chosen the plan (Creator recommended for this spike);
  - put `ELEVENLABS_API_KEY` in `.env`;
  - set a credit ceiling for this plan. 60k credits is suggested; board #4.
- Plan 002 is not required. Without it, use the placeholder room from 001. If 002
  is done, wire everything into the cathedral.

## Slices

### Slice 1 — `tools/audio` skeleton

1. A Bun + TypeScript workspace with:
   - an API client with concurrency limits and backoff on HTTP 429;
   - the request-hash cache;
   - a credits report from the subscription endpoint.
2. `bun test` covers hashing, manifest diffing and the `# vo:` comment parser.
   No test touches the network.
3. Bun loads `ELEVENLABS_API_KEY` from the operator's `.env`. The variable is
   documented in `tools/README.md`.

### Slice 2 — Casting

1. Write briefs for Unknown (`audio-pipeline.md` §4.1) and for one test NPC.
2. Run two or three Voice Design prompts per character on `eleven_ttv_v3`, which
   gives three previews each.
3. Build a local listening page with blind labels.
4. The operator picks a voice, which is saved to the account and recorded in
   `audio-source/voices.json`.

### Slice 3 — Model A/B

Ten lines for Unknown that cover:

- neutral;
- a wry joke;
- a whisper;
- fear;
- sorrow;
- a long sentence;
- an invented name.

Generate each line on v4, v3 and Multilingual v2 with tags or settings to suit
the model. The operator picks a model per character from blind labels. Record
whether v4 accepts request stitching.

### Slice 4 — Line pipeline

1. Write lines into a test `.dialogue` file. Every line gets a static `[ID:…]`
   and voice direction in Dialogue Manager tags. Confirm the tag syntax against
   the pinned release.
2. Run `ids` → `extract` → `voice` → `check` → `post` → import into Godot.
3. Every line ends up as a master WAV with metadata, a lock entry, a word-match
   result, a game line (a WAV that Godot imports as QOA, decision #41) and an
   envelope.

### Slice 5 — Runtime

1. A `Voice` autoload that the balloon calls with each line's ID
   (`technical-plan.md` §6.5). In the browser build, voice and music use
   `playback_type = Stream` (§7).
2. Subtitles per speaker. The line holds until its audio ends, and a click skips
   it.
3. Unknown's eyes and smoke follow the envelope. If plan 002 is not done yet,
   use a placeholder glow.

### Slice 6 — Dialogue scene test

Produce one six-line, two-speaker exchange in two ways: per line with stitching,
and as Text to Dialogue split by `voice_segments`. The operator picks the default
for fixed-order scenes.

### Slice 7 — Sound effects

- Cathedral ambience loops, 30 s each:
  - now: wind, drips, a distant bell;
  - then: choir hum, crowd murmur, birds.
- Six variants of footsteps on stone.
- The flashback in and out stingers.
- A UI click.

### Slice 8 — Music

1. Make the cathedral theme now: about 90 s, loopable, from a composition plan.
2. Make the then arrangement twice, once from the same plan with warm styles and
   once conditioned on a slice of the now theme.
3. The operator picks one.
4. Loop both and crossfade them in Godot. Use the flashback transition if plan
   002 is done.

### Slice 9 — Browser check

- Play everything in the macOS build, and in Chrome, Firefox and Safari on the
  operator's Mac.
- Measure:
  - first-line latency with Stream playback in the single-threaded browser
    build, and whether there is any crackle under load;
  - memory after playing 100 lines;
  - loop seams;
  - ducking by tweens;
  - how the volume settings apply.
- Confirm that nothing analyses audio at runtime.

### Slice 10 — Report

- Credits per slice.
- Projected credits per line, per minute of voice and per area.
- The recommended plan tier for production.
- Any licence questions for ElevenLabs: the indie-game music clause and the
  isolated-files rule for sound effects.

## STOP conditions

- Spend reaches 80% of the credit ceiling: stop and report.
- The terms block what we intend to do, either the music tier or how sound
  effects ship: stop and report to the operator.
- After three casting rounds, no designed voice works for Unknown: stop and offer
  the alternative, hiring an actor and using professional voice cloning, which
  needs the actor's consent and verification.
- More than 5% of lines fail the word-match check on the chosen model: stop and
  adjust the model, settings or text before generating more.

## Definition of done

- In the browser and desktop builds, Unknown and the test NPC speak voiced,
  subtitled lines. Unknown's eyes and smoke react to his voice. The ambience,
  footsteps, stingers and now/then music play.
- The pipeline is re-runnable without spending credits on unchanged lines.
- The report is on the board.

## Effort

About 2–3 working sessions, plus the operator's casting and listening sessions.

## Execution record
- **2026-10-11, slice 1:** the `tools/audio` skeleton, built ahead of board #4
  and #7 because it needs no key and spends nothing.
  - **Pieces:**
    - the ElevenLabs client: concurrency per plan tier, and backoff on HTTP
      429 that honours Retry-After;
    - the request-hash cache: a request never calls the API twice unless
      forced;
    - the subscription report;
    - `extract` and `diff`, which read the dialogue files into the manifest
      and compare it with the lock.
  - **Tag syntax:** checked against Dialogue Manager 4.1.0. Voice direction is
    a line tag, `[#vo=whispers]`, read with `get_tag_value("vo")`. That
    supersedes this plan's earlier "`# vo:` comment" wording.
  - **The real dialogue:** `extract` finds 73 spoken lines, one for every
    `[ID:` in the content (68 for Unknown, 5 for the Gatekeeper).
  - **Tests:** 12 `bun test` cases, with no network. They caught a missing
    Retry-After header being read as "retry at once".
  - **Next:** slice 2 (casting) needs the plan tier and credit ceiling (board
    #4), the key in `.env`, and the publishing entity (#7).
- **2026-10-11, slice 5:** the runtime, built and checked with a tone made in
  memory, since no line has audio before casting.
  - **Pieces:**
    - the `Voice` autoload: loads a line's audio by its ID, plays it streamed on
      the Voice bus, and reads its envelope from the table `post` will write;
    - `Say` holds a voiced line until its audio ends, and a click skips it and
      stops the audio. Subtitles already sit over their speaker, in the
      speaker's color;
    - Unknown's eyes and smoke follow the line's level. A line without audio
      keeps text timing and his stand-in flicker;
    - the buses: Voice, Music, Ambience, SFX and UI, into Master.
  - **The browser:** the first run timed out. Chrome plays no sound before a
    click, so the line's audio never started and the line waited forever. A
    line whose audio stalls now keeps text timing (decision #40), and the
    browser QA allows sound from the start.
  - **Checks:**
    - GUT: 4 tests in `test/integration/test_voice.gd` (113 in all);
    - the `voice` QA scenario on macOS: held 1.00 s for 1 s of audio;
    - in Chrome: 1.09–1.13 s on warm passes, but 1.41–2.01 s on a cold load
      at a load average near 50. Long frames there hold back the build's
      main-thread mixing. Slice 9 measures it on a quiet machine.
  - **Left:** real lines go through it once slices 2–4 make them.
- **2026-10-11, slice 4, `post` only:** built ahead, because it spends
  nothing.
  - **What it does:** each master in `audio-source/voice/masters/` is trimmed
    (80 ms lead, 200 ms tail), brought to −18 LUFS with one gain capped at
    −1 dBTP, and written as a 24 kHz mono WAV in `assets/audio/voice/en/`,
    which Godot imports as QOA (decision #41). Its 30-a-second envelope goes
    into `envelopes.gd`, which `Voice` reads. `audio-source/voice/post.json`
    keeps hashes, so only changed masters are posted again.
  - **Checks:**
    - 8 new `bun test` cases (20 in all), one of which runs ffmpeg: a quiet
      master comes out within 0.3 LU of −18 LUFS;
    - a GUT test plays a line from files `post` made, imported as QOA, with
      its envelope from the table;
    - on a scratch line spoken by macOS `say` (not kept), peaks capped the
      gain at −19 LUFS, and the envelope was silent in pauses, with a median
      of 174 of 255 in speech.
  - **Left in slice 4:** `ids`, `check` (word match), and running the whole
    chain on real lines.
