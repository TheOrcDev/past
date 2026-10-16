# IMG-0163 — Unknown redesign: walk cycle, towards the viewer, round 2

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 2 (walk)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: IMG-0161 copied the mannequin's heavy build. This round paints over a guide with the mannequin thinned and lifted, and gives the accepted side walk (IMG-0160 v3) as the drawing to match.

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
    "art-source/work/characters/unknown2/guides/sheets/walk_d-wide.png",
    "art-source/raw/IMG-0157/IMG-0157-v2.png",
    "art-source/raw/IMG-0160/IMG-0160-v3.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit the first image. It is an animation pose guide: 8 frames of a walk cycle, in 2 rows of 4, read left to right, top row first, each grey mannequin showing one pose. Repaint it as a finished 2D game animation sprite sheet of the living shadow from the model sheet (the second image): a slim, lean man in a long, fitted, torn greatcoat with a tall upturned collar, its ragged hem fraying into wisps of ink, slim trousers and pointed shoes, a messy swept-back shock of shadow hair, and two small round glowing white eyes; solid ink-black, with a bold brush outline, a thin silver moonlight rim line and sparse hatching, drawn halfway between an inked comic and a hand-drawn animated film, exactly as in the third image, a finished sheet of him, keeping the layout and the motion exactly as in the guide: the same 8 frames in the same order and the same cells, with the same pose of the legs, feet, arms, hands, body and head in every frame. He faces the viewer, seen from the front as in the guide, with both glowing eyes visible. Copy only the poses from the guide, never the mannequin's build: Unknown is much slimmer than the mannequin, with a narrow chest, thin arms and thin legs, as in the model sheet. Draw him identically in all 8 frames, as a professional animator would, so they play back as one smooth walk. Only the motion changes: his legs and arms move exactly as the guide shows, the open front of the coat and its torn hem sway from side to side with each step, and the tips of his hair bob slightly.

Every figure is whole from hair to shoes and stays inside its own cell, at the same place and size as its mannequin, with clear empty space between neighbouring figures so none touch. Replace the grey background with full transparency: a fully transparent background, with no ground, cast shadow, smoke or scenery. No text, numbers, labels, grid lines or borders.
```

## Must have

- The guide's 8 poses in its layout, painted as IMG-0157 v2, slim

## Must not have

- The mannequin's heavy build
- Frames touching, text or grid lines

## Acceptance criteria

Claude checks these.

- [ ] Each frame's pose matches its guide frame
- [ ] The design and line style match IMG-0160 v3
- [ ] The cycle loops smoothly

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T05:18Z | IMG-0163-v1.png, IMG-0163-v2.png, IMG-0163-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | Better, but still broad, with the coat at the knee. Superseded by IMG-0174 (guide squeezed to 80%). |

The guide this round was painted on is `walk_d-wide.png`: the sheet as it was, before the front and back guides were squeezed to 80% in place (plan 010). It was rebuilt from the same rig renders with the same code, minus the squeeze.
