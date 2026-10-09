# Past — Art Pipeline

Status: draft, 2026-10-09. Plan 002 proves this pipeline on one area before any
volume production starts. Numbers marked *calibrate* are set by that plan.

## 1. Who does what

| Role | Does |
|---|---|
| **GPT image agent** | Generates every image from a request file: backgrounds, then/now edits, outpaint zoom-outs, clean plates, character model sheets, UI art, journal illustrations and title cards. It never edits game files. |
| **Claude** | Writes the requests and reviews what comes back. Does all processing (upscale, alignment, depth, layer splitting), the 3D rigging, animation and sprite rendering, effects, Godot integration and QA. |
| **Operator** | Approves style keys, Unknown's model sheet, each area's look and anything marked `operator-approval: required`. |

The request, delivery and review protocol is in `../AGENTS.md`. The template is
`../art-source/requests/_TEMPLATE.md`.

## 2. Style bible

### Present ("now")

- Monochrome greyscale matte painting with an ink-wash texture.
- Heavy volumetric fog separates the depth planes. Far is pale and near is
  black, as in atmospheric perspective.
- Black silhouettes frame the foreground: fences, branches, tombstones,
  rubble.
- Gothic architecture: spires, rose windows, pointed arches, flying buttresses,
  arched bridges, canals.
- Ruin and decay: broken stone, torn banners, dead vines, puddles, wet
  reflective cobbles.
- Light comes from an overcast or moonlit sky, from behind the subject: shafts
  through windows and strong rim light on silhouettes.

### Past ("then")

- The **same composition and camera** as the present image, made as an edit of
  it and never generated from scratch.
- Full saturated color: warm gold sunlight, clean white marble, gold ornament,
  deep blue banners with gold, glowing stained glass, flowers, polished
  reflective floors and visible light rays.
- The key light comes from the same direction as in the present image, so shapes
  still match during the transition.
- Reference pair: `reference/concept-02-cathedral-now.png` ↔
  `reference/concept-05-cathedral-then.png`.

### Unknown

- A lean shadow in the shape of a man: pure black, glowing white eyes, a smooth
  head, and long smoke-like tendrils streaming from his shoulders and back.
- A faint light rim on his outline separates him from dark areas.
- He is small against the architecture. That scale is part of the mood.

### Landmarks

Recurring world landmarks keep the geography readable: the cathedral with its
rose window and twin spire groups, the arched bridges, the moon. Once a landmark
is approved, Claude crops it into `art-source/style/landmarks/`. Later requests
reference that crop so the cathedral looks the same from every vista.

### Always

- Backgrounds contain no characters. Unknown and the NPCs are separate layers.
- No text, signatures, frames or watermarks.
- Present-day images are delivered in greyscale. Any cold tint is applied in the
  engine, so flashback shaders control exactly where color returns.

## 3. Composition rules for playable rooms

These rules go into every room request:

1. The camera is at eye level or slightly above, with the horizon at 40–55% of
   the frame height.
2. A clear walkable floor fills the lower 30–40% of the frame, with exits at the
   left and right edges or as visible doors.
3. **The walkable band sits against mid-to-light fog.** Unknown is black, so the
   darkest values belong in the foreground framing and the top corners, never
   behind his path.
4. Three to six distinct interactive objects, each separated from its
   background by rim light or fog.
5. Foreground occluders such as columns and railings let Unknown walk behind
   them without hiding any hotspot.

## 4. Technical targets

| Item | Target |
|---|---|
| Viewport | 1920×1080, letterboxed to 16:9 |
| Room background | 1920×1080 per screen. A scrolling room is up to 3 screens wide. |
| Cinematic push-ins | 2× source (3840×2160) only where the camera zooms past 1.25× |
| GPT output | Largest size the tool offers. The concepts came out at 1672×941 (16:9) and 2117×743 (wide). |
| Upscaling | Local 2× AI upscale, then downsample to target. This gives a cleaner result than using the raw output. |
| Unknown's height | About 480 px at the nearest walk line, roughly 44% of the screen. *Calibrate:* he is about 32% of the frame in the nave concept. |
| Animation | 12 fps baseline ("on twos"). Plan 002 also tests 15 fps for the walk. |
| Directions | Right, up and down; left mirrors right. Diagonals only if plan 002 shows they are worth their memory. The core supports them (`technical-plan.md` §5.3). |
| Unknown's frames | Plan 002 tests single-channel alpha masks, where a shader adds color and the rim, against RGBA. Budget: 128 MiB of video memory for his loaded frames. |
| Atlases | At most 4096×4096, loaded per room and per character |
| Source format | Lossless PNG in `art-source/`. Godot import settings are in `technical-plan.md`. |

Draw everything at its largest on-screen size and only scale down.

## 5. Pipelines

### A. Rooms (now and then)

1. **Request (Claude):** the room's purpose, composition notes (floor zone,
   exits, hotspots, occluders), style refs and landmark crops. The first room
   of every area is `operator-approval: required` and becomes that area's style
   key.
2. **Generate (GPT):** 3–4 variants go to `art-source/raw/IMG-xxxx/` with a
   receipt.
3. **Pick:** Claude shortlists and the operator approves style keys.
4. **Past version:** Claude requests the then image as an edit of the accepted
   now image ("same composition, camera and perspective; restore …").
5. **Process (Claude)**, writing to `art-source/work/rooms/<room>/`:
   - `upscale` to 2×, then downsample to the target size;
   - `align` the then image to the now image. A p90 residual above 3 px after
     auto-alignment means a revision request. The concept pair measured a median
     of 0.7 px and a p90 of 2.1 px before any correction.
   - `depth`: a depth map for parallax and fog density;
   - `layers`: background plate, walk-behind occluders and foreground framing.
     Holes behind removed occluders are filled with **clean plates**, which are
     GPT edits with the occluder removed;
   - `grade`: enforce monochrome on the now image and check the walkable band's
     luminance.
6. **Assemble (Claude, Godot):** layers, walkable area, scaling regions,
   occluder baselines, hotspots, both era layers, and the "life" effects in E.
7. **QA:** screenshots at 1080p and at maximum camera zoom, then check
   readability and seams. See section 8.

### B. Vistas and discovery reveals

- **Nested zoom stack:** from a framing image, the GPT agent outpaints zoom-outs
  at ×2 and ×4 with the centre kept. `align` registers each ring at scale ≈0.5.
  Claude composites the inner image into the outer one with a feathered mask;
  the fog hides the seams. In the engine, the camera zooms exponentially through
  the stack and crossfades at each ring boundary.
- **Panoramas** for pans are 2.4:1 to 3:1 and split into depth layers for
  parallax. Concept 01 shows the format.
- **Past vistas** are edits of the present vistas, aligned like rooms.

### C. Unknown: a 3D silhouette rendered to 2D

This is the primary route, and plan 002 accepts or rejects it. A silhouette with
no face hides that it was rendered from 3D. The renders give consistent turns,
any number of animations and exact per-frame anchor data. Blender 4.5 LTS is
installed.

1. **Model sheet (GPT):** front, side, back, three-quarter front and
   three-quarter back, A-pose, plain light background. One version with
   tendrils for reference and one without, used for modeling. Requires operator
   approval.
2. **Body (Claude, Blender):** a lean humanoid built from a CC0 base mesh,
   reshaped to match the sheet, with a Rigify or equivalent rig.
3. **Motion:** keyframed by Claude in Blender with bpy scripts (decision #23).
   The walk starts from the classic contact, down, passing and up poses. There
   are also idle breathing and a look-around. Claude checks each loop on
   rendered contact sheets, and the operator reviews it as a short looping
   clip.
4. **Render:** orthographic camera tilted about 10° down. Black body with a
   backlit rim light, alpha PNG at the target height and frame rate, for every
   animation and direction.
5. **Anchors:** a per-frame JSON with head, both eyes, both shoulders, upper
   back, both hands and the foot baseline.
6. **Godot:** sprite sheets of at most 4096², with SpriteFrames per animation
   and direction. Anchors drive three things:
   - **Eyes:** additive glow sprites with blink, flare and narrow states, and
     intensity driven by the voice envelope;
   - **Tendrils:** procedural verlet chains (`Line2D`) with a noise shader and a
     few smoke particles. They trail behind motion, drift when idle, become
     agitated with emotion and pulse with speech;
   - **Held items:** attached at the hand anchors.

**Minimum animation set:**

- idle plus 2 fidgets;
- walk;
- talk (2 gesture loops, no mouth);
- pick up (high and low);
- use / reach;
- give;
- look around;
- flashback flare;
- one-off gags as the story needs them.

Every animation's production time is logged, as the handoff asked.

**Fallback:** a 2D cut-out rig in Godot (`Skeleton2D`) built from GPT part
sheets with one view per direction.

### D. Other characters and memory figures

- **NPCs** use the same route. They are designed to read by outline: hats,
  cloaks, tools, posture.
- **Memory figures** in flashbacks (proposal in `game-design.md` §6) use the
  same rigs with a warm emissive material, a soft glow sprite and dust
  particles.

### E. Living-painting effects (Claude, procedural)

- **Fog:** tileable noise textures baked by a Claude tool, scrolling at
  different speeds per depth band, with density taken from the depth map.
- **Light shafts:** additive gradient shapes with a slow flicker.
- **Particles** (`CPUParticles2D`): ash, rain, embers, dust motes (past) and crow
  flocks.
- **Water:** a reflection and ripple distortion shader.
- **Cloth:** a vertex wave shader on banners cut into their own layer.
- **Flashback transition:** a noise-masked radial dissolve between the aligned
  era layers, with a flare. See `technical-plan.md`.

### F. UI art and fonts

- **GPT:**
  - verb coin glyphs (eye, hand, speech wisp) on a smoke ring;
  - a cursor set (default, hotspot, exits, held item);
  - inventory and journal art;
  - title card frames;
  - the main menu and the **Past** logo.
- **Fonts:** open-licensed (OFL) only. A gothic serif for titles and a very
  readable face for subtitles, chosen in M3 after a readability test at
  1080p.

### G. Video (later, optional)

Cutscenes are made in the engine first. A pre-rendered video is used only where
the engine cannot deliver, for example an intro or an ending. Which video tool to
use, and who runs it, is decided when the need appears.

## 6. Folder layout and naming

```
art-source/            # never imported by Godot (.gdignore)
  requests/            # one file per image request; Claude writes, GPT fills delivery
  raw/IMG-0001/        # GPT output — immutable — IMG-0001-v1.png …, receipt.md
  work/                # Claude: upscales, masks, depth, layers, .blend files, renders
  style/               # operator-approved style keys and landmark crops
docs/reference/        # the operator's original concepts
```

- Requests use sequential IDs, `IMG-0001-<kebab-slug>.md`.
- Rooms use `snake_case` ids such as `cathedral_nave`.
- Era suffixes are `_now` and `_then`. Layer suffixes are `_bg`, `_mid`, `_fg`,
  `_occ` and `_depth`.
- Shipping assets live in the Godot project (`technical-plan.md` §3).
- Every raw image keeps its receipt with the prompt, model, size and date. Those
  receipts back any AI-content disclosure a store requires and allow an image to
  be regenerated.

## 7. Art tools Claude builds

Python tools are managed with `uv` on a pinned Python 3.12, because the system
Python is 3.14 and too new for parts of the ML stack. They live in
`tools/art/`.

| Tool | Job |
|---|---|
| `upscale` | 2× AI upscale. Real-ESRGAN-class model on Apple MPS, tiled. The model is chosen in plan 002. |
| `align` | SIFT + RANSAC registration with a residual report. Proven on the concept pair. |
| `depth` | Depth map from a Depth-Anything-class model on MPS |
| `layers` | Depth bands and masks to layered PNGs with alpha |
| `grade` | Enforce monochrome and check walkable-band luminance |
| `sheet` | Contact sheets for review on the board |
| `pack` | Sprite atlases and Godot SpriteFrames from render folders |
| `tools/blender/*` | Build, rig, render and export anchors for characters (bpy, headless) |

## 8. Quality gates

1. The operator approves each area's style key before more than three of its
   rooms are generated.
2. Then/now alignment has a p90 of at most 3 px after auto-alignment.
3. Unknown stays readable everywhere on the walkable area. The `grade` check
   passes and a screenshot at the darkest spot is reviewed.
4. Hotspots can be found with labels off. Checked in playtests.
5. No visible seams in layers or zoom stacks at 1080p or at maximum zoom.
6. Download size and performance stay inside the budgets in
   `technical-plan.md`.
