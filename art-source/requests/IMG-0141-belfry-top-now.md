# IMG-0141 — The belfry, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (room 9)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 9 of chapter 4, `belfry_top` (`docs/story/atlas.md`, `docs/story/ch4-puzzles.md`).

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
    "art-source/raw/IMG-0064/IMG-0064-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the open top of a great gothic cathedral belfry high above a city at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: A square stone platform with a crenellated parapet and four pinnacles, a great bronze bell hanging in an open arch frame in the centre, its rope hanging. The whole grey city spread out below on every side in fog, the full moon huge behind.

The lower third of the image is open, walkable ground: the stone platform runs across the lower third. It is lit by a huge full moon with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The great bell in its arch, the parapet, the whole city below.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the heights' reveal (IMG-0064 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:22Z | IMG-0141-v1.png, IMG-0141-v2.png, IMG-0141-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
