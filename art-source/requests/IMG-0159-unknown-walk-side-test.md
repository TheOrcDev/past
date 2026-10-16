# IMG-0159 — Unknown redesign: side walk cycle test

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 2 (animation route test)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: tests whether Sol can draw Unknown's new design (IMG-0157 v2) as a consistent 8-frame side walk cycle, which decides between hand-drawn frames and a cut-out rig.

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
    "art-source/raw/IMG-0157/IMG-0157-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A 2D game animation sprite sheet of the character in the attached model sheet (the same design exactly: the living shadow in the long torn greatcoat with the tall upturned collar, the messy shock of hair, the two small round glowing white eyes, solid ink-black with a bold brush outline, a thin silver rim line and sparse hatching, drawn halfway between an inked comic and a hand-drawn animated film).

He walks to the right in full profile: one complete, smooth, looping walk cycle in 8 frames, drawn like a professional hand-drawn animation key and in-between sheet. The frames are arranged in 2 rows of 4, to be read left to right, top row first. Frame 1: contact, right heel touching down in front, left leg behind. Frame 2: down, weight settling on the right leg, body at its lowest. Frame 3: passing, the left leg swinging past the straight right leg, body rising. Frame 4: up, body at its highest, the left leg reaching forward. Frame 5: contact on the other side, left heel touching down in front, right leg behind. Frame 6: down. Frame 7: passing, the right leg swinging past. Frame 8: up. The arms swing opposite to the legs, relaxed, with a slight lag at the hands. The torn coat tails swing and trail behind his legs with each step, and the tips of his hair bounce a little. A slight, thoughtful forward lean, an unhurried, gently melancholy stride.

Every frame shows the whole figure from hair to shoes, at exactly the same size as every other frame, standing on the same baseline within its row, each frame centred in an equal, evenly spaced cell, with clear empty space between neighbouring frames so no two frames touch or overlap. On a fully transparent background, with no ground, cast shadow, smoke or scenery. No text, numbers, frame labels, grid lines or borders.
```

## Must have

- 8 frames of one walk cycle, 2 rows of 4, same design as IMG-0157 v2

## Must not have

- Frames touching or overlapping
- Text or grid lines

## Acceptance criteria

Claude checks these.

- [ ] The design stays the same from frame to frame
- [ ] The legs alternate correctly through the cycle
- [ ] The frames loop smoothly

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T04:59Z | IMG-0159-v1.png, IMG-0159-v2.png, IMG-0159-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | A route test: drawn free, Sol repeated one stride in most frames, so the legs don't alternate. It led to painting over pose guides (IMG-0160). |
