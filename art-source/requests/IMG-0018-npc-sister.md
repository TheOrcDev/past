# IMG-0018 — NPC: the Sister

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (NPC)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Sister (`docs/story/cast.md`): the choir's last nun, in `cathedral_cloister`. One painting, skinned by `new_npc.gd` (decision #49).

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
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the last Sister of a cathedral choir: a tall, narrow nun in a long flowing dark-grey habit with a wide pale starched wimple and a dark veil falling to her shoulders, a simple wooden cross on a cord, her hands folded into her wide sleeves.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (her face is hidden in the deep shadow of her veil and wimple). Pose: standing upright and very straight, hands folded in front of her in her sleeves, head slightly bowed, facing three-quarters to the viewer's right. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- A tall narrow outline: veil, wimple, habit, folded sleeves.
- Mid and light greys, the same painted finish as the Gravedigger.
- A fully transparent background.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Whole from veil to hem.
- [ ] Facing right, like the Gravedigger.
- [ ] Head separate enough from the body to nod with a bone.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:05Z | IMG-0018-v1.png, IMG-0018-v2.png, IMG-0018-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v2** | Claude's pick (#29). All three are faceless and grey with a real transparent background. v2 faces right like the Gravedigger, with a tall, narrow outline and clear cord and cross. |
