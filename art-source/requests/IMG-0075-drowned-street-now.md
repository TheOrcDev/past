# IMG-0075 — The drowned street, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (room 3)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 3 of chapter 2, `drowned_street` (`docs/story/atlas.md`, `docs/story/ch2-puzzles.md`).

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
    "art-source/raw/IMG-0062/IMG-0062-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: a canal that was once a street, running between gothic houses sunk to their upper floors, at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: Houses on both sides stand in black water up to their first-floor windows; shutters hang open; laundry lines are strung across overhead. On the right, a tall stone sluice house with a heavy wooden door half under water and, above it, a dark open window with a stone ledge just out of reach. In the middle, a wooden crate floats against a wall. On the left, a run of sagging rooftops leads like stepping stones toward a half-sunk chapel spire in the distance.

The lower third of the image is open, walkable ground: a broad stone landing (the top of a drowned flight of steps) in front of the houses, where the boat ties up, runs across the lower third. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The sluice house with its high window on the right, the floating crate, the rooftops leading left to a chapel spire.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the drowned quarter's reveal (IMG-0062 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:26Z | IMG-0075-v1.png, IMG-0075-v2.png, IMG-0075-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
