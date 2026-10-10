# tools

Command-line tools that run outside Godot. Godot ignores this folder
(`.gdignore`). Scripts that Godot itself runs live in `addons/past_tools/`.

## Environment

| Variable | Used by | Default |
|---|---|---|
| `GODOT_BIN` | `godot.sh` and everything that calls Godot | `$HOME/Applications/Godot-4.7.2.app/Contents/MacOS/Godot` |
| `AI_GATEWAY_API_KEY` or `VERCEL_OIDC_TOKEN` | `images/` (decisions #25, #27) | none. The AI SDK uses the key when set, otherwise the OIDC token. |
| `ELEVENLABS_API_KEY` | `audio/` (plan 003) | none |

The operator puts secrets in `.env` at the repository root, which is gitignored.
Bun loads it automatically. Agents never write, print or commit `.env`.

## Layout

| Path | What |
|---|---|
| `godot.sh` | Runs the pinned Godot with any arguments |
| `test.sh` | Headless import, GUT tests and content lint. Exits non-zero on failure. |
| `build/` | Export and local-serve scripts for the desktop and browser builds |
| `images/` | Image generation through the Vercel AI Gateway (Bun + TypeScript): runs request files, writes receipts, enforces budgets |
| `art/` | Image processing (Python, `uv`), from plan 002 |
| `audio/` | ElevenLabs pipeline (Bun + TypeScript), from plan 003 |
| `blender/` | Character build, rig, keyframe and render scripts, from plan 002 |

## Gateway credentials

The tools use the Videorc Vercel project's OIDC token (decision #27). It lasts
12 hours, and `bun tools/images/check.ts` shows when it expires. To refresh it,
from the repository root:

```
(cd ~/projects/videorcweb && vercel env pull "$TMPDIR/vrc.env" --environment=production --yes >/dev/null 2>&1 && grep '^VERCEL_OIDC_TOKEN=' "$TMPDIR/vrc.env" >> ~/projects/past/.env; rm -f "$TMPDIR/vrc.env")
```

Delete the old `VERCEL_OIDC_TOKEN` line from `.env` first, because a duplicate
key is ambiguous. The empty `AI_GATEWAY_API_KEY=""` line that is already there
is harmless: an empty key falls through to the OIDC token. A dedicated
`AI_GATEWAY_API_KEY` for Past would remove the expiry.

