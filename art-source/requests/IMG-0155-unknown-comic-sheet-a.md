# IMG-0155 — Unknown redesign: comic-cartoon model sheet, lanky

status: rejected
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 1 (design)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: the operator wants Unknown redrawn between comic and cartoon, to sit with the painted rooms and NPCs instead of the 3D render. This sheet sets his new design: front, back, profile and three-quarter, standing. The game draws his eyes and ink tendrils itself.

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
A character model sheet for the hero of a dark gothic point-and-click adventure game, drawn in a stylized style halfway between a graphic-novel comic and an animated cartoon. He belongs in the world of the attached monochrome ink-wash painting (same cold grey moonlit palette, same ink texture), but he is drawn with bolder, simpler, more designed shapes than the background, like a hand-inked comic hero over a painted backdrop.

The character, Unknown: a living shadow in the shape of a lean man. His whole body is one solid, flat, deep ink-black shape with no clothes, no skin, no muscle anatomy and no surface texture. It is defined by a confident brush-ink outline, a thin crisp cold moonlight rim line along the edges that face the light, and a few sparse, elegant brush highlight strokes that suggest form at the shoulders, collarbones, ribcage, elbows and knees, the way a comic artist spots blacks. A smooth faceless head with no mouth, nose, ears or hair, and two small glowing white almond-shaped eyes set a little apart, slanting slightly upward at the outer corners, the only bright things on him.

Stylized cartoon proportions, appealing and readable: a head a little large for the body (about one sixth of his height), a slender neck, narrow bony shoulders that slope slightly forward, a slim chest and a narrow waist, long thin arms and legs, large expressive hands with long tapering fingers, and small feet with softly pointed toes. A slight thoughtful stoop. Lanky and graceful, a little melancholy, quietly funny, not monstrous and not muscular.

The sheet shows four views of the same character side by side, evenly spaced, all exactly the same height, standing on one shared invisible baseline: 1) full profile facing right, 2) front, facing the viewer, 3) back, facing away, 4) three-quarter view facing right. A relaxed neutral standing pose in every view: arms hanging a little away from the body so the hands are clearly separated from the hips, feet slightly apart. Each figure shown whole from head to toes, filling most of the image height.

On a fully transparent background, with no ground, shadow, smoke or scenery. No text, labels, letters or numbers. No watermark, signature or border.
```

## Must have

- One solid black shape per figure, with an ink outline, a crisp rim line and sparse brush highlights
- Four views of the same design at the same height on one baseline
- Two white almond eyes and nothing else on the face

## Must not have

- Realistic muscle anatomy or a mannequin look
- Clothes, smoke, ground, text or a frame

## Acceptance criteria

Claude checks these.

- [ ] Reads as comic-cartoon, not 3D
- [ ] Fits the cemetery's ink-wash palette
- [ ] Hands and arms stand clear of the body in front and back views

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T04:52Z | IMG-0155-v1.png, IMG-0155-v2.png, IMG-0155-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **rejected** | A naked figure with a bulbous head and slanted almond eyes reads as a grey alien, not a man's shadow. The ink style (black fill, brush outline, sparse hatching) is kept for the next round. |
