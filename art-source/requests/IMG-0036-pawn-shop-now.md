# IMG-0036 — The Broker's shop, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 5)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 5 of chapter 1, `pawn_shop` (`docs/story/atlas.md`, `docs/story/ch1-puzzles.md`).

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
    "art-source/raw/IMG-0014/IMG-0014-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the narrow interior of a cluttered pawnbroker's shop at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: Every wall is crowded with stopped clocks, dolls, music boxes, rings on velvet trays and framed portraits turned to face the wall. A long wooden counter runs across the middle ground with a brass hand-scale on it. Behind the counter on the right, a tall locked glass-fronted cabinet holding a single heavy ring on a cushion. On the left, the shop door with a little bell above it, and the bay window full of clocks.

The lower third of the image is open, walkable ground: the wooden floor in front of the counter runs across the room. It is lit by pale moonlight through the bay window and dusty glass with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Walls of clocks and turned portraits, the counter with a scale, the glass cabinet with one ring, the door on the left.

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
| 1 | 2026-10-11T23:00Z | IMG-0036-v1.png, IMG-0036-v2.png, IMG-0036-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
