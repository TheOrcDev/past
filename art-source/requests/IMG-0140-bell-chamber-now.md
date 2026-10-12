# IMG-0140 — The bell chamber, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (room 8)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 8 of chapter 4, `bell_chamber` (`docs/story/atlas.md`, `docs/story/ch4-puzzles.md`).

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
    "art-source/raw/IMG-0017/IMG-0017-v3.png",
    "art-source/raw/IMG-0064/IMG-0064-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the bell chamber at the top of a gothic cathedral tower at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: Three great bronze bells hang in a massive timber frame in the centre; louvred openings in the stone walls show the moon and city. A wooden ladder on the right climbs through a hatch to the open top of the tower. The stair arrives at the left.

The lower third of the image is open, walkable ground: the plank floor around the bell frame runs across the lower third. It is lit by moonlight through the louvres with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Three great bells in a timber frame, the ladder and hatch on the right, the stair on the left.

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
| 1 | 2026-10-12T01:27Z | IMG-0140-v1.png, IMG-0140-v2.png, IMG-0140-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
