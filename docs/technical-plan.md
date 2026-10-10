# Past — Technical Plan

Status: draft, 2026-10-09. The engine and browser facts were checked against
Godot 4.7.2's docs and source on 2026-10-09. Popochiu was evaluated and dropped
(`decisions.md` #19). The full game ships on desktop and the prologue runs in the
browser as a demo (#20).

## 1. Versions (pinned)

| Component | Version | Notes |
|---|---|---|
| Godot | **4.7.2-stable** (2026-08-18), `4.7.2.stable.official.ed1daf0bf` | Latest stable. 4.8 is in dev (feature freeze); revisit when it is stable. The macOS zip and the export templates were checked against the release's `SHA512-SUMS.txt`. |
| Dialogue Manager | **4.1.0** (2026-09-04), tag commit `a719088` | Nathan Hoad's dialogue add-on, MIT. v4 targets Godot 4.6+. Vendored from the tag tarball (SHA-256 `703b181a…13158`). It imports cleanly on 4.7.2. |
| GUT | **9.7.1** (2026-07-10), tag commit `aeb5d4f` | Unit tests. Targets Godot 4.7.x. Vendored from the tag tarball (SHA-256 `6da99c4e…85613385`). |
| Blender | 4.5 LTS (4.5.13 installed) | Character renders (`art-pipeline.md` §5C) |
| Python (tools) | 3.12 via `uv` | The system Python 3.14 is too new for parts of the ML stack |
| Bun | installed | `tools/audio`, `tools/images`, `tools/build/serve.ts` |
| AI SDK (`ai`) + Vercel AI Gateway | `ai` 7.0.x, pinned in `tools/images/package.json` | Image generation with GPT Image 2.5 (decision #25). The key is `AI_GATEWAY_API_KEY` in `.env`. |
| ffmpeg, ImageMagick, git-lfs | installed (Homebrew) | Media processing, repository |

- Install the exact Godot build from the official 4.7.2 release and check it
  against the published checksums.
- Add the matching export templates.
- Scripts find Godot through `GODOT_BIN`, which defaults to the pinned app path
  (`tools/README.md`).
- Versions change only through a plan.

## 2. Platforms and builds

| Build | What | Where |
|---|---|---|
| **Desktop** (full game) | macOS universal, Windows, Linux | itch.io downloads first, Steam later |
| **Browser demo** | The prologue, exported for the web | itch.io |

- **Renderer:** Compatibility everywhere (OpenGL 3.3 on desktop, WebGL 2 in the
  browser), so the demo and the full game look identical. It renders in 8-bit
  color, with no debanding and no 2D HDR. If plan 002 shows banding in the fog or
  weak glow that grain and dithering cannot hide, we consider Forward+ for
  desktop only.
- **Browser export:**
  - Single-threaded, the default since 4.3, so it needs no special server
    headers.
  - Needs WASM SIMD: Chrome 91+, Firefox 89+, Safari 16.4+.
  - Chrome and Firefox are the main targets, and Safari is best effort. Godot's
    docs warn about WebGL 2 issues in Safari.
  - The engine `.wasm` is 39.5 MB raw, about 10 MB gzipped (itch.io gzips it
    automatically) and 6.9 MB with Brotli.
- **itch.io browser limits:** at most 200 MB per file, 500 MB in total and 1,000
  files. The demo's `.pck` targets 150 MB or less.
- **Desktop template sizes**, before our `.pck`: Windows 109 MB, Linux 74 MB,
  macOS universal 124 MB zipped. The `.pck` stays a separate file.
- **macOS distribution:** a public build needs Developer ID signing and
  notarization, because macOS Sequoia removed the Control-click override. That
  needs an Apple Developer account, which the operator decides on before the
  first public desktop build.
- **Steam:** integration such as achievements uses GodotSteam, a GDExtension, so
  it ships in desktop builds only. A later plan covers it.

## 3. Project layout

The repository root is the Godot project root.

```
past/
  project.godot
  addons/dialogue_manager/   # Dialogue Manager 4 (vendored, pinned)
  addons/gut/                # GUT 9.7.1
  addons/past_tools/         # our editor and headless helpers (room scaffolding, lint, imports)
  src/
    core/                    # adventure core (section 5)
    systems/                 # eras, flashbacks, cinematics, voice, journal, hints, settings (section 6)
    ui/                      # verb coin, inventory, subtitles, top bar, menus
    shaders/
  content/
    rooms/<room_id>/         # room.tscn, room.gd, art/
    characters/<id>/         # actor scene, sprite sheets, anchors
    items/<id>/              # item resource and icon
    dialogue/<chapter>/      # *.dialogue — every spoken line in the game
    cutscenes/<id>/
  assets/                    # shared shipping assets
    audio/voice/en/  audio/music/  audio/ambience/  audio/sfx/  audio/ui/  fonts/  textures/
  test/                      # GUT tests
  tools/                     # .gdignore — art (Python/uv), audio (Bun/TS), blender, build scripts
  art-source/  audio-source/ # .gdignore — image requests, raw generated images, masters, manifests
  docs/  plans/              # .gdignore
  build/                     # gitignored export output
```

- Scripts that Godot itself runs live in `addons/past_tools/`, not in `tools/`.
  Godot does not see `tools/`, because it is ignored. There are seven so far:
  - `new_room.gd` scaffolds a room from an optional JSON spec, which lives in
    `art-source/work/rooms/<room>/room_spec.json`;
  - `new_closeup.gd` builds a close-up view (§6.12) from
    `art-source/work/closeups/<id>/closeup_spec.json`;
  - `new_item.gd` makes inventory items (§5.5) from a JSON list;
  - `scaffold_core.gd` creates `main.tscn` and Unknown's scene
    (`--replace=unknown` rebuilds it);
  - `import_sprites.gd` builds a `CharacterSprites` resource from a sprite
    manifest made by `tools/past-art pack`;
  - `new_reveal.gd` builds a pull-back reveal cutscene from a reveal spec;
  - `lint.gd` checks content.
- Scenes are created by scaffolding scripts that save through Godot, for example
  `addons/past_tools/new_room.gd`, so resource IDs stay valid. They are then
  edited in the editor or by script, and `.tscn` files are never hand-assembled.
- **Git LFS** from day one covers `png webp jpg ogg wav mp3 mp4 webm ogv blend
  kra psd glb fbx zip`. `.env` and `build/` are gitignored, and Godot's `*.import`
  files are committed.

## 4. Project settings

| Setting | Value |
|---|---|
| Viewport | 1920×1080, stretch mode `canvas_items`, aspect `keep` (letterbox) |
| Renderer | `gl_compatibility` for every rendering method, including mobile and web |
| 2D texture filter | Linear. Mipmaps only where a layer is drawn well below its size (§8). |
| Window | An exported desktop game starts in borderless fullscreen, with a windowed option in Settings. The editor, tests, QA runs and the browser start in a window, and so does any run given a window size or mode on the command line (`--resolution`, `--windowed`). |
| Input | Mouse buttons only. Esc (the built-in `ui_cancel`) is an optional extra: it skips the opening and closes pages and close-ups. The mouse does everything. |
| Audio buses | Master → Voice, Music, Ambience, SFX, UI. No bus effects in the design (§7). The bus layout is created in plan 003. |
| Localization | English source. Dialogue Manager exports POT templates when translation starts. |
| Navigation | `navigation/world/map_use_async_iterations` and `region_use_async_iterations` are off. With the 4.7 defaults (on), a fresh room's walk area only becomes usable about 10 physics frames after it loads, and era switches would lag. Our walk areas are tiny, so synchronous updates are cheap. |
| VRAM compression | `import_etc2_astc` is on, because the universal macOS export refuses to build without it. 2D art still uses lossy or lossless compression (§8). |
| Dev window | 1600×900 window override for development runs. Release builds start fullscreen once Settings exists (plan 004). |

## 5. Adventure core (`src/core`)

The core is small, code-first and tested. It is built around eras, cinematics
and voice from day one. Godot does the heavy lifting: navigation, y-sorting,
`Parallax2D`, `AnimationPlayer`, `Camera2D`. Popochiu (MIT) is a useful
reference for the details. Any code we copy from it keeps its license header
and is listed in `docs/third-party.md`.

### 5.1 Rooms

Each room is one scene in `content/rooms/<room_id>/`. Its script extends
`Room`.

```
Room
  Layers/        Now/, Then/     # Parallax2D and Sprite2D layers, grouped by era
  WalkAreas/     Now, Then       # NavigationRegion2D per era; one is active
  ScaleZones/                    # far and near lines (y, scale); linear in between
  Hotspots/                      # Hotspot = Area2D + CollisionPolygon2D, tagged with an era
  Exits/                         # Exit hotspots: target room and entry marker
  Markers/                       # entry points and cinematic marks (Marker2D)
  Actors/                        # y-sorted: Unknown, NPCs, occluders with baselines
  Foreground/                    # framing layers above the actors
  Cinematics/                    # this room's AnimationPlayer and CinematicCamera
```

**Hooks:**

| Hook | When |
|---|---|
| `_on_enter(from)` | Loaded but not yet shown |
| `_on_shown()` | Visible |
| `_on_exit()` | Leaving the room |
| `_on_restore()` | After a save is loaded |

A room's state is a dictionary kept in `GameState`.

**The `Rooms` autoload:** `await Rooms.goto(&"cathedral_nave", &"west_door", &"fade")`.

1. Loads the room. On desktop this happens on a background thread. On the
   single-threaded browser demo it loads synchronously, so rooms stay light.
2. Places Unknown at the entry marker.
3. Plays the transition.
4. Frees the old room.
5. Autosaves.

### 5.2 Actors

- **`Actor`** (Node2D): `await walk_to(point)` follows a path from
  `NavigationServer2D` on the active walk area.
- **Facing** comes from velocity or from `face(dir)`.
- **Depth scale** comes from the room's ScaleZones.
- **Speech:** `await say(&"LINE_ID")` hands the line to Dialogue Manager (§5.6).
- **Movement can be cancelled** by a new click.
- **Speed:**
  - A body rendered with a ground speed sets the walk speed.
  - `depth_speed` slows vertical motion, which is movement in depth.
  - With `step_with_frames`, the actor moves one frame's worth of ground each
    time a new frame shows, so the planted foot never slides (decision #30).
- **Unknown** is an `Actor` whose presentation is `UnknownBody` (§6.4).

### 5.3 Animation naming

- Names are `<anim>_<dir>`, with `dir` one of `r`, `l`, `u`, `d`, plus `ur`,
  `ul`, `dr` and `dl` if diagonals are rendered.
- A missing `_l` mirrors `_r`, and other missing directions fall back to the
  nearest one rendered.
- Loops (`idle`, `walk`, `talk`) are never awaited.
- One-shots (`pickup_low_r` and so on) end in `animation_finished`, and the
  `Actor` returns to idle. A walk or another one-shot interrupts a one-shot,
  and `await actor.play(...)` returns either way.
- While an actor speaks standing still, it plays its `talk_animations` in turn,
  one per line. Unknown has `talk_a` (right hand) and `talk_b` (both hands).
- An `IdleFidgets` child plays a random fidget after 9–18 s of uninterrupted
  idling, unless input is locked. Unknown's fidgets are `fidget_a` (shifts his
  weight and looks down), `fidget_b` (studies his hand) and `look_around`.

### 5.4 Interaction

The `Interaction` autoload handles all input. These are the controls in
`game-design.md` §8.

- **Hover:** a physics point query finds the topmost `Hotspot` under the cursor,
  which sets the label and the cursor shape.
- **Clicks:**
  - a short click runs the hotspot's default verb;
  - a press held for 300 ms or more opens the verb coin;
  - a double-click on an exit leaves at once;
  - a right-click opens the inventory or drops the held item.
- **Dispatch:**
  1. Unknown walks to the hotspot's `walk_to` marker and faces it.
  2. Then the hotspot's `on_look()`, `on_use()`, `on_talk()` or `on_item(item)`
     runs.
  3. Anything unhandled plays a random dry fallback line for that verb.
- Input is locked while a cutscene or dialogue choice is running. Clicks are
  ignored, not queued.
- Synthetic input events drive the integration tests (§9).

### 5.5 Inventory

- **Items:** an `ItemDef` resource holds an id, a name key, an icon, a look-line
  id and its combinations. `addons/past_tools/new_item.gd` makes them from a
  JSON list, at `content/items/<id>/<id>.tres`.
- **The `Inventory` autoload:** `add`, `remove`, `has`, the `held` item, and
  signals for the UI.
- **The band** (`InventoryPanel`): a left-click picks an item onto the cursor
  and the band stays open. A left-click on another item then combines the two,
  and on the held item puts it back. A left click outside the band closes it
  and uses the held item on whatever is under the cursor. A right-click closes
  it and drops the item.

### 5.6 Dialogue: Dialogue Manager 4

- **Every spoken line** in the game lives in a `.dialogue` file: conversations,
  look lines, barks and fallbacks.
- **Every line carries a static `[ID:SOME_KEY]`.** Our tool fills in missing IDs.
  The ID names the line's voice file and is its translation key (decision #21).
- **Choice trees** use Dialogue Manager's responses and conditions. Options are
  exhausted through `GameState` flags. Mutations call into `GameState`,
  `Inventory` and `Eras`.
- **Our own balloon** (`src/ui/subtitles`) shows the line above the speaker in
  that speaker's color, then passes the line's ID to `Voice` (§6.5).
- Hotspot scripts speak through one wrapper:
  `await Say.line(&"cathedral", &"statue_look")`.
- Plan 004 checks Dialogue Manager's exact API names against the pinned release.

### 5.7 Game state and saves

- **`GameState`** keeps one versioned dictionary:
  - flags and inventory;
  - room states and the current room and entry;
  - eras and memories seen;
  - journal facts and revealed areas;
  - hint progress;
  - dialogue variables.
- **Saves** (the `Saves` autoload, plan 004 slice 6):
  - JSON at `user://saves/slot_<n>.json`, with a 320×180 thumbnail beside it as
    `slot_<n>.png`. Slots 1–6 are manual, and slot 0 is the autosave.
  - A save is `GameState.to_dict()` plus where Unknown is: the room, the entry
    he came in by, his position and the room's era. Loading applies the state,
    then goes to the room and places him while the screen is still black.
  - The autosave is written each time a room is shown. It only runs once
    `main.gd` has started a game, so tests and tools never write one. QA runs
    keep their saves in `user://qa-saves`.
  - Migrations run one step at a time, as `_migrate_from_<n>`, up to
    `GameState.SAVE_VERSION` (now 2). A save from a newer build, or one that
    isn't a save, is refused and the game is left alone.
  - In the browser, `user://` is IndexedDB, and saves survive a page reload.
    The `saves` QA scenario checks this over two `browser-qa.ts` passes.
- **Dialogue variables** are flags. A flag holds a bool, a number or text, which
  is what JSON keeps.
- **Settings** are stored separately (§6.9).

## 6. Custom systems

Each is a small autoload or scene with one job, on top of the core.

### 6.1 Eras and flashbacks — `Eras` and `Flashback` (autoloads)

- **Eras:** an era is `NOW` or `THEN`. A room that has a past carries both eras'
  layers, hotspots and walk areas in one scene.
- **Switching:** `Rooms.current.set_era(THEN)` shows or hides the tagged nodes,
  turns hotspots on or off and activates that era's walk area. The room stays
  loaded at the same coordinates, so Unknown stays where he stood and the then
  and now images line up pixel for pixel.
- **Vision** (cinematic):
  - `await Flashback.vision(&"cathedral_altar")` runs the transition in, a
    cutscene (§6.3), and the transition out.
  - The player cannot act while it runs, and it can be skipped.
- **Playable memory:** `Flashback.enter_memory(...)` switches the era and
  returns when the memory's exit condition fires.
- **Memory vista:** a reveal (§6.3) played in the then era.
- **Separate rooms:** a memory whose geography is too different for an in-room
  switch uses a separate room and a screen-capture crossfade. That is the
  exception.
- **Records:** `Eras` records the memories seen in `GameState`, and the journal
  reads them.

### 6.2 Flashback transition shader

A full-screen `CanvasLayer` effect that runs in both directions.

| Uniform | Purpose |
|---|---|
| `progress` 0→1 | Driven by a Tween or AnimationPlayer |
| `origin` | The anchor's screen position, where the bloom starts |
| `noise` | A tileable noise texture that gives the dissolve front an organic edge |
| `warp` | A small UV ripple near the front |
| `grade_mix` | Cold greyscale to warm, saturated color |
| `flare` | An additive white bloom at the start, scaled by the Reduce flashing setting |

**Approach:**

1. Render the now and then layer groups into two `SubViewport` textures.
2. Composite them with a radial distance from `origin` that is offset by noise.
3. Draw the characters above the composite, so Unknown stays visible while the
   world changes around him.

The browser findings decide this approach (§7): blending two textures is cheaper
than stacking screen reads, screen-texture mipmaps are broken in browser builds,
and particles inside a `CanvasGroup` vanish in WebKit.

### 6.3 Cinematics — `CinematicCamera`, `Reveal`, `Letterbox`, `CutsceneRunner`

- **`CinematicCamera`:** a `Camera2D` that is made current for a shot and gives
  control back to the play camera afterwards. Its paths are authored in an
  `AnimationPlayer`, which also fires audio, title-card and method keys.
- **Zoom stack** (`Reveal`):
  - nested ring textures at scales 1, 2, 4 …;
  - zoom is interpolated in log space, so the perceived speed stays constant;
  - the rings crossfade at their boundaries.
- **Built in plan 002:**
  - `Reveal` (`src/systems/cinematics/reveal.gd`) zooms about one fixed
    point, so the pull-back never seems to pan. It keeps the view inside ring 0
    and fades each inner ring out once the ring outside it shows enough detail.
  - The inner rings ship as one-byte grey, and `ring_feather.gdshader` fades
    their edges.
  - `Letterbox` draws the bars.
  - The cemetery opening (`content/cutscenes/cemetery_reveal`) plays from
    `main.gd` before the first room. Holding the Skip button, or Esc,
    fast-forwards it (plan 004 slice 10).
- **Panorama pan:** `Parallax2D` layers move at different rates.
- **Letterbox:** 2.39:1 bars slide in for every non-interactive sequence.
- **`CutsceneRunner`** (plan 005):
  - A cutscene is a script whose `run(c)` awaits steps: `c.walk`, `c.say`,
    `c.wait`, `c.anim`, `c.shot` and `c.fade`.
  - **Skipping fast-forwards:**
    - every later step finishes instantly: walks teleport, lines stop,
      animations seek to their end, tweens complete;
    - the script's own logic still runs.

    So a skipped scene leaves the world exactly as a watched one does.
  - **Skip control:** a Skip button appears when the mouse moves and fires after
    a 0.6 s hold. Esc also skips.
  - **Rewatching:** every cutscene is registered for rewatching in the journal.
  - **Reduce camera motion** shortens the moves or replaces them with
    crossfades.

### 6.4 Unknown's presentation — `UnknownBody`

Built in plan 002:
- `CharacterSprites` holds the frames and per-frame anchors.
- `SpriteBody` plays them; it lives in `src/core` and serves any rendered
  character.
- `UnknownBody` and `Tendrils` live in `src/systems/unknown`.
- The shaders are `silhouette.gdshader` and `smoke_tendril.gdshader`.
- Until plan 003's `Voice` exists, a stand-in flicker drives the voice level
  while he speaks.

- **Sprites:**
  - Sheets are rendered from Blender. A tool script builds an
    `AnimatedSprite2D` `SpriteFrames` resource from the render metadata, with
    one animation per name and direction. The same metadata carries per-frame
    events, such as footsteps and the moment of a grab.
  - Events are keyed in `EVENTS` in `tools/blender/unknown.py` and land on the
    nearest rendered frame. `SpriteBody.animation_event` fires once each time
    such a frame shows. The walk has a `step` on each heel strike, and the
    pickups (`pickup_low`, `pickup_high`) have a `grab` when the hand closes.
  - A per-frame anchor table, exported with the renders, places his eyes,
    tendrils and held items.
  - Anchors are mirrored when he faces left.
  - **Held items:** `SpriteBody.hold(texture, hand)` keeps an item at a hand
    anchor frame by frame. The item draws in front of him, or behind him when
    he faces away, until `release()`.
- **Eyes:** two additive sprites at the eye anchors, with idle, blink, narrow,
  wide and flare states. Their intensity follows the voice envelope while he
  speaks (§6.5).
- **Tendrils:** a dozen `Line2D` verlet chains rooted down the shoulder and
  back anchors, drawn as thin translucent wisps after the IMG-0003 concept.
  - Forces: trailing from velocity, idle drift from noise, an `agitation`
    parameter for emotion, and a pulse from the voice envelope.
  - A shader thins the edges into smoke, and `CPUParticles2D` adds fine wisps.
- **Rim light:** a light edge around the silhouette. It brightens over dark
  backgrounds so he stays readable.

### 6.5 Voice and subtitles — `Voice` (autoload)

- **Playback:** when the balloon shows a line, it calls `Voice.play(line_id,
  speaker)`.
  - `Voice` loads `assets/audio/voice/en/<ID>.ogg` on demand. Cutscenes preload
    their next lines.
  - The line plays on the Voice bus, and the subtitle stays up until the audio
    ends. A click skips.
- **Browser demo:** voice players use `playback_type = Stream` (§7).
- **Envelopes:** about 30 loudness values per second, computed offline and stored
  per chapter in one table (ID → values). They drive Unknown's eyes and smoke,
  and they can drive any NPC. Computing them offline gives the same result on
  every platform, with no runtime analysis.
- **Missing audio** falls back to text timing and shows up in content lint.

### 6.6 Interface (plan 004)

The verb coin, inventory, top-edge bar (Journal, Save, Load, Settings, Reveal
hotspots, Quit), hotspot reveal markers and the hint on Unknown all sit on
`Interaction` (§5.4) and `Inventory` (§5.5). We own the input, so the coin needs
no workaround. Plan 004 tunes the hold threshold and the coin's feel with the
operator.

- **Top bar and pages** (plan 004 slice 8): the `Menus` autoload (`src/ui`).
  - **The bar:** `TopBar` slides down when the cursor pushes against the top
    edge, but only while the player is free to act: a room showing, input
    unlocked, no coin or inventory open. It slides away once the cursor
    leaves. The browser build has no Quit.
  - **Pages:** each is a `MenuScreen` over the paused game. Esc, a right-click
    or ‹ closes it.
    - `SlotsScreen` saves and loads, with each slot's thumbnail. Saving over a
      used slot takes a second click. The thumbnail is the game as it was
      before the bar opened.
    - `SettingsScreen` covers §6.9: sliders for the volumes, and a click to
      cycle each choice.
    - The journal is a placeholder until plan 005.
  - **Reveal hotspots:** `HotspotReveal` marks everything usable in the room
    or the open close-up for 2.6 s. Hotspots get a ring, exits their arrow,
    and each shows its name.
  - **QA runs** switch the bar off, so a stray cursor can't bring it into a
    recording.
- **Hint on Unknown** (plan 004 slice 9): the `Hints` autoload
  (`src/systems`).
  - **Clicking Unknown** asks him; it hits the trimmed box of his current
    frame. Hovering him shows his name and the ring cursor.
  - **The goal** is the first one in `content/hints/goals.gd` whose flag isn't
    set or whose memory isn't seen yet.
  - **The lines** are the cues `<goal>_1`, `<goal>_2` … in
    `content/dialogue/hints.dialogue`. Each ask about the same goal moves one
    step more direct, counted in `GameState.hints`, and the last line repeats.
  - **`none`** plays once every goal is done.

### 6.7 Journal (plan 005)

- One page per memory, with a still from its flashback and one voiced line.
- The *Who am I?* page is built from facts in `GameState`.
- A rewatch list of the cutscenes registered by `CutsceneRunner`.

### 6.8 Saves

See §5.7.

### 6.9 Settings

- One `Settings` autoload (plan 004 slice 7) keeps them in
  `user://settings.cfg`, apart from saves. Each applies as soon as it is set:
  - **Volumes** for voice, music, ambience and effects drive the Voice, Music,
    Ambience and SFX buses. They are applied again whenever the bus layout
    changes, so plan 003's buses pick them up.
  - **Subtitles and text:** subtitles on or off, their size, and text speed
    (how long a line without voice stays up). `Say` reads them per line.
  - **Reduce flashing** sets `Flashback.reduce_flashing`.
  - **Reduce camera motion:** the opening's pull-back becomes one crossfade to
    the vista, a vision no longer drifts, and close-ups crossfade in without
    the push.
  - **Fullscreen.** A browser only goes fullscreen from a click, so it isn't
    applied at start-up there.
  - **Render at 1080p:** the game draws at 1920×1080 and scales to the window
    (the `viewport` stretch mode), instead of drawing at the window's
    resolution. Godot has no 2D render scale for the root viewport. Going
    below 1080p would mean drawing the game into a SubViewport, which isn't
    worth it while the browser holds 60 fps at 4K.
- Tests (a GUT pre-run hook) and QA runs use their own settings file, at the
  defaults.

### 6.10 Pre-rendered video (later, optional)

Only built if a video cutscene is approved.

- **Desktop:** `VideoStreamPlayer` with Theora `.ogv`, at most 1080p30.
- **Browser demo:** an HTML `<video>` element over the canvas.
  - The file is MP4 (H.264 + AAC), because browsers do not play `.ogv`.
  - It is driven through `JavaScriptBridge`. The "ended" callback must be kept
    referenced.
  - Playback starts from a click, which satisfies the browsers' autoplay rules.
- Feature tags pick the asset for each platform.

### 6.11 Content packs

Not needed. The browser gets only the prologue demo, so it fits in one `.pck`
(decision #20).

### 6.12 Close-ups — `Closeup`, `Closeups` (plan 007)

- **What:** a full-screen picture of something seen closer, such as Unknown's
  gravestone, with hotspots of its own. A close-up lives in
  `content/closeups/<id>/`: a `Closeup` root, a 1920×1080 `Background` and
  `Hotspots`. Its script answers verbs as `<verb>_<id>()`, as a room's does.
- **Opening:** a room's verb calls `Closeups.open(id, hotspot)`, or
  `open_node()` with a scene it preloaded so the image loads under the room's
  fade, not on the click. The push takes 0.9 s, eased:
  - a frame with the screen's shape is fitted round the hotspot and kept inside
    the room;
  - a camera added to the room zooms until that frame fills the screen. The zoom
    grows evenly to the eye while the frame's centre glides to the screen's
    centre;
  - the close-up stays pinned over the frame and fades in, with soft edges from
    `ring_feather.gdshader` that sharpen as it lands.
- **Closing:** the same move reversed, from a right-click, Esc or the ‹ glyph.
  The camera is removed and the room is as it was.
- **While open:** `Interaction` sends clicks and hover to the close-up's
  hotspots in screen pixels. Nothing walks, and verbs run at once. `Say` speaks
  from below the picture. The room keeps running behind it.

## 7. Browser demo specifics

- **Audio:** the browser's default "Sample" playback has three problems:
  - it cannot run bus effects;
  - it decodes a whole clip on the main thread the first time it plays, which
    freezes the game on long clips;
  - it never frees decoded audio, about 350–384 KB per second of audio played.

  So:
  - voice and music players use `playback_type = Stream`;
  - short effects stay on Sample and are decoded during loading with
    `AudioServer.register_stream_as_sample()`;
  - nothing depends on bus effects: filtered and reverberant variants are
    rendered offline, and ducking uses volume tweens;
  - Sample mode also ignores pitch in some cases (issues #117022, #123786), so
    footstep variety comes from pre-rendered variants.

  Plan 003 measures Stream latency in the single-threaded build.
- **Loading:**
  - The whole `.pck` downloads before the game starts; 4.7.2 has no streaming.
    A custom HTML shell shows a loading screen in the game's style.
  - The `.wasm` memory cap is 2 GiB, and the demo aims to stay under 1 GiB.
- **Shaders:**
  - Compatibility cannot precompile shaders. Each shader is drawn once during
    loading, so a transition never stutters the first time it runs.
  - One full-screen pass handles grade, vignette and grain.
- **Avoid in WebKit:** `clip_children` and particles inside a `CanvasGroup`.
- **Saves:** `user://` lives in the browser's IndexedDB, so clearing site data
  deletes them. The demo's menu says so.

## 8. Import settings

- **Backgrounds and layers:**
  - Lossy (WebP), with quality tuned in plan 002 against artifacts in the fog
    gradients.
  - No VRAM compression for 2D.
  - Mipmaps only for layers drawn below about 60% scale, such as zoom-stack
    rings and vista layers.
- **Maximum texture size:** 4096 px per side. Larger panoramas are split into
  tiles.
- **Memory reference:** a full-screen 1920×1080 RGBA8 layer uses 7.9 MiB of
  video memory, and a 4096² texture uses 64 MiB (85 MiB with mipmaps).
- **Unknown's frames:** grey + alpha (LA8, two bytes per pixel). The grey is
  the render's lit skin, which a shader pushes darker and gives its smoke
  edges; there is no colour to store, because he is monochrome. Frames are
  trimmed to the silhouette with a border for the haze, and packed one sheet
  per animation. His loaded frames are budgeted at 128 MiB or less. The flat
  one-byte masks of decision #30 are replaced by decision #32.
- **Audio:**
  - Ogg Vorbis everywhere; Godot decodes it itself in every build.
  - Voice is mono at 22.05–24 kHz. Music is stereo.
  - No WAV in builds.

## 9. Testing and QA

- **Unit tests:** GUT 9.7.1, in `test/`, run headless
  (`$GODOT_BIN --headless -s addons/gut/gut_cmdln.gd -gdir=res://test -gexit`).
  They cover:
  - path following, facing and the animation fallbacks;
  - ScaleZones;
  - verb dispatch and fallbacks;
  - inventory combinations;
  - the `Eras` state machine;
  - `GameState` save, load and migrations;
  - cutscene fast-forward;
  - mapping voice IDs to files.
- **Integration tests:** load a room headless, drive `Interaction` with synthetic
  input events, and assert the results, such as "use the key on the door, and
  the room changes".
- **Content lint** (`addons/past_tools/lint.gd`, run headless):
  - every dialogue line has an ID, audio and an envelope;
  - every hotspot answers Look;
  - every room has an active walk area and entry markers;
  - no asset is orphaned.
- **Import pass:** `$GODOT_BIN --headless --import` after asset changes, which
  surfaces broken resources.
- **Tool tests:** `bun test` for `tools/audio` and `pytest` for `tools/art`.
- **One command:** `tools/test.sh` runs the import pass, GUT and content lint,
  and writes its logs to `build/test-logs/`.
- **Build checks:**
  - **Desktop:** `tools/build/export.sh macos`, then run
    `build/macos/Past.app/Contents/MacOS/Past -- --qa=sandbox_smoke --qa-out=<dir>`.
    The `Qa` autoload plays a scripted sequence, saves screenshots, prints PASS
    or FAIL lines and sets the exit code. Without `--qa` it does nothing.
  - **Browser:**
    1. Run `tools/build/export.sh web`, then `bun tools/build/serve.ts`.
    2. Open the page in Chrome and check the console for errors.
    3. The automation tab reports `document.hidden`, so Godot only advances
       when a screenshot forces a frame. Take a burst of small screenshots to
       let a walk or a line play out.
    4. For timings, `bun tools/build/browser-qa.ts <scenario>` runs a scenario
       in a visible Chrome window with a throwaway profile. It passes
       `?qa=<scenario>` in the URL and prints the `[qa]` lines, console errors,
       uncaught exceptions and page crashes. macOS counts a covered window as
       hidden, and Chrome would then stop the game's frames, so the tool starts
       Chrome with its backgrounding switched off.
  - **Scenarios for measuring and recording:**
    - `grave` checks the start (plan 007): the arrival line, the gravestone's
      close-up and its lines, and the exits both ways, with screenshots;
    - `grave_clip` plays the start for `--write-movie`: the opening, the
      arrival, the stone up close, and back out;
    - `saves` saves, changes room and loads back; with `qa-pass=2` (the
      second `browser-qa.ts` pass) it checks that the save outlived the
      reload;
    - `reduced_motion` plays the opening and the gravestone's close-up with
      Reduce camera motion on;
    - `menus` shoots the top bar, Reveal hotspots and each page;
    - `skip` holds the Skip button during the opening and checks that it
      fast-forwards to the grave;
    - `greybox` plays the greybox puzzle chain to the end
      (`content/greybox/playthrough.gd`, which the GUT test also runs);
    - `perf` prints frame times and memory;
    - `banding` captures the fog with grain on and off;
    - `tour` plays the slice for `--write-movie`. Godot's movie writer takes
      the window size from the project override, so put a temporary
      `override.cfg` with `window/size/window_*_override` set to 1920×1080 in
      the project root while recording, and delete it afterwards.

  Evidence goes in `docs/qa/<plan>/`.
  - A scenario that times out names the step it was on (`_mark` in
    `src/core/qa.gd`).
- **Known noise:** headless test runs and the desktop app print "resources still
  in use at exit" or "ObjectDB instances leaked" when they quit. This doesn't
  affect behaviour; plan 004 investigates it with `--verbose`. With `--verbose`,
  the leftovers are Dialogue Manager's script and the last dialogue file it ran.
- **Profiling:** Godot's monitors (FPS, draw calls, video memory) in debug builds,
  and Chrome's performance panel for the demo.

## 10. Budgets

| Metric | Desktop (full game) | Browser demo |
|---|---|---|
| Frame rate at 1080p | 60 fps on the operator's M4 and on a 2020-era integrated GPU | 60 fps in Chrome on the operator's Mac |
| Video memory per room | 400 MiB or less, both eras plus characters | Same |
| Room load | 1 s or less | 2 s or less (no threads) |
| Download | No hard cap; aim for 4 GB or less | `.pck` of 150 MB or less, plus about 10 MB of engine (gzip) |
| Peak memory | — | 1 GiB or less of the 2 GiB cap |
| Render resolution | Window resolution | The browser canvas follows the device pixel ratio. Plan 002 measured 60 fps even at 4276×2407 on the operator's M4, so it is not capped. For weaker GPUs, the Render at 1080p setting (§6.9) caps it. |
| Voice | Ogg mono, about 48–64 kbps | Same |

## 11. Risks

| Risk | Mitigation |
|---|---|
| Our own adventure core costs time and can have bugs | Keep it small, lean on Godot's built-ins, test it with GUT, and borrow Popochiu's patterns |
| Dialogue Manager is one maintainer's add-on | Pin and vendor it (MIT). Its files are plain text, so in the worst case we parse the subset we use ourselves. |
| Stream audio latency or crackle in the single-threaded browser demo | Measure in plan 003. Try MP3, which uses less CPU. A threaded build is the last resort, because itch's cross-origin option breaks other things. |
| 8-bit banding in fog gradients | Grain and dithering. Judged in plan 002. Forward+ for desktop only as the fallback (§2). |
| Safari / WebKit quirks | Best effort. Avoid the known bad patterns (§7). |
| macOS notarization needs a paid Apple Developer account | Operator decision before the first public desktop build |
| Repository size: art masters, audio masters, renders | LFS from day one. Check the GitHub LFS quota before the first push, and keep bulky intermediates out of git. |
