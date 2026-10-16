# IMG-0158 — Unknown redesign: shadow in a tattered frock coat, bald

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 1 (design)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: the same correction as IMG-0157 with a bald head and a fitted frock coat, to choose between.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "transparent",
  "references": [
    "art-source/raw/IMG-0011/IMG-0011-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A character model sheet for the hero of a dark gothic point-and-click adventure game, drawn halfway between an inked graphic-novel comic and a hand-drawn gothic animated film: strong, simple, appealing shapes, clean confident brush-ink linework and a little loose hatching, in the cold grey moonlit monochrome palette of the attached ink-wash painting, so he belongs in that world while reading clearly against it.

The character, Unknown: the living shadow of a man, solid ink-black all over, a flat deep black shape defined by a bold tapering brush outline, a sharp silvery moonlight rim along his back and shoulders, and a few loose cross-hatched highlight strokes. He wears the black silhouette of a long tattered frock coat, buttoned and fitted at the waist, flaring out below to mid-calf, with a high collar standing up around his neck; the coat's ragged hem and split tails dissolve into curling threads of ink. Slim black trousers and narrow boots. A smooth, bald, human-shaped head, a little large for his body in a cartoon way, with a defined jaw and chin seen in profile; no mouth, nose or ears, only two small round glowing white eyes set level, like two dots of moonlight, which give him a curious, gentle expression. Tall, lean and long-limbed, with big graceful long-fingered hands, narrow shoulders and a slight thoughtful stoop. Melancholy and dryly funny, a hero you would follow, never a monster or an alien.

The sheet shows four views of the same character side by side, evenly spaced, all exactly the same height, standing on one shared invisible baseline: 1) full profile facing right, 2) front, facing the viewer, 3) back, facing away, 4) three-quarter view facing right. A relaxed neutral standing pose in every view, arms hanging a little away from the coat so the hands are clearly visible, feet slightly apart. Each figure shown whole from head to toes, filling most of the image height.

On a fully transparent background, with no ground, cast shadow or scenery. No text, labels, letters or numbers. No watermark, signature or border.
```

## Must have

- One solid black shape per figure, with ink outline, rim line and sparse hatching
- Four views of the same design at the same height on one baseline
- Two small round white eyes and no other face detail

## Must not have

- An alien look: bulbous head or slanted almond eyes
- Realistic muscle anatomy
- Ground, smoke clouds, text or a frame

## Acceptance criteria

Claude checks these.

- [ ] Reads as a comic-cartoon gothic hero
- [ ] Fits the cemetery's ink-wash palette
- [ ] Hands stand clear of the coat in front and back views

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T04:56Z | IMG-0158-v1.png, IMG-0158-v2.png, IMG-0158-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | The bald variant reads as a creepy Slenderman, less a hero; IMG-0157 was chosen. |
