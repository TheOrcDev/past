# IMG-0064 — Vista: the whole city from the cathedral roof, ring 0

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, the area reveals

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Ring 0 of chapter 4 (the heights)'s discovery reveal (`art-pipeline.md` §5B): the widest view the pull-back ends on. Rings 1 and 2 are 2× repaints of its centre. 3:1, so through the gateway (decision #47).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-flare",
  "size": "3072x1072",
  "quality": "high",
  "n": 2,
  "background": "opaque",
  "references": [
    "docs/reference/concept-01-cemetery-vista.png",
    "art-source/raw/IMG-0027/IMG-0027-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A very wide panorama at night from high on a gothic cathedral's lead roof: in the lower left foreground a walkway along the roof ridge between stone pinnacles and gargoyles, an open lit stretch a little left of centre in the lower half; below and beyond, the entire city spread out: the old town's rooftops and clock tower, the drowned quarter and its aqueduct in the far fog, the severe upper city with its Hall of Records, and the hilltop cemetery. On the right, the cathedral's great belfry tower and a small round dovecote on the roof. A huge full moon, layered fog over the whole city. The figure-free spot described stays clearly lit so a small black figure would read there. Monochrome greyscale ink-wash gothic matte painting, heavy layered fog between depth planes, strong rim light on silhouettes, exactly the style of the reference image. No people, figures or creatures. No readable text, watermark or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It reads as the same world as the area's rooms.
- [ ] The spot where Unknown stands is clear and light, a little left of centre and in the lower half.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:02Z | IMG-0064-v1.png, IMG-0064-v2.png | openai/gpt-image-2.5-flare | 3072x1072 / high | 0.115 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T07:10Z | **accepted: v1** | Claude's pick (#29): the roof walkway with its gargoyles, the whole city, the belfry and dovecote all read. |
