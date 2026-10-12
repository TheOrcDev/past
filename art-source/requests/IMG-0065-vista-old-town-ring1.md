# IMG-0065 — Vista: old town, ring 1

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, the area reveals

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Ring 1 of `old_town_reveal`: the centre of ring 0 repainted with twice the detail, centred on where Unknown stands. Geometry: `past-art reveal` (art-source/work/reveal/old_town_reveal/).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-sunburst",
  "size": "3072x1072",
  "quality": "high",
  "n": 2,
  "background": "opaque",
  "references": [
    "art-source/work/reveal/old_town_reveal/ring1_source.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
This image is a crop from a wide painting of a ruined gothic old town at night seen from the cathedral steps. Repaint it as a full-resolution painting of the same view. Keep the composition, the horizon, the shapes, the values and every object exactly where they are, so it lines up with the crop when scaled up.

Add the fine detail a closer view would show: worn flagstones and puddles on the landing, carved stone balustrades, gabled rooftops with slates and chimneys, cold pale lamps in narrow streets, wet cobblestones, drifting fog. The same monochrome greyscale ink-wash style as the source.

No people, figures or creatures. No text, watermark or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `past-art reveal` registers it onto its outer ring.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:04Z | IMG-0065-v1.png, IMG-0065-v2.png | openai/gpt-image-2.5-sunburst | 3072x1072 / high | 0.091 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T07:10Z | **accepted: v2** | Claude's pick (#29): registers onto its source at p90 2.47 px (v1: 3.29). |
