# IMG-0019 — Item sheet: the prologue

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (items)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Inventory icons for the prologue's puzzle chain (`docs/story/prologue-puzzles.md`): the ossuary key, the lantern glass, the mended lantern, the hymn book and the west door key. Claude cuts them into icons for `new_item.gd`.

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
    "art-source/raw/IMG-0013/IMG-0013-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A sheet of five separate inventory item icons for a dark gothic point-and-click adventure game, painted in the monochrome greyscale ink-wash style of the reference image, each object drawn whole and alone, in a three by two grid with generous empty space between them, nothing overlapping or touching:

1. a small old iron key with a round bow and a blank tin tag on a loop of string; 2. a cylindrical glass lantern chimney, slightly smoky; 3. an old iron hand lantern with its glass in place and a faint warm glow inside; 4. a small worn leather hymn book, closed, with a frayed ribbon bookmark; 5. a very large ornate black iron church door key.

Each object is lit from the upper left with a soft rim light, slightly three-quarter view, as a clean cut-out on a fully transparent background, with no shadows, labels, frames or scenery. No text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Five separate objects with space between them, on transparency.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Each object is whole and separate.
- [ ] They read at 128 px.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:06Z | IMG-0019-v1.png, IMG-0019-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v1** | Claude's pick (#29). Both sheets have five separate objects on transparency; v1 spaces them widest for cutting. |
