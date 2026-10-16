# IMG-0162 — Unknown redesign: walk cycle, away from the viewer

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 2 (walk)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: Unknown's new walk (away from the viewer), painted by Sol over a pose guide from the old rig's walk (8 frames of its 1 s cycle), so the motion is right and the design stays IMG-0157 v2.

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
    "art-source/work/characters/unknown2/guides/guide_walk_u.png",
    "art-source/raw/IMG-0157/IMG-0157-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit the first image. It is an animation pose guide: 8 frames of a walk cycle, in 2 rows of 4, read left to right, top row first, each grey mannequin figure showing one pose. Repaint it as a finished 2D game animation sprite sheet of the character in the second image (a model sheet), keeping everything about the layout and the motion exactly as in the guide: the same 8 frames in the same order and the same cells, each figure at the same place and the same size, with the same pose of the legs, feet, arms, hands, body and head in every frame.

Replace each mannequin with the character exactly as designed in the model sheet: the living shadow in the long torn greatcoat with the tall upturned collar, slim trousers and pointed shoes, the messy shock of shadow hair, and two small round glowing white eyes, solid ink-black with a bold brush outline, a thin silver rim line and sparse hatching, drawn halfway between an inked comic and a hand-drawn animated film. He walks away from the viewer, seen from behind as in the guide, so his eyes are not visible: we see the back of his hair, the tall collar and the long back of the coat with its split tail. Draw him identically in all 8 frames, as a professional animator would: the same proportions, coat, collar, hair and line style throughout, so the frames play back as one smooth walk. Only the motion changes: his legs and arms move exactly as the guide shows, the coat's split tail and torn hem sway from side to side with each step, and the tips of his hair bob slightly.

The character's head and hair are a little bigger than the mannequin's and his coat reaches below his knees, so let him fill each cell from just above the top of the mannequin's head down to its feet. Keep clear empty space between neighbouring frames so no two frames touch. Replace the grey background with full transparency: a fully transparent background, with no ground, cast shadow, smoke or scenery. No text, numbers, frame labels, grid lines or borders.
```

## Must have

- The guide's 8 poses in its layout, painted as IMG-0157 v2

## Must not have

- Frames touching
- Text or grid lines

## Acceptance criteria

Claude checks these.

- [ ] Each frame's pose matches its guide frame
- [ ] The design is the same in all 8 frames
- [ ] The cycle loops smoothly

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T05:05Z | IMG-0162-v1.png, IMG-0162-v2.png, IMG-0162-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | Heavy build and a short coat. Superseded by IMG-0175. |
