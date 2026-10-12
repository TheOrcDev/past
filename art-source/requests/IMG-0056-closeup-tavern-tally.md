# IMG-0056 — Close-up: the tavern's slate of debts

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `tavern_tally` close-up in `tavern_lost_name`: debts whose names are all scratched out. Hotspots: the names, the sums.

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
    "art-source/raw/IMG-0039/IMG-0039-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the slate board of debts on the tavern wall from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: a framed slate fills the frame: two chalked columns of debts, each line a scratched-out name followed by a small sum. Every name has been struck through with hard, angry chalk lines until it is unreadable; the sums are still clear.

Only small numbers are readable (sums such as 3, 12, 7, 20); every name is scratched out and illegible. No other text. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Every name scratched out; the sums remain.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T23:03Z | IMG-0056-v1.png, IMG-0056-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
