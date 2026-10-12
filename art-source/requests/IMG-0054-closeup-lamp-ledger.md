# IMG-0054 — Close-up: the lamplighter's tally wall

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `lamp_ledger` close-up in `lamplighter_shed`: a stretch of the wall of tally marks, one for every name the Lamplighter can't remember. Hotspots: the marks, the unfinished last group.

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
    "art-source/raw/IMG-0034/IMG-0034-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the wall of scratched tally marks from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: a stretch of old plaster wall fills the frame, covered edge to edge in thousands of hand-scratched tally marks in neat groups of five (four strokes crossed by a fifth), row upon row. Near the bottom right, the very last group is unfinished: only four strokes, with an empty space for the fifth. Cold moonlight rakes across the scratches.

No letters, words or numbers anywhere: only tally strokes. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Rows of five-bar tally groups, and one unfinished group of four.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T23:03Z | IMG-0054-v1.png, IMG-0054-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
