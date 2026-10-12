# IMG-0039 — The tavern, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 8)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 8 of chapter 1, `tavern_lost_name` (`docs/story/atlas.md`, `docs/story/ch1-puzzles.md`).

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
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the interior of an old, low-beamed tavern at night, empty, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: A long bar on the right with tankards and empty bottles, and a big tarnished mirror on the wall behind it. Overturned stools and chairs around round tables. On the left, a large stone fireplace, cold, with a mantelpiece holding a single short candle stub in a little brass holder. A slate board on the back wall, covered in chalked sums and scratched-out lines. Low heavy beams overhead; a door at the back.

The lower third of the image is open, walkable ground: the flagstone floor between the tables is open across the room. It is lit by pale moonlight through small leaded windows with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The bar and mirror on the right, the cold fireplace with a candle stub on the mantel on the left, the slate board of debts, overturned stools.

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
| 1 | 2026-10-11T22:57Z | IMG-0039-v1.png, IMG-0039-v2.png, IMG-0039-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
