# IMG-0156 — Unknown redesign: comic-cartoon model sheet, bolder cartoon

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 1 (design)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: a bolder, more cartoon take on the same brief as IMG-0155, to choose Unknown's new design from.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "transparent",
  "references": [
    "art-source/raw/IMG-0011/IMG-0011-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A character model sheet for the hero of a dark gothic point-and-click adventure game, in the style of a modern hand-drawn gothic animated film crossed with an inked comic book: strong graphic silhouettes, clean confident brush-ink linework and a little hatching, in a monochrome cold grey moonlit palette matching the attached ink-wash painting.

The character, Unknown: a shadow come to life in the shape of a slim man, solid ink-black all over, with no clothes and no realistic anatomy. His black shape is given form only by a bold tapering ink outline, a sharp silvery moonlight rim along his back and shoulders, and a few loose cross-hatched highlight strokes on the shoulders, chest and knees. A smooth round faceless head, slightly too big for his body in a charming cartoon way, with two glowing white almond eyes and no mouth, nose, ears or hair. A thin neck, narrow shoulders, a lean torso tapering to a small waist, long spindly arms ending in big graceful hands with four long fingers, long thin legs and small pointed feet. Gentle, curious, a little sad, with a dry sense of humour in his posture: shoulders slightly hunched, head tilted forward with interest.

The sheet shows four views of the same character side by side, evenly spaced, all exactly the same height, standing on one shared invisible baseline: 1) full profile facing right, 2) front, facing the viewer, 3) back, facing away, 4) three-quarter view facing right. A relaxed neutral standing pose in every view: arms hanging a little away from the body so the hands are clearly separated from the hips, feet slightly apart. Each figure shown whole from head to toes, filling most of the image height.

On a fully transparent background, with no ground, shadow, smoke or scenery. No text, labels, letters or numbers. No watermark, signature or border.
```

## Must have

- Solid black figures with bold ink outline, rim light and a little hatching
- Four views of the same design at the same height on one baseline
- Two white almond eyes and nothing else on the face

## Must not have

- Realistic muscle anatomy or a mannequin look
- Clothes, smoke, ground, text or a frame

## Acceptance criteria

Claude checks these.

- [ ] Reads as comic-cartoon, not 3D
- [ ] Fits the cemetery's ink-wash palette
- [ ] Hands and arms stand clear of the body in front and back views

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T04:52Z | IMG-0156-v1.png, IMG-0156-v2.png, IMG-0156-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | As IMG-0155: alien. Superseded by IMG-0157. |
