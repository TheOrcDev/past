# IMG-0107 — The stage, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (room 4)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 4 of chapter 3, `theater_stage` (`docs/story/atlas.md`, `docs/story/ch3-puzzles.md`).

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
    "art-source/raw/IMG-0014/IMG-0014-v2.png",
    "art-source/raw/IMG-0063/IMG-0063-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the inside of a baroque theatre at night, seen from the front of the stalls toward the stage, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: The stage fills the middle: a tall red-curtained (grey here) proscenium arch, and centre stage a small striped puppet booth with a little curtained window. Rows of empty seats in the foreground at the edges. On the right, a gap in the side curtains leading into the wings. On the left, the aisle back to the foyer doors. A cold beam of moonlight from a broken skylight falls on the booth.

The lower third of the image is open, walkable ground: the stage apron and the aisle in front of the seats run across the lower third. It is lit by moonlight from a skylight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The puppet booth centre stage, the empty seats, the wings on the right, the foyer doors on the left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the upper city's reveal (IMG-0063 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:03Z | IMG-0107-v1.png, IMG-0107-v2.png, IMG-0107-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
