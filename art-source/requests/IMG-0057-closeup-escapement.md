# IMG-0057 — Close-up: the escapement

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `escapement` close-up in `clockworks`: the escape wheel and the loose pallet pin. Hotspots: the wheel, the pin.

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
    "art-source/raw/IMG-0041/IMG-0041-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the clock's escapement from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: a large toothed iron escape wheel fills most of the frame, with its anchor above it, and a loose brass pallet pin hanging out of its slot on a little chain. Oil stains, dust, and moonlight glinting on the teeth.

No readable text, letters or numbers anywhere. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The wheel's teeth and the loose pin are the focus.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T23:04Z | IMG-0057-v1.png, IMG-0057-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
