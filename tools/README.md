# tools

Command-line tools that run outside Godot. Godot ignores this folder
(`.gdignore`). Scripts that Godot itself runs live in `addons/past_tools/`.

## Environment

| Variable | Used by | Default |
|---|---|---|
| `GODOT_BIN` | `godot.sh` and everything that calls Godot | `$HOME/Applications/Godot-4.7.2.app/Contents/MacOS/Godot` |
| `ELEVENLABS_API_KEY` | `audio/` (plan 003) | none |

The operator puts secrets in `.env` at the repository root, which is gitignored.
Agents never write, print or commit `.env`.

## Layout

| Path | What |
|---|---|
| `godot.sh` | Runs the pinned Godot with any arguments |
| `test.sh` | Headless import, GUT tests and content lint. Exits non-zero on failure. |
| `build/` | Export and local-serve scripts for the desktop and browser builds |
| `art/` | Image processing (Python, `uv`), from plan 002 |
| `audio/` | ElevenLabs pipeline (Bun + TypeScript), from plan 003 |
| `blender/` | Character build, rig, keyframe and render scripts, from plan 002 |
