# IMG-0004 — Unknown turnaround, without tendrils

status: accepted
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Unknown's body without its smoke tendrils, so his proportions are easy to model
in Blender (art pipeline §5C). The tendrils are procedural in the game.
IMG-0003 is the same sheet with tendrils.

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
A character turnaround sheet for a 2D game, based on the shadow figure in the reference image. The character, Unknown, is a thin, wiry humanoid shadow, almost gaunt: long limbs, narrow shoulders, a slim waist and almost no visible muscle definition, so he reads as a thin shadow rather than an athlete. He is a pure black silhouette with a subtle grey rim light along his edges, small glowing white eyes, a smooth bald head. Draw him without any smoke or tendrils: only the clean body silhouette, so the proportions are easy to read.

Show five full-body views in one row, left to right, evenly spaced, all at the same height and scale: front, three-quarter front, side view facing right, three-quarter back, back.

Neutral A-pose: standing straight, arms held slightly away from the body, legs slightly apart.

Orthographic view with no perspective distortion, no ground shadow and no scenery. Transparent background.

The same style as the reference: crisp silhouette edges and an ink-wash texture. No text, labels, watermark or border.
```

## Must have

- Five consistent views of the same figure, at the same scale, in an A-pose.
- The eyes visible in the front and three-quarter-front views only.
- No smoke or tendrils anywhere.

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
| 1 | 2026-10-10T08:12Z | IMG-0004-v1.png, IMG-0004-v2.png | openai/gpt-image-2.5-flare | 3072x1024 / medium | 0.041 |
| 2 | 2026-10-10T08:44Z | IMG-0004-v3.png, IMG-0004-v4.png | openai/gpt-image-2.5-flare | 3072x1024 / medium | 0.041 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T08:13Z | Waiting for operator approval. | Clean body silhouettes, usable for modeling. Same build note as IMG-0003: more muscular than the concept. Revise together with IMG-0003 if the operator wants him leaner. |
| 1 | 2026-10-10T08:44Z | **revise** | Operator: make him leaner. Round 2 asks for a wiry, gaunt build with long limbs, narrow shoulders and almost no muscle definition. |
| 2 | 2026-10-10T08:48Z | Waiting for operator approval. Claude recommends **v4**; v3 is rejected. | v4 is a clean, lean body with consistent views, good for modeling. v3 added a tattered loincloth that wasn't asked for. |
| 2 | 2026-10-10T09:03Z | **accepted: v4** | Operator picked row 4 (v4). Copied to `art-source/style/unknown-turnaround-body.png`. |
