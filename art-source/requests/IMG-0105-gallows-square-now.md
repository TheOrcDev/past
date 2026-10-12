# IMG-0105 — The gallows square, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (room 2)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 2 of chapter 3, `gallows_square` (`docs/story/atlas.md`, `docs/story/ch3-puzzles.md`).

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
    "art-source/raw/IMG-0063/IMG-0063-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: a bare paved square in the upper city at night, with a gallows, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: In the centre, a tall wooden gallows on a raised platform with a few steps, a single noose hanging from its beam. Around the edges, the empty iron frames of a flower market's stalls, rusted. Tall grim buildings behind; on the right, an archway back to the avenue.

The lower third of the image is open, walkable ground: the open paving of the square runs across the lower third, in front of the gallows. It is lit by pale moonlight behind the gallows with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The gallows with its beam and noose, the empty market frames, the archway on the right.

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
| 1 | 2026-10-12T01:00Z | IMG-0105-v1.png, IMG-0105-v2.png, IMG-0105-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
