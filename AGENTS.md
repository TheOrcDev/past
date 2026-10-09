# Past — agent instructions

Past is a mouse-only, fully voiced point-and-click adventure. It is built in
Godot 4.7 with GDScript, using our own small adventure core and Dialogue Manager
4 for dialogue. Unknown, a shadow with no memory, searches a ruined gothic city
for who he was, and flashbacks show places as they used to be. The full game
ships on desktop, and the prologue also runs in the browser as a demo.

Start with `docs/game-design.md`, `docs/roadmap.md` and `plans/README.md`. The
decision log is `docs/decisions.md`. The pipelines are `docs/art-pipeline.md`,
`docs/audio-pipeline.md` and `docs/technical-plan.md`.

The repository is `github.com/TheOrcDev/past` (private). Two AI agents work in
it for one operator (OrcDev). They coordinate through the repository, not
through chat.

| Who | Role | Writes |
|---|---|---|
| **GPT image agent** | Generates every image | New files in `art-source/raw/<ID>/`; the `status:` line and **Delivery** table of `art-source/requests/<ID>-*.md`; appended entries in `docs/agent-board.md` |
| **Claude Code** | Everything else: code, scenes, tools, image processing, rigging and animation, audio generation, docs and plans | Everything except `art-source/raw/**` |
| **Operator** | Decides story, art direction, spend and gates | Anything |

## Image requests: the GPT ↔ Claude loop

1. **Claude** copies `art-source/requests/_TEMPLATE.md` to
   `art-source/requests/IMG-####-<slug>.md`, fills it in, sets `status: open`
   and posts on the board.
2. **The GPT image agent** generates the requested variants and saves them
   unmodified as `art-source/raw/IMG-####/IMG-####-v1.png`, `-v2.png` and so
   on. Next to them it writes `receipt.md` with the final prompt text, the tool
   and model, the output size, the date and the reference files it used. It
   adds a row to the request's Delivery table, sets `status: delivered` and
   posts on the board.
3. **Claude** reviews the variants against the acceptance criteria and records
   a verdict in the Review table:
   - `accepted: v2` if one passes;
   - `status: revise` with numbered notes if none do. The next round continues
     the numbering (v4, v5 …).

   A request marked `operator-approval: required` stays `delivered` until the
   operator approves it.
4. Files in `art-source/raw/` are never edited, renamed or deleted. Processing
   writes to `art-source/work/`, and shipping assets go into the Godot project.
5. If the image agent cannot write into the repository, the operator drops its
   files into `art-source/raw/<ID>/` and Claude writes the receipt from the
   operator's notes.

## Board

`docs/agent-board.md` is the shared channel. It holds the open image requests,
the open operator decisions and an append-only log. Read it before starting
work and append to it after finishing a slice. Timestamp entries in UTC and
address `@Claude`, `@GPT` or `@Operator`.

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
5. **ElevenLabs** generation goes through `tools/audio` and its manifest cache.
   Never regenerate an accepted asset without a reason. Stay under the credit
   ceiling the operator set for the plan.
6. **Secrets** live in `.env`, which is gitignored, for example
   `ELEVENLABS_API_KEY`. Never print or commit them.
7. **Shaders:** clamp `pow()` bases to ≥ 0. Apple GPUs return NaN for negative
   bases and the screen goes black.
8. **Browser checks** use a visible Chrome tab. Background tabs throttle
   rendering, and their screenshots come back black.
9. **Shared worktree:** two agents work here, so stage explicit paths only. Never
   run `git add -A`, `git add .`, `git stash` or `git reset` over the other
   agent's files. Commit and push only under the operator's authorization for
   the plan you are executing.
10. **Plans:** execute the plans in `plans/` in order, honor each plan's STOP
    conditions, and update its row in `plans/README.md` when done.
11. **Not Videorc:** do not use the Videorc skills or touch `~/projects/videorc`.
