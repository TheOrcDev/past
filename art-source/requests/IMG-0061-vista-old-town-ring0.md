# IMG-0061 — Vista: the old town, ring 0

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, the area reveals

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Ring 0 of chapter 1 (the old town)'s discovery reveal (`art-pipeline.md` §5B): the widest view the pull-back ends on. Rings 1 and 2 are 2× repaints of its centre. 3:1, so through the gateway (decision #47).

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
    "art-source/raw/IMG-0027/IMG-0027-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A very wide panorama at night from the top of a great gothic cathedral's west steps, looking down over a whole ruined old town: in the lower left foreground the broad worn top step and the edge of the cathedral square, an open flat landing a little left of centre in the lower half; beyond it, a sea of steep gabled rooftops, chimneys and narrow streets lit by cold pale lamps, a sloping market square with a fountain, arched stone bridges over black canals, and a massive clock tower with a great round clock face rising right of centre. On the far right, the land falls away to a fog-drowned lower quarter with the arches of an aqueduct marching into the mist. A full moon behind thin clouds, spires everywhere dissolving into fog. The figure-free spot described stays clearly lit so a small black figure would read there. Monochrome greyscale ink-wash gothic matte painting, heavy layered fog between depth planes, strong rim light on silhouettes, exactly the style of the reference image. No people, figures or creatures. No readable text, watermark or border.
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
| 1 | 2026-10-12T00:02Z | IMG-0061-v1.png, IMG-0061-v2.png | openai/gpt-image-2.5-flare | 3072x1072 / high | 0.091 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T07:10Z | **accepted: v2** | Claude's pick (#29): the cathedral steps' landing is clear, lit and a little left of centre; the clock tower and aqueduct read. |
