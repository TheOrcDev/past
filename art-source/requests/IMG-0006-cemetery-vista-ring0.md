# IMG-0006 — Cemetery vista, ring 0 (outer)

status: delivered
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The outermost ring of the cemetery pull-back reveal (game design §7, art
pipeline §5B): the whole landscape the camera ends on. It is concept 01 with the
figure removed. Rings 1 and 2 are detail repaints of its centre, made after this
one is accepted.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-sunburst",
  "size": "3072x1072",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["docs/reference/concept-01-cemetery-vista.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image: remove the walking shadow figure on the path at the left completely, and paint in the path, fog and graves where it stood, so that nothing of the figure remains.

Keep everything else exactly as it is: the composition, the cemetery, the angel statues, the mausoleums, the fences, the cathedral city with its spires, the bridges, the moon and the fog. Keep the same monochrome greyscale ink-wash style. Do not crop or widen anything.

No people, figures or creatures anywhere. No text, watermark or border.
```

## Must have

- Concept 01's composition and style, unchanged apart from the removed figure.

## Must not have

- The shadow figure or any other figure, color, text or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Zoomed in, the figure is gone with no ghosting, and the path reads continuously.
- [ ] `align` against concept 01 (scaled) shows the same composition.
- [ ] The operator approves the vista look.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T08:47Z | IMG-0006-v1.png, IMG-0006-v2.png | openai/gpt-image-2.5-sunburst | 3072x1072 / medium | 0.041 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T08:48Z | Waiting for operator approval. Claude recommends **v1**. | In both, the figure is removed cleanly; zoomed in, there is no ghosting and the path is continuous. Concept 01's composition and style are kept. v1's fog over the path is slightly closer to the concept. |
