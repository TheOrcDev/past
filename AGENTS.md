# Past — agent instructions

Past is a mouse-only, fully voiced point-and-click adventure. It is built in
Godot 4.7 with GDScript, using our own small adventure core and Dialogue Manager
4 for dialogue. Unknown, a shadow with no memory, searches a ruined gothic city
for who he was, and flashbacks show places as they used to be. The full game
ships on desktop, and the prologue also runs in the browser as a demo.

Start with `docs/game-design.md`, `docs/roadmap.md` and `plans/README.md`. The
decision log is `docs/decisions.md`. The pipelines are `docs/art-pipeline.md`,
`docs/audio-pipeline.md` and `docs/technical-plan.md`.

The repository is `github.com/TheOrcDev/past` (private).

| Who | Role |
|---|---|
| **Claude Code** | Everything: code, scenes, tools, image generation (GPT Image through the Vercel AI Gateway) and processing, rigging and animation, audio generation, docs and plans |
| **Operator** (OrcDev) | Decides story, art direction, spend and gates. Approves style keys. |

## Image requests

Images are made with `tools/images` (decision #25). Each image has a request
file, so every picture in the game can be traced to its prompt.

1. Copy `art-source/requests/_TEMPLATE.md` to
   `art-source/requests/IMG-####-<slug>.md`. Fill in its purpose, its
   generation block (model, size, quality, number of variants, references,
   mask) and its prompt, and set `status: open`.
2. Run `bun tools/images/run.ts IMG-####`. The tool:
   - writes the variants unmodified to `art-source/raw/IMG-####/`;
   - writes `receipt.json` with the model, prompt, parameters, references,
     token usage and cost;
   - adds a Delivery row and sets `status: delivered`;
   - refuses to spend past the plan's image budget.
3. Review the variants against the acceptance criteria and record the verdict
   in the Review table:
   - `accepted: v2` if one passes;
   - `status: revise` with numbered notes if none do. The next round continues
     the numbering (v4, v5 …).

   A request marked `operator-approval: required` stays `delivered` until the
   operator approves it.
4. Files in `art-source/raw/` are never edited, renamed or deleted. Processing
   writes to `art-source/work/`, and shipping assets go into the Godot project.

## Board

`docs/agent-board.md` holds the open image requests, the open operator
decisions and an append-only log. Read it before starting work and append to it
after finishing a slice. Timestamp entries in UTC.

## Rules

1. **GDScript only.** No C#. No GDExtension unless a plan approves it, because
   the browser demo cannot load most of them.
2. **Compatibility renderer everywhere.** A feature is done when it works in the
   desktop build and in the browser demo build served locally, not only in the
   editor. `docs/technical-plan.md` §7 lists the browser's limits.
3. **Check API names** against the docs or source of the pinned Godot and
   Dialogue Manager releases before writing code. Never write them from memory.
   Pinned versions live in `docs/technical-plan.md`, and they change only
   through a plan. Popochiu is not used.
4. **Create scenes through Godot**, using the scaffolding scripts in
   `addons/past_tools/` or the editor. Never hand-assemble `.tscn` files.
5. **Paid APIs:**
   - ElevenLabs (`tools/audio`) and image generation (`tools/images`) go
     through their tools and caches.
   - Never regenerate an accepted asset without a reason.
   - Stay under the budget the operator set for the plan, and stop at 80% of it
     to report.
6. **Secrets** live in `.env`, which is gitignored, for example
   `AI_GATEWAY_API_KEY` and `ELEVENLABS_API_KEY`. The operator writes that
   file. Never print or commit it.
7. **Shaders:** clamp `pow()` bases to ≥ 0. Apple GPUs return NaN for negative
   bases and the screen goes black.
8. **Browser checks:** the automation tab reports `document.hidden`, so Godot
   only advances when a screenshot forces a frame (`docs/technical-plan.md` §9).
9. **Git:** stage explicit paths only. Commit and push under the operator's
   authorization for the plan you are executing.
10. **Plans:** execute the plans in `plans/` in order, honor each plan's STOP
    conditions, and update its row in `plans/README.md` when done.
11. **Not Videorc:** do not use the Videorc skills or touch `~/projects/videorc`.
