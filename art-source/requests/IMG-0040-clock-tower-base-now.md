# IMG-0040 — The clock tower square, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 9)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 9 of chapter 1, `clock_tower_base` (`docs/story/atlas.md`, `docs/story/ch1-puzzles.md`).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "opaque",
  "references": [
    "art-source/raw/IMG-0027/IMG-0027-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: a small square at the foot of a massive gothic clock tower at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: The tower rises left of centre far out of the top of the frame; high above, its great round clock face, stopped, the hands hanging down. At the tower's foot, a heavy iron-bound door in a pointed arch. To the right of the door, under a wooden lean-to against the tower wall, a clockmaker's workbench cluttered with springs, gears and tools. On the far right, a stone stair leads down out of the square between walls; on the far left, a street leads back toward a canal.

The lower third of the image is open, walkable ground: the cobbled square runs across the whole width. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The tower with its stopped face, the door at its foot, the workbench under a lean-to, the stair down on the right, the street on the left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches chapter 1's style key (IMG-0027 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:58Z | IMG-0040-v1.png, IMG-0040-v2.png, IMG-0040-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
