# IMG-0157 — Unknown redesign: shadow in a torn greatcoat, with hair

status: accepted
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 1 (design)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: IMG-0155 and IMG-0156 read as aliens (a bulbous head, slanted eyes, a naked body). This round gives Unknown the shadow of a man's clothes, a greatcoat whose hem frays into ink, a human head with a shock of hair, and round eyes.

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

The character, Unknown: the living shadow of a man who has forgotten who he was. He is solid ink-black from head to toe, a flat deep black shape given form only by a bold tapering brush outline, a crisp silvery moonlight rim line along the edges that face the light, and a few sparse hatched highlight strokes. He has the shadow-silhouette of the clothes he died in: a long, fitted, old-fashioned greatcoat with a tall upturned collar, reaching below his knees, its hem and tails torn into ragged strips that fray into wisps of ink. Underneath, thin trousers and simple pointed shoes, all part of the same black shape. A slightly large head for his body, human in shape (a real skull and jaw, not round or bulbous), crowned with a messy, swept-back shock of shadow hair whose tips curl and fray into ink. No mouth, nose, ears or face details: only two small, round, glowing white eyes, level and gently spaced, like two pinpricks of moonlight. Tall and lean, narrow shoulders, long arms with long-fingered hands, a slight curious stoop. He looks melancholy, gentle and quietly funny, never monstrous, never alien.

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
| 1 | 2026-10-16T04:56Z | IMG-0157-v1.png, IMG-0157-v2.png, IMG-0157-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **accepted: v2** | Claude's pick (#29): the shadow of a man in a torn greatcoat with a tall collar, a shock of hair and round eyes reads as a gothic comic-cartoon hero. Composited into `cemetery_gate` beside the Gravedigger it sits with the room and the NPCs. v2 has the clearest coat and hair. It is plan 010's model sheet. |
