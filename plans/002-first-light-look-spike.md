# 002 — First light: prove the look of *Past*

Status: planned 2026-10-09, updated 2026-10-10. Owner: Claude, who also
generates the images with `tools/images` through the Vercel AI Gateway (decision
#25). The image budget is $50 (#26). The operator approves the style keys,
Unknown's model sheet and the final look gate.

## Goal

Show in the **browser build** that GPT Image output, processed by Claude, can
produce the look of *Past* at a cost we can sustain. One room, the cathedral nave, is
built as a living painting with now and then layers. Unknown is animated. A
memory anchor plays the flashback, and a pull-back reveal opens the area. This
is the riskiest part of the project, so it comes first.

## Depends on

- Plan 001 is done: project, adventure-core skeleton, desktop and browser
  builds, test runner.
- `AI_GATEWAY_API_KEY` is in `.env`. The operator copies it from Videorc.
- Already settled:
  - "memory is color" is confirmed (decision #24);
  - Claude keyframes Unknown's motion (#23);
  - the image budget is $50 (#26).

## Not in this plan

The verb coin, inventory and dialogue (plan 004). Voice and music (plan 003; use
silence or rough placeholder sounds here). A general cutscene runner (plan 005;
the reveal and the flashback here are hard-coded sequences that plan 005 later
generalises).

## Slices

### Slice 1 — Image tool and first batch

1. Build `tools/images` (Bun + TypeScript, AI SDK 7, Vercel AI Gateway):
   - **`run.ts <ID>`:**
     - parses a request's Generation and Prompt blocks;
     - calls `generateImage`, as text-to-image or as an edit with references and
       a mask;
     - writes the variants and `receipt.json` to `art-source/raw/<ID>/`;
     - appends the ledger, fills the Delivery row and sets the status;
     - refuses to run once the plan's spend reaches 80% of its budget.
   - **`check.ts`:** confirms the key works without spending.
   - **`budget.ts`:** reports spend per plan.
   - **Tests:** `bun test` covers parsing, the ledger and the budget guard with
     a mock model, with no network.
2. **A/B:** run the cathedral nave (now) request on `gpt-image-2.5-flare` and on
   `gpt-image-2.5-sunburst` at medium quality. Choose the default model for new
   images by look, and record the cost per image.
3. Write the remaining requests from `art-source/requests/_TEMPLATE.md`, using
   the composition rules in `docs/art-pipeline.md` §3.

| Request | What | Approval |
|---|---|---|
| Unknown model sheet | Front, side, back, three-quarter front and back; A-pose; one set with tendrils and one without | Operator |
| Cathedral nave, now | Playable version of concept 02: no characters, walkable floor in the lower ~35% against pale fog, exits left and right, a clear memory anchor such as the fallen statue | Operator (area style key) |
| Cathedral nave, then | An edit of the accepted now image, in the spirit of concept 05 | Operator |
| Clean plates | The now and then images with each planned occluder removed (columns, pew ends) | — |
| Reveal rings | Concept 01 without the figure, used as the outermost ring, plus repaints of its centre path at ×2 and ×4 detail | Operator (vista look) |

Rings may also be made by outpainting outward from a close image. The `align`
tool registers either kind.

### Slice 2 — Art tools (`tools/art`, uv, Python 3.12)

Build `upscale`, `align`, `depth`, `layers`, `grade` and `sheet`
(`docs/art-pipeline.md` §7). Each gets a CLI and a smoke test on the concepts.

- **`align`:** port the planning-pass proof, which scored the concept pair at a
  0.7 px median and 2.1 px p90 residual.
- **`upscale`:** run 2–3 candidate models side by side on concept 02, put the
  results on a contact sheet, pick the winner and record why.

### Slice 3 — The cathedral room

1. Process the accepted images: upscale, align, depth, layers, grade, clean
   plates.
2. Scaffold the room `cathedral_nave` with `new_room.gd` (`technical-plan.md`
   §5.1) and build it with:
   - the now and then layer groups;
   - a walkable area;
   - scaling calibrated so Unknown's height matches the concept at the near and
     far walk lines;
   - occluders with correct baselines;
   - the memory-anchor hotspot.
3. Add the living-painting effects:
   - **now:** cold light shafts, drifting fog bands, drips, puddle shimmer;
   - **then:** golden shafts, dust motes, banner sway, stained-glass glints.

### Slice 4 — Unknown: 3D silhouette to 2D sprites

Follow `docs/art-pipeline.md` §5C.

1. Build and rig the body in Blender, and keyframe its motion with bpy scripts
   (decision #23). Iterate on rendered contact sheets until the walk reads
   well, then show the operator short looping clips.
2. Render idle, walk and look-around facing right, up and down; left mirrors
   right. Render the walk at both 12 and 15 fps.
3. Export the anchors JSON.
4. In Godot, build Unknown as an `Actor` with:
   - animations named by our convention (`technical-plan.md` §5.3);
   - frames tested as single-channel alpha masks against RGBA, within a budget
     of 128 MiB of video memory (`technical-plan.md` §8);
   - eye glows;
   - verlet smoke tendrils;
   - a rim-light shader.
5. Log the hours for every step. The operator picks 12 or 15 fps from a
   side-by-side capture.

### Slice 5 — Flashback transition

A full-screen shader and controller (`technical-plan.md` §6.2). It runs in two
directions.

**Into the past:**

1. Unknown's eyes flare.
2. A noise-masked dissolve spreads from the anchor point while the aligned then
   layers replace the now layers.
3. A warm grade and vignette fade in.

**Out of the past:** the same sequence in reverse.

The Reduce flashing parameter is wired up. In this plan the vision holds about
8 s, with a slow camera drift, before it returns.

### Slice 6 — Pull-back reveal

1. A zoom-stack node built from the rings.
2. A camera path on an `AnimationPlayer`, using exponential zoom for a constant
   perceived speed.
3. Letterbox bars and a placeholder title card.
4. A handoff into `cathedral_nave`.

### Slice 7 — Measure, record, gate

- **Performance:** frame time at 1080p on the operator's Mac, in the macOS build
  and in a visible Chrome tab. The target is 60 fps in both. Also record the
  browser download size and video memory of this slice.
- **Banding:** judge the fog gradients in the Compatibility renderer with grain
  on and off. Record whether Forward+ for desktop is worth testing
  (`technical-plan.md` §2).
- **Cost:** for each asset type (room now/then, ring, each Unknown animation),
  the hours spent and the generation rounds and dollars per accepted image. The
  ledger has the dollars. These numbers go to the operator and later into the
  M5 estimate.
- **Record:** a screen recording of the full slice, in `docs/qa/002/`.
- **Gate:**
  - The operator approves the look and Unknown's animation route.
  - Update decisions #5 and #17.
  - Mark this plan DONE.
  - Write plan 004.

## STOP conditions

- Unknown's design drifts between views after three generation rounds. Stop and
  give the operator options: a rough sketch from them, another gateway image
  model, or modeling straight from concept 04.
- Image spend reaches 80% of the $50 budget. The tool refuses to go on; stop and
  report.
- Then/now alignment stays above a 3 px p90 after two revise rounds. Stop and
  test whether a manual mesh-warp correction is acceptable.
- The browser build drops below 45 fps with the full effect stack. Stop and
  profile before adding more effects.
- Anything outside the image budget costs money, such as a paid upscaler. Get
  the operator's approval first.

## Definition of done

- In the browser build, Unknown walks around the living nave. Clicking the
  anchor plays the flashback in and out, and the reveal plays from the
  cemetery into the nave.
- The tools have smoke tests, and the time and cost log is filled in.
- The operator has signed the look gate.

## Effort

About 4–6 working sessions, plus the operator's approval rounds for the style
keys. Slices 2 and 4 can start before slice 1's images exist, using the concepts
as stand-ins.

## Execution record

(empty)
