# 001 — Foundations: repo, pinned engine, adventure-core skeleton, desktop and browser builds, tests

Status: planned 2026-10-09. Owner: Claude. The operator authorizes commits and
pushes for this plan.

## Goal

A reproducible Godot 4.7.2 project in `~/projects/past`. It runs headless tests,
exports a macOS build and a browser build, and contains the walking skeleton of
our own adventure core (`docs/technical-plan.md` §5). That means a placeholder
room where a placeholder Unknown walks, and one hotspot whose Look line comes
from a Dialogue Manager file. Everything later builds on this.

## Where we stand

- `~/projects/past` holds only this planning pass: docs, plans, the agent board,
  the request template and the reference concepts. It is not a git repository
  yet.
- Popochiu was dropped (decision #19). Dialogue Manager 4 replaces it for
  dialogue, and the rest of the adventure layer is ours.
- Installed: Homebrew, Blender 4.5.13, ffmpeg, ImageMagick, git-lfs, uv, Bun,
  Node, Python 3.14, gh and the Codex CLI.
- Not installed: Godot and its export templates.
- About 100 GB of disk is free. The machine is an Apple M4 with 32 GB of RAM.

## Slices

### Slice 0 — Repository

1. `git init -b main` and `git lfs install --local`.
2. Add `.gitattributes` with the LFS patterns in `technical-plan.md` §3.
3. Add `.gitignore`: `.godot/`, `build/`, `.env`, `node_modules/`, `.venv/`,
   `__pycache__/`, `.DS_Store`. Godot's `*.import` files are committed.
4. Document the environment variables (`GODOT_BIN`, `ELEVENLABS_API_KEY`) in
   `tools/README.md`. Agents may not write `.env*` files; the operator creates
   `.env` by hand.
5. Add `origin` = `https://github.com/TheOrcDev/past` (private, empty on
   2026-10-10; decision #22).
6. Check the GitHub LFS quota for the account, because the concepts alone are
   about 12.6 MB.
7. Commit the planning docs, and push `main` if pushes are authorized. LFS must be
   configured before the first commit, so the PNGs go into LFS.

### Slice 1 — Engine

1. Download the Godot 4.7.2-stable macOS universal build and the 4.7.2 export
   templates from the official release.
2. Check both against the release's SHA-512 checksums.
3. Install the app at `~/Applications/Godot-4.7.2.app` and the templates in
   Godot's `export_templates/4.7.2.stable/` folder.
4. Add `tools/godot.sh`. It runs `$GODOT_BIN`, which defaults to the pinned app
   path.
5. `$GODOT_BIN --version` must print `4.7.2.stable`.

### Slice 2 — Project and add-ons

1. Create `project.godot` (name "Past") with the settings in
   `technical-plan.md` §4.
2. Put a `.gdignore` in `tools/`, `art-source/`, `audio-source/`, `docs/` and
   `plans/`.
3. Add Dialogue Manager 4 from its official release. Pick the newest release
   whose notes support Godot 4.7, record its version and checksum in
   `technical-plan.md` §1, and enable it.
4. Add GUT 9.7.1.
5. `$GODOT_BIN --headless --import` must finish with no errors.

### Slice 3 — Adventure-core walking skeleton

The minimum of `technical-plan.md` §5, built so later plans extend it rather
than replace it:

- `Room` base and `Rooms.goto()` with a fade transition.
- `Actor` with:
  - `walk_to()` along a `NavigationServer2D` path;
  - facing;
  - the `<anim>_<dir>` naming with fallbacks and left mirroring;
  - depth scale from ScaleZones.
- `Hotspot` (Area2D polygon) and `Interaction`:
  - hover label;
  - a left-click on the ground walks;
  - a left-click on a hotspot walks there and then runs `on_look()`.

  The verb coin comes in plan 004.
- `Say.line()`, a placeholder balloon built on Dialogue Manager, and one
  `.dialogue` file containing the statue's look line with a static `[ID:…]`.
- `addons/past_tools/new_room.gd`, which scaffolds a room's folder, scene and
  script through Godot (headless), so resource IDs stay valid.

### Slice 4 — Sandbox content

- **Room `sandbox`** (created with `new_room.gd`):
  - concept 02 scaled to 1920×1080 as a placeholder background;
  - a walk area over the floor;
  - near and far ScaleZones;
  - one hotspot, the fallen statue, which answers Look with the dialogue line.
- **Unknown:** a placeholder black silhouette with two eye dots. `idle` and
  `walk` are faked with a bob in `_r`, `_u` and `_d`, and left mirrors right.

### Slice 5 — Builds and local server

1. Add export presets:
   - **macOS** (universal, ad-hoc signed for now);
   - **Web demo** (single-threaded, which is the default).
2. `tools/build/export.sh macos|web` writes `build/macos/` and `build/web/`.
3. `tools/build/serve.ts` (Bun) serves `build/web/` with `application/wasm` for
   `.wasm` and `application/octet-stream` for `.pck`, and prints the URL.
4. **macOS check:** launch the app, walk, click the statue, and save a screenshot
   to `docs/qa/001/`.
5. **Browser check:** open the build in a visible Chrome tab, do the same, and
   confirm the console has no errors.

### Slice 6 — Tests and lint skeleton

1. GUT unit tests for:
   - the animation-name fallbacks and mirroring;
   - ScaleZones interpolation;
   - one integration test that clicks the statue with synthetic input and
     asserts the line was spoken.
2. `tools/test.sh` runs the headless import and GUT, and exits non-zero on any
   failure.
3. A content-lint stub, `addons/past_tools/lint.gd`, checks:
   - every room has a walk area and an entry marker;
   - every dialogue line has an ID.

### Slice 7 — Close-out

1. Record any deviations from the technical plan in it.
2. Mark this plan DONE in `plans/README.md`.
3. Post on the board.
4. The operator plays the sandbox as the macOS app and in the browser.

## STOP conditions

- A checksum does not match. Stop.
- No Dialogue Manager 4 release runs on Godot 4.7.2. Stop and report the
  options. Never change the pinned Godot version without the operator.
- The browser build will not start in Chrome. Stop and diagnose before adding
  content.

## Definition of done

- `$GODOT_BIN --version` reports 4.7.2.stable. The add-ons are pinned and
  recorded, the headless import is clean, and `tools/test.sh` passes.
- The sandbox plays as a macOS app and in the browser. Unknown walks with depth
  scaling, and clicking the statue makes him walk over and say its line.
- `new_room.gd` creates a room that opens in the editor without errors.

## Effort

M–L: about 1–2 working sessions.

## Execution record

(empty)
