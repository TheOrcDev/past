# IMG-0022 — The cathedral cloister, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P4, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `cathedral_cloister` (atlas P4), an edit of IMG-0016 v2.

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
    "art-source/raw/IMG-0016/IMG-0016-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the arcade, the doorway on the left, the stair turret on the right, the well, the sundial, the cathedral beyond and the walk. Only change the time and the condition.

Restore the same cloister to how it looked decades earlier, on a golden summer evening, in full rich warm color, as a painterly gothic matte painting: the garden in full bloom with red and white roses climbing the columns, green lawns and herb beds, the well whole with a rope and bucket and water in it, the sundial sharp and clean, the choir's long blue-and-gold robes drying on a line between two columns, the cathedral's windows glowing, a warm sunset sky in place of the moon. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0016 v2.
- [ ] The garden in bloom, the same shapes.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:12Z | IMG-0022-v1.png, IMG-0022-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T02:10Z | **accepted: v1** | Claude's pick (#29). Both align (p90 1.03 and 1.18 px against IMG-0016 v2); v1's garden in bloom, robes on the line and sunset read best. |
