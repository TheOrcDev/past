# IMG-0007 — Cemetery vista, ring 1 (2× detail)

status: accepted
operator-approval: not-required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Ring 1 of the cemetery reveal: the centre of ring 0 (IMG-0006 v1), repainted
with twice the detail. It is centred on the path where Unknown stands when the
reveal starts. The geometry is in `art-source/work/reveal/cemetery/rings.json`.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-sunburst",
  "size": "3072x1072",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["art-source/work/reveal/cemetery/ring1_source.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
This image is a crop from a wide painting of a misty gothic cemetery at night. Repaint it as a full-resolution painting of the same view. Keep the composition, the horizon, the shapes, the values and every object exactly where they are, so it lines up with the crop when scaled up.

Add the fine detail a closer view would show: weathered stone and moss on the graves, cracks, wrought-iron fence detail, grass and dead weeds, wet cobblestones on the path, drifting fog. The same monochrome greyscale ink-wash style as the source.

No people, figures or creatures. No text, watermark or border.
```

## Must have

- The crop's composition, unchanged, with finer detail.

## Must not have

- New objects in new places, figures, color, text or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` against the source crop scaled 2× gives scale ≈1 and a p90 residual of 4 px or less, so it composites into ring 0 with a feathered seam.
- [ ] No figures; the path reads continuously.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T09:05Z | IMG-0007-v1.png, IMG-0007-v2.png | openai/gpt-image-2.5-sunburst | 3072x1072 / medium | 0.030 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T09:07Z | **accepted: v1** | Against the source scaled 2×: p90 2.26 px, offset ≤0.7 px, largest corner shift 10.5 px. v2 had a 7.2 px vertical offset. It is a faithful detail repaint, slightly brighter than ring 0; levels are matched when compositing. |
