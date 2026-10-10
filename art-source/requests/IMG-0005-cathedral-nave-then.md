# IMG-0005 — Cathedral nave, then

status: delivered
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The cathedral nave in the past, for the flashback. It is an edit of the
accepted now image (IMG-0001 v1), so the two line up pixel for pixel and the
flashback can restore the ruin in place (decision #18). Concept 05 guides the
colors and materials.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-sunburst",
  "size": "2560x1440",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["art-source/raw/IMG-0001/IMG-0001-v1.png", "docs/reference/concept-05-cathedral-then.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit the first image: show this exact cathedral nave as it looked in its golden age, before it fell into ruin. Keep the composition, camera, perspective and every architectural element exactly where it is. The pillars, arches, rose window, altar, the statue on its pedestal at the left, the chandeliers, the banners and the line of the floor must all line up with the first image, so the two pictures can be crossfaded.

Restore it to full color:
- the stone is clean white and cream marble with gold ornament;
- the stained-glass windows glow in rich, saturated colors, and the rose window blazes with color;
- deep blue banners embroidered with gold hang whole;
- the chandeliers hold lit candles, and white lilies stand in tall golden vases;
- the floor is polished marble that reflects the warm light;
- warm golden sunlight streams through the windows in visible rays, and the air is clear and bright, with no fog.

Use the second image only as a guide for the colors, materials and mood, not for the composition.

No people, figures or creatures. No text, watermark or border.
```

## Must have

- The same composition and camera as IMG-0001 v1: every landmark in the same place.
- Full warm color in the spirit of concept 05.

## Must not have

- Any figure, a changed layout, text or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` against IMG-0001 v1 shows a p90 residual of 3 px or less after auto-alignment (art pipeline §8).
- [ ] No characters, checked by zooming in.
- [ ] The operator approves the look against concept 05.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T08:45Z | IMG-0005-v1.png, IMG-0005-v2.png | openai/gpt-image-2.5-sunburst | 2560x1440 / medium | 0.079 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T08:48Z | Waiting for operator approval. Claude recommends **v1**. | Both pass `align` against IMG-0001 v1 before any correction: v1 has a p90 residual of 1.75 px (median 0.75), v2 1.71 px. Scale is 1.0013, rotation about 0° and the offset ≤1 px; the largest corner shift is 6.4 px (v1) and 5.4 px (v2). The look matches concept 05, and the 50% blend reads like a memory frame. v1 has the richer stained glass. No figures. |
