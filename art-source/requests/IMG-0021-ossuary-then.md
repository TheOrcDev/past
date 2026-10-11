# IMG-0021 — The ossuary, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P3, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `ossuary` (atlas P3), an edit of IMG-0015 v1. The vision "The edict" plays over it.

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
    "art-source/raw/IMG-0015/IMG-0015-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the stair and door on the left, the skull walls, the three tiers of niches, the vault and its grate, the ledges and the floor. Only change the time and the condition.

Restore the same ossuary to how it looked decades earlier, when it was tended, in full rich warm color, as a painterly gothic matte painting: every niche plaque freshly painted with gold lettering (unreadable at this distance), fresh flowers and wreaths laid in the niches, rows of lit candles on every ledge in warm amber light, clean swept stone, the crow's nest gone from the ledge, a warm glow of sunset through the vault grate. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0015 v1.
- [ ] Candlelit and cared for.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:10Z | IMG-0021-v1.png, IMG-0021-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T01:20Z | **accepted: v2** | Claude's pick (#29). p90 1.32 px against IMG-0015 v1 (v1: 1.47). Candlelit, painted plaques, flowers, red banners; the nest is gone. |
