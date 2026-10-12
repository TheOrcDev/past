# IMG-0087 — Item sheet: chapter 2

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (items)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Inventory icons for chapter 2 (`docs/story/ch2-puzzles.md`): the crate, the sluice key and the stretcher.

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
A sheet of three separate inventory item icons for a dark gothic point-and-click adventure game, painted in the monochrome greyscale ink-wash style of the reference image, each object drawn whole and alone, in a three by one grid with generous empty space between them, nothing overlapping or touching:

1. a small square wooden shipping crate, wet and dark, its slats bound with rusty iron bands; 2. a large heavy iron key with a ring bow and a long square-toothed bit, on a loop of twine; 3. a folded canvas field stretcher: two long wooden poles with grey canvas strapped between them, rolled and tied with leather straps.

Each object is lit from the upper left with a soft rim light, slightly three-quarter view, as a clean cut-out on a fully transparent background, with no shadows, labels, frames or scenery. No text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Three separate objects on transparency, the same finish as the earlier item sheets.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:30Z | IMG-0087-v1.png, IMG-0087-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
