# IMG-0025 — Close-up: an ossuary niche

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `ossuary_niche` close-up in `ossuary`: one burial niche with its scraped plaque. Hotspots: the plaque and the chisel marks.

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
    "art-source/raw/IMG-0015/IMG-0015-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of one of the arched burial niches in the back wall from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: a single stone niche fills the frame straight on: inside it, a small stone urn and a dry, crumbling wreath; below it, a rectangular stone name plaque scraped smooth, covered in fresh, careful chisel marks where letters used to be. Candle stubs and skulls at the edges, cold moonlight from above.

No readable text, letters or numbers anywhere. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The scraped plaque and chisel marks are the clear focus.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:11Z | IMG-0025-v1.png, IMG-0025-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T01:20Z | **accepted: v1** | Claude's pick (#29). v1's plaque carries the careful, fresh chisel scrapes the dialogue describes; v2's is smooth. |
