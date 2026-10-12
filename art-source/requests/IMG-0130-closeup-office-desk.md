# IMG-0130 — Close-up: the Magistrate's desk

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `office_desk` close-up in `magistrate_office` (`docs/story/ch3-puzzles.md`).

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
    "art-source/raw/IMG-0112/IMG-0112-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the top of the great desk from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: seen from above: a leather blotter with faint backwards marks pressed into it, a dried-up crystal inkwell, an empty quill stand, and a heavy closed leather book with brass corners, moonlight across them.

No readable text, letters or numbers anywhere. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Blotter, inkwell and closed book are each clear.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:11Z | IMG-0130-v1.png, IMG-0130-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
