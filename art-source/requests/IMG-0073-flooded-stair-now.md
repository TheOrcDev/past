# IMG-0073 — The flooded stair, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (room 1)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 1 of chapter 2, `flooded_stair` (`docs/story/atlas.md`, `docs/story/ch2-puzzles.md`).

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
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the bottom of a broad stone stair that descends straight into still black floodwater, in a drowned gothic city quarter at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: On the right, the stair comes down from the upper town out of the frame. On the left, the steps disappear under mirror-still black water reflecting the moon. Beyond, drowned rooftops and upper storeys stand out of the water, dead trees rise from the flood, and far away the tall arches of a ruined aqueduct march into the fog. In the middle ground on the left, a stone quay runs off along the water toward a jetty, and on a wooden post at the water's edge hangs a small iron ferry bell.

The lower third of the image is open, walkable ground: a wide stone landing at the foot of the stair runs across the lower third, its left edge lapped by water. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The stair coming down on the right, the water and drowned roofs, the bell on its post, the quay leading left.

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
| 1 | 2026-10-12T00:22Z | IMG-0073-v1.png, IMG-0073-v2.png, IMG-0073-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v3** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
