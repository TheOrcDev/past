# IMG-0049 — The market square, then (the wedding)

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 4, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `market_square`, an edit of IMG-0035 v1. The vision "The wedding" plays over it.

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
    "art-source/raw/IMG-0035/IMG-0035-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the fountain and the saint, the stalls and awnings, the pawnshop window and door, the houses, the bridge and the clock tower. Only change the time and the condition.

Restore the same market square to how it looked decades earlier, on a wedding-day evening, in full rich warm color, as a painterly gothic matte painting: the fountain running with clear water, the saint clean white marble with a fresh silk ribbon on her wrist, the stalls full of fruit, flowers and bread under bright striped awnings, garlands of white flowers strung across the square, rose petals scattered on the cobbles, the lamps lit warm gold, the pawnshop a bright jeweller's window, a warm sunset sky. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0035 v1.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T23:02Z | IMG-0049-v1.png, IMG-0049-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
