# Past — Audio Pipeline (ElevenLabs)

Status: draft, 2026-10-09. ElevenLabs facts were checked against its docs, pricing
page and terms on 2026-10-09. That same day ElevenLabs updated its Terms of Use,
Music Terms and Sound Effects terms, and Eleven v4 shipped on 2026-09-28. Re-check
the terms before spending money and before release. The Godot browser facts in
§4.5 and §7 were checked against Godot 4.7.2 on the same day.

## 1. Scope

- **Voice:** every spoken line, for every character.
- **Sound effects:**
  - one-shots: footsteps, doors, items, UI;
  - ambience loops;
  - flashback stingers.
- **Music:**
  - each area's theme, arranged twice: *now* (sparse, cold) and *then* (warm,
    full);
  - stingers;
  - title and menu themes;
  - credits.

## 2. Plan, licence and cost (decide before plan 003, board #4)

| Plan | Price / month | Credits / month | Notes |
|---|---|---|---|
| Free | $0 | 10k | Non-commercial; output must credit ElevenLabs |
| Starter | $6 | 30k | Commercial licence starts here |
| Creator | $22 | 121k | Professional voice cloning |
| Pro | $99 | 600k | 44.1 kHz PCM output |
| Scale | $299 | 1.8M | 3 seats |
| Business | $990 | 6M | 10 seats |

Credits roll over for up to two months.

Text-to-speech costs about one credit per character on the v4, v3 and
Multilingual v2 models; check this on the pricing page before relying on it.
Sound effects cost 40 credits per second, so a 30 s loop costs 1,200 credits.

**Estimate:** a long adventure has roughly 3,000–8,000 lines at ~70 characters
each, about 0.2–0.6M characters. Retakes add about 50%. That comes to 3–7 months
of Creator credits, or 1–2 months of Pro. Plan 003 replaces these guesses with
measured numbers.

**Licence points that shape the pipeline:**

- **Music** (Music Terms, 2026-10-09):
  - Self-serve plans allow music in an **Indie Game**. Both conditions must
    hold, counted net of platform fees:
    - the game has earned under $500k since its first release;
    - the developer or publisher earned under $1M from games in its last
      financial year.
  - Free through Pro are for individual use only. A company needs Scale (under
    10 employees) or Business (under 50).
  - If the game outgrows the indie limits, there are 60 days to move to a plan
    that covers "Studio Games".
  - Releasing the soundtrack on streaming services needs Creator or higher.
  - Whether the operator publishes as an individual or a company decides the
    tier.
- **Sound effects:**
  - Allowed in games on commercial plans.
  - Not allowed to be distributed "as isolated audio files or samples". We ship
    audio only inside Godot's packed data, never as loose files, and get written
    confirmation from ElevenLabs before release.
- **Voices:** Voice Library voices can be withdrawn by their owners. Audio made
  before a withdrawal stays usable, but no new lines can be made with that
  voice. **Cast with our own Voice Design voices**, which live in our account,
  not with library voices.
- **Disclosure:** ElevenLabs does not require labelling, but Steam's content
  survey requires AI disclosure. Our manifests and receipts are that record.

**Recommendation:** use Creator for the spike and Pro during the months of voice
production.

## 3. Tooling — `tools/audio` (Bun + TypeScript)

| Command | Does |
|---|---|
| `ids` | Gives every line in `content/dialogue/**/*.dialogue` that lacks one a static Dialogue Manager `[ID:…]`. IDs never change once given. |
| `extract` | Reads the `.dialogue` files and writes `audio-source/voice/manifest.json`. Each entry has the ID, speaker, text, voice direction and source `file:line`. |
| `cast` | Runs Voice Design previews from a casting brief, builds a listening page for the operator, then saves the chosen voice to `audio-source/voices.json` with its voice id, model, settings, design prompt and date. |
| `voice` | Generates the lines that are new or changed (manifest minus lock), within the plan's concurrency limit. Writes master WAVs with metadata and updates the lock. |
| `sfx`, `music` | Generate from sheets (`audio-source/sfx/*.yaml`, `audio-source/music/*.yaml`). Each entry has a prompt, duration, loop flag and seed. |
| `check` | Transcribes each new voice line (speech-to-text or forced alignment) and compares it with the script. Flags added, dropped or garbled words. |
| `post` | Trims, normalises loudness, encodes and computes envelopes into the Godot project (§4.5). |
| `lint` | Every manifest line has audio and an envelope, nothing is orphaned and durations make sense. |
| `report` | Credits used per command and per plan, read from the subscription endpoint before and after each run. |

**Cache rule:** each request is hashed (endpoint + model + voice + settings +
text), and the same hash never calls the API twice unless `--force` is passed.
Requests that hit HTTP 429 back off and retry. Concurrency by plan is 2 / 3 / 5 /
10 / 15 / 15 for Free through Business.

## 4. Voice

### 4.1 Casting

- Each character gets a written brief: age, timbre, accent, pace, attitude and
  three sample lines.
- Voice Design on `eleven_ttv_v3` gives three previews per prompt. Run two or
  three prompts per character. The operator picks one, and it is saved to our
  account.
- **Unknown (draft brief):** a man in his late thirties. A low, soft baritone,
  close to the microphone, slightly breathy and hollow, as if speaking inside a
  quiet stone room. Calm, wry and understated, with dry humor over a layer of
  unease. A neutral English accent. He speaks slowly, with small pauses while he
  decides what he thinks.
- **Model per character:** each character is locked to one model after a blind
  A/B test of v4, v3 and Multilingual v2 on the same ten lines. Designed voices
  "may not be as performative" on v4, and v4 drops the Style and Speed controls,
  so v4 is not assumed. Mixing models within one character is not allowed.

### 4.2 Writing lines for TTS

- Delivery goes in bracket audio tags such as `[whispers]`, `[sighs]` and
  `[laughs]` (v3 and v4). Emotion written as narration gets spoken aloud.
- Invented names use a pronunciation dictionary (up to three per request) or IPA
  between slashes on v4.
- Direction is written as Dialogue Manager tags on the line, never in the spoken
  text. An example is `[#vo=whispers]`; plan 003 confirms the exact tag syntax.
  `extract` turns the tags into audio tags on v3 and v4, or into settings on v2.
- **Text changes:** the lock file stores a hash of each line's text. When the text
  behind an ID changes, the line is marked for regeneration, and the ID stays
  the same.

### 4.3 Generation

- **Default:** one request per line. `previous_text` and `next_text` come from
  the neighbouring lines where the model supports request stitching. v3 does
  not. v4 is unconfirmed, and plan 003 tests it.
- **Fixed-order scenes** with several speakers, such as cutscenes and visions,
  can use `text-to-dialogue/with-timestamps`. It covers v3 and v4, up to 2,000
  characters and 10 voices per request. Its `voice_segments` split the result
  into one file per line with natural back-and-forth timing. Plan 003 compares
  it with per-line generation.
- **Format:** request a WAV/PCM master (24 kHz on Creator; 44.1 kHz needs Pro)
  or 44.1 kHz MP3 at 192 kbps. Never request Opus, because Godot cannot import
  it.
- **Record per line:**
  - model and voice id;
  - settings and seed;
  - request id;
  - date and text hash.
- **Masters are the truth.** Seeds are best effort, v4 changes over time and
  there is no version pinning. A regeneration months later can sound different.
  Each voice keeps a five-line re-test set that is run before production resumes
  after a pause.

### 4.4 Review

Claude cannot hear, so review has two layers:

1. **Automated** (`check`): word match against the script, plus duration
   against text length, leading and trailing silence, clipping and loudness.
   Flagged lines are regenerated with the setting or text adjusted and the
   reason recorded.
2. **Operator listening:** a local review page lists each batch with players,
   grouped by scene. The operator marks retakes, and key story lines always get
   a listen.

### 4.5 Post-processing (`post`)

1. Trim silence. Keep 80 ms before the first speech and 200 ms after the last,
   padded with silence where the master has less, and fade the cuts.
2. Normalise loudness with one gain per line. Starting targets: voice −18
   LUFS, music −23 LUFS, ambience −28 LUFS, and never past −1 dBTP. A line
   whose peaks reach the ceiling first comes out a little quieter: a 4.6 s
   test line with peaks at −1.9 dBTP came out at −19 LUFS. These are tuned in
   plan 003's mix pass.
3. Formats (decision #41):
   - **Voice:** 24 kHz mono 16-bit WAV, `assets/audio/voice/en/<ID>.wav`.
     Godot imports it as QOA, its default, at about 77 kbps. Godot decodes QOA
     itself in every build, and cheaply, which matters in the browser, where
     sound is mixed on the main thread. The WAV never ships; the export
     carries the QOA.
   - **Music and ambience** are stereo. Their format is settled in plan 003
     slices 7 and 8: QOA the same way, or Ogg Vorbis once an encoder is
     installed (this machine's ffmpeg has none).
4. Compute the **envelope**: 30 loudness values per second, each window's RMS
   from −45 dBFS (0) to −12 dBFS (1), kept as bytes. `post` writes them all into
   one table, `assets/audio/voice/en/envelopes.gd` (ID → base64), not
   thousands of small files, and splits it per chapter if it grows. They drive
   Unknown's eyes and smoke, and any NPC (`technical-plan.md` §6.5).
5. `post` keeps what it made in `audio-source/voice/post.json`: each master's
   hash, the settings' hash, the loudness measured, the gain and the envelope.
   A changed master or setting is posted again, and the rest are left alone.

## 5. Sound effects

- One sheet per area. Each entry has an id, a prompt, a duration of 0.5–30 s,
  `loop` (sound model v2 only), `prompt_influence` and a number of variants.
- One-shots such as footsteps get 4–6 variants, and the game picks one at
  random.
- Ambience is a 20–30 s `loop: true` bed with random one-shots on top (distant
  bells, crows, drips), so it never sounds repetitive.
- **Flashback stingers:** a heartbeat with a rising tone going in, and a
  reversed swell coming out.
- The masters are the formats the API offers (MP3, or PCM at 44.1 kHz on Pro),
  encoded by `post`.

## 6. Music

- `POST /v1/music` (paid plans) with a **composition plan**: up to 30 sections
  of 3–120 s each. Tempo and key are written into the style text, for example
  "60 BPM, D minor", because there are no parameters for them.
  `force_instrumental` works in prompt mode. Artist names in a prompt are
  rejected.
- **Now/then pairs:** the then arrangement either reuses the now composition plan
  with warm styles, or is conditioned on a slice of the now theme of up to 30 s
  (`conditioning_ref` with `condition_strength`) so the melody carries over.
  Plan 003 tests both.
- **Loops:** use the inpainting loop technique, or let `post` crossfade the tail
  into the head. Godot then loops the file with a loop offset.
- **Stem separation** is available for adaptive mixes later, for example
  bringing a choir in during flashbacks.
- The licence tier is in §2.

## 7. Mix and runtime

- **Buses:** Master → Voice, Music, Ambience, SFX, UI. The settings screen
  controls each one.
- **Ducking** under voice is done by tweening volumes in code, not with bus
  effects.
- **Flashbacks** crossfade the now ambience and music into the then versions,
  with stingers on top. Any filtered or reverberant variants are rendered
  offline, so the browser and desktop builds sound the same.
- **Desktop builds** play everything in Godot's Stream mode, where bus effects
  work. We still don't design around them.
- **The browser demo** (`technical-plan.md` §7):
  - The browser's default "Sample" mode has no bus effects. It freezes the game
    the first time a long clip plays, and it never frees decoded audio.
  - Voice and music therefore play with `playback_type = Stream`.
  - Short effects stay on Sample and are decoded during loading.
  - Sample mode sometimes ignores pitch, so footstep variety comes from the
    pre-rendered variants (§5), not from pitch changes.

## 8. Folder layout

```
audio-source/          # masters and data — LFS, never imported by Godot (.gdignore)
  voices.json          # speaker → voice id, model, settings, design prompt
  voice/manifest.json  # from `extract` (keyed by Dialogue Manager ID)
  voice/lock.json      # ID → take, settings, request id, text hash
  voice/masters/<id>.wav (+ .json metadata)
  voice/post.json      # from `post`: what each game line was made from
  casting/<speaker>/   # Voice Design previews and briefs
  sfx/*.yaml, sfx/masters/…
  music/*.yaml, music/masters/…
```

Encoded game audio lives in the Godot project (`technical-plan.md` §3).

## 9. Lip sync, only if a character ever shows a mouth

- Unknown has no mouth and gets no lip sync (decision #16).
- If a character with a visible mouth appears in a close-up, there are three
  options:
  - **Rhubarb Lip Sync 1.14.0** (MIT). The script text goes in as a hint. Its
    macOS binary is Intel-only and runs under Rosetta 2.
  - **Montreal Forced Aligner** (phoneme timings).
  - **The Godot "Baked Lipsync" plugin**, which wraps Rhubarb.

  Choose one when the need appears.

## 10. Risks

| Risk | Mitigation |
|---|---|
| Model drift: v4 cannot be pinned | Archive the masters, lock the model per character, run the re-test set |
| Terms changed on 2026-10-09 and may change again | Re-read the Music and SFX terms before release. Get written confirmation on the indie-game music clause and the isolated-files SFX clause. |
| Designed voices may be weaker on v4 | Blind A/B in plan 003 |
| Claude cannot listen | `check` plus operator listening sessions |
| Thousands of lines hit concurrency limits | Queue with backoff. Generate in nightly batches. |
