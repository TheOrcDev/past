# IMG-0101 — Close-up: the keepers' petition

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `petition` close-up in `sluice_house`. Hotspots: the text, the struck names, the seal.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "opaque",
  "references": [
    "art-source/raw/IMG-0077/IMG-0077-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the petition pinned to the sloping desk from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: an old, water-stained paper petition pinned to wood fills the frame: a heading, a short paragraph, then a column of handwritten signatures, every one struck through with a single hard ink line; the first signature begins with a large proud A. At the bottom, a red wax seal pressed with a quill crossed over a closed book.

The heading reads exactly:
THE PETITION OF THE KEEPERS OF THE GATES
and one line beneath it reads exactly:
Let us keep our names, and we will keep your gates.
The signatures are illegible apart from the large initial A of the first. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The heading and the line read exactly.
- [ ] Every signature struck through; a seal at the bottom.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:33Z | IMG-0101-v1.png, IMG-0101-v2.png, IMG-0101-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
