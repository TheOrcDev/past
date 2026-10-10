# IMG-0003 — Unknown turnaround, with tendrils

status: delivered
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Unknown's model sheet, used as the reference for his Blender body (art pipeline
§5C) and for how his smoke tendrils look and move. IMG-0004 is the same sheet
without tendrils, for modeling the body's proportions.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-flare",
  "size": "3072x1024",
  "quality": "medium",
  "n": 2,
  "background": "transparent",
  "references": ["docs/reference/concept-04-city-triptych.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A character turnaround sheet for a 2D game, based on the shadow figure in the reference image. The character, Unknown, is a lean humanoid shadow: a pure black silhouette with a subtle grey rim light along its edges, small glowing white eyes, a smooth bald head, and long smoke-like tendrils streaming from the shoulders and upper back like a torn cloak.

Show five full-body views in one row, left to right, evenly spaced, all at the same height and scale: front, three-quarter front, side view facing right, three-quarter back, back.

Neutral A-pose: standing straight, arms held slightly away from the body, legs slightly apart.

Orthographic view with no perspective distortion, no ground shadow and no scenery. Transparent background.

The same style as the reference: crisp silhouette edges, an ink-wash texture and soft, wispy smoke. No text, labels, watermark or border.
```

## Must have

- Five consistent views of the same figure, at the same scale, in an A-pose.
- The eyes visible in the front and three-quarter-front views only.

## Must not have

- A background, ground shadow, text or labels.
- Clothing details or a face beyond the eyes.

## Acceptance criteria

Claude checks these.

- [ ] Proportions match across the views: head, shoulder and hip heights line up within about 2% of the figure's height.
- [ ] The background is truly transparent (alpha), and the silhouette is solid black.
- [ ] The figure matches concept 04's Unknown side by side; the operator approves the model sheet.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T08:11Z | IMG-0003-v1.png, IMG-0003-v2.png | openai/gpt-image-2.5-flare | 3072x1024 / medium | 0.041 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T08:13Z | Waiting for operator approval. | All five views are consistent across both variants, the alpha is clean and the eyes show only in the front views. The build is more muscular than concept 04's lean shadow, though v1 is the leaner of the two. Recommendation: one revise round for a leaner, wirier build, unless the operator likes this look. |
