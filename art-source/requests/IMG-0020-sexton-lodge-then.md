# IMG-0020 — The Gravedigger's lodge, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P2, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `sexton_lodge` (atlas P2), an edit of IMG-0014 v2 (decision #18).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 2,
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
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the door on the left, the stove and the cot, the key board and lantern shelves on the back wall, the lectern and the window on the right, and the floor. Only change the time and the condition.

Restore the same lodge to how it looked decades earlier, on a warm autumn evening, in full rich warm color, as a painterly gothic matte painting: the stove glowing with a lively fire, the lanterns on the shelves all lit and warm, a wreath of autumn leaves hung on the open door with golden evening light outside, a woman's knitted shawl on the peg by the cot, a vase of dried flowers on the sill, the ledger's pages clean and fresh, the floor swept. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0014 v2.
- [ ] The same room, warm and lived in.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:09Z | IMG-0020-v1.png, IMG-0020-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T01:20Z | **accepted: v1** | Claude's pick (#29). Both hold the room (p90 1.48 and 1.72 px against IMG-0014 v2); v1 is warmer: fire, lit lanterns, wreath, the shawl on its peg. |
