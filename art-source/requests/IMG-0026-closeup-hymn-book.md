# IMG-0026 — Close-up: the dove's hymn book

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `hymn_book` close-up in `choir_loft`: the open hymn book on its stand, with names written small in its margins. Hotspots: the names, the hymn's words, the ribbon.

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
A close-up of the open hymn book on the music stand from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: the two open pages of a small old hymn book fill the frame, lit by a shaft of moonlight: printed staves of music, and down both outer margins dozens of tiny handwritten names in a neat, slanting woman's hand, too small to read individually. A frayed ribbon bookmark lies across the gutter.

At the top of the left page, one printed line, exactly:
REMEMBER US

All the handwritten names in the margins are tiny and illegible. No other readable text. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] REMEMBER US reads exactly.
- [ ] The margins are full of tiny handwritten names.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:12Z | IMG-0026-v1.png, IMG-0026-v2.png, IMG-0026-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T02:10Z | **accepted: v2** | Claude's pick (#29). All three print REMEMBER US exactly with tiny handwritten names in both margins; v2 is sharpest and best lit. |
