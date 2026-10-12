# IMG-0092 — The drowned street, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (room 3, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `drowned_street`, an edit of IMG-0075-v1.

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
    "art-source/raw/IMG-0075/IMG-0075-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: every house, the sluice house and its door and window, the rooftops, the chapel spire and the landing. Only change the time and the condition.

Restore the same street to how it looked decades earlier, before the flood, on a bright morning, in full rich warm color, as a painterly gothic matte painting: no floodwater: a dry cobbled street between the houses with a narrow clear canal running down its side, gardens and window boxes, the sluice house's door open with a keeper's bench beside it, laundry in bright colors on the lines, the chapel spire whole with its bell, warm sunshine. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0075-v1.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:30Z | IMG-0092-v1.png, IMG-0092-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
