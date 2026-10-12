# IMG-0084 — NPC: the Ferryman

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (NPC)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Ferryman (`docs/story/cast.md`), standing in his boat at `ferry_landing`. One painting, skinned (decision #49).

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
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the Ferryman of a drowned city: a tall, gaunt figure in a long hooded oilskin cloak, standing upright in the stern of a narrow, flat-bottomed wooden punt (the whole boat shown, seen from the side), holding a long punting pole planted beside him.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (his face is lost in the deep shadow of his hood). Pose: standing still and patient in the boat's stern, both hands on the pole, facing three-quarters to the viewer's right. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Whole, facing right, on transparency.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:24Z | IMG-0084-v1.png, IMG-0084-v2.png, IMG-0084-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
