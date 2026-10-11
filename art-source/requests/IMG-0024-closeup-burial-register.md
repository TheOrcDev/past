# IMG-0024 — Close-up: the burial register

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `burial_register` close-up in `sexton_lodge`: the open ledger on the lectern. Its hotspots are the entry ("U—, paid by a dove", "Stone defaced by order of the Registrar"), the margin note ("Ossuary: key 13") and the page.

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
    "art-source/raw/IMG-0014/IMG-0014-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the huge open ledger on the wooden lectern from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: the two open pages of an old burial register fill the frame, seen from above at a slight angle, lit by cold moonlight from a window to the right. Faded ruled columns of handwritten entries in old ink, most of them blurred, smudged or scratched out. One entry in the middle of the left page stands out, in clear old handwriting. A note is written in the right page's margin.

The only legible handwriting, exactly as written and nothing else readable:
U—
paid by a dove
Stone defaced by order of the Registrar

and in the right margin:
Ossuary: key 13

Everything else on the pages is illegible scribble. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The entry and the margin note read exactly as written.
- [ ] Same monochrome ink-wash style.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:09Z | IMG-0024-v1.png, IMG-0024-v2.png, IMG-0024-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T01:20Z | **accepted: v2** | Claude's pick (#29). All three spell the entry and the margin note exactly ("U—", "paid by a dove", "Stone defaced by order of the Registrar", "Ossuary: key 13"); v2's hand is the largest and clearest. |
