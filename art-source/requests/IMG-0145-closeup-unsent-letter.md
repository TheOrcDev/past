# IMG-0145 — Close-up: the unsent letter

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `unsent_letter` close-up in `dove_room` (`docs/story/ch4-puzzles.md`).

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
    "art-source/raw/IMG-0017/IMG-0017-v3.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of a folded letter on a small writing desk, opened from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: an old handwritten letter on cream paper, opened flat on a wooden desk by moonlight, a broken red wax seal beside it, a few short lines in a hurried, slanting man's hand, then a signature.

The letter reads exactly, and nothing else is readable:
Elise.
I can't undo it. I'm sorry.
I was afraid of a city that remembered.
and the signature is a single letter:
U
No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The four lines read exactly as written.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:25Z | IMG-0145-v1.png, IMG-0145-v2.png, IMG-0145-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
