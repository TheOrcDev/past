# IMG-0012 — Cemetery gate, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 0 (the Sol spike's then-edit) and slice 4 (room P1)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `cemetery_gate` (atlas P1): the same gate in color, as an
edit of IMG-0011 v1 (decision #18). For the spike it measures whether Sol's
edits hold the composition (`art-pipeline.md` §8: p90 ≤ 3 px after `align`).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 2,
  "background": "opaque",
  "references": ["art-source/raw/IMG-0011/IMG-0011-v1.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the lodge on the left, the gate and its two stone posts with urns in the centre, the row of graves and the lantern pole on the right, the chapel and its steps, the trees, the distant city and the path. Only change the time and the condition.

Restore the same cemetery gate to how it looked decades earlier, on a warm golden autumn evening, in full rich color, as a painterly gothic matte painting: the gate whole, black-lacquered and standing upright on both hinges, the lodge's window glowing warm with lamplight and a wreath on its door, the graves neatly tended with fresh flowers, flower sellers' baskets of lilies and roses beside the gate posts, mourners' lanterns glowing along the path, gold and red leaves on the trees and the ground, a warm sunset sky in place of the moon, the city's spires gleaming gold in the distance. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- The same composition, shape for shape, in warm full color.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `past-art align` p90 ≤ 3 px against IMG-0011 v1.
- [ ] It reads as the same place in its golden age.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T21:41Z | IMG-0012-v1.png, IMG-0012-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-11T21:50Z | **accepted: v1** | Claude's pick (decision #29). Both hold the composition: `align` against IMG-0011 v1 gives p90 1.56 px (v1) and 1.89 px (v2), median 0.73 and 0.60, scale within 0.0003, inside the 3 px gate. v1 restores the gate, lit lodge with its wreath, tended graves with flowers and lanterns, gold leaves and a sunset where the moon was. |
