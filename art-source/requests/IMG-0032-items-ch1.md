# IMG-0032 — Item sheet: chapter 1

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (items)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Inventory icons for chapter 1 (`docs/story/ch1-puzzles.md`): the winding key, the wedding candle, the warm lamp and the seal ring.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 2,
  "background": "transparent",
  "references": [
    "art-source/raw/IMG-0019/IMG-0019-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A sheet of four separate inventory item icons for a dark gothic point-and-click adventure game, painted in the monochrome greyscale ink-wash style of the reference image, each object drawn whole and alone, in a two by two grid with generous empty space between them, nothing overlapping or touching:

1. a large iron clock-winding key: a square socket on a long shaft with a crank handle; 2. a short stub of a white wax candle in a little brass holder, a scrap of faded ribbon tied round it; 3. a lamplighter's small brass hand lamp whose flame glows a warm golden yellow, the only color on the sheet; 4. a heavy gold signet ring with a large flat oval seal face, its engraving worn smooth.

Each object is lit from the upper left with a soft rim light, slightly three-quarter view, as a clean cut-out on a fully transparent background, with no shadows, labels, frames or scenery. No text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Four separate objects on transparency, the same finish as the prologue's items.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:55Z | IMG-0032-v1.png, IMG-0032-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
