# IMG-0129 — Close-up: the index of names

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `ledger_index` close-up in `archive_stacks` (`docs/story/ch3-puzzles.md`).

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
    "art-source/raw/IMG-0111/IMG-0111-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the enormous open index ledger on the reading lectern from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: the two open pages fill the frame: dense columns of tiny handwritten index entries, almost all struck through with single lines. On the left page, one entry stands out, larger and clear. At the very bottom of the right page, the last entry, in a different, tidier hand, also clear.

The clear entry on the left page reads exactly:
Singer, cathedral choir, called the Dove
Struck by the High Magistrate's own hand, at his own desk
The last entry at the bottom right reads exactly:
The High Magistrate
Everything else is illegible. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The two entries read exactly as written.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:09Z | IMG-0129-v1.png, IMG-0129-v2.png, IMG-0129-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v3** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
