# IMG-0028 — NPC: the Crier

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (NPC)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Crier (`docs/story/cast.md`), on his platform in `cathedral_parvis`. One painting, skinned by `new_npc.gd` (decision #49).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "1440x2560",
  "quality": "high",
  "n": 3,
  "background": "transparent",
  "references": [
    "art-source/raw/IMG-0013/IMG-0013-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the old town Crier: a tall, thin man in a long, many-caped greatcoat and a battered tricorn hat, a roll of old proclamations under his left arm and a large brass handbell raised high in his right hand.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (his face is lost in the shadow under his tricorn and the high turned-up collar of his coat). Pose: standing tall and theatrical, mid-announcement, the handbell raised beside his head, facing three-quarters to the viewer's right. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Whole from hat to boots, facing right, on transparency.
- [ ] The raised arm and bell stand clear of the body.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:51Z | IMG-0028-v1.png, IMG-0028-v2.png, IMG-0028-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
