# IMG-0063 — Vista: the upper city, ring 0

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, the area reveals

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Ring 0 of chapter 3 (the upper city)'s discovery reveal (`art-pipeline.md` §5B): the widest view the pull-back ends on. Rings 1 and 2 are 2× repaints of its centre. 3:1, so through the gateway (decision #47).

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
A very wide panorama at night over a severe gothic upper city of power: in the lower left foreground the start of a grand straight avenue of flagstones, with an open lit stretch a little left of centre in the lower half, and a tall plinth with a headless statue of a robed magistrate; beyond, tall stern buildings with columns, a baroque theatre with a dark marquee, a bare square with a gallows, and at the end of the avenue a vast fortress-like Hall of Records with endless rows of dark windows and a great gate. Far right, a covered stone bridge leads up to a cathedral's towering roofs and belfry. Moon behind clouds, fog between the buildings. The figure-free spot described stays clearly lit so a small black figure would read there. Monochrome greyscale ink-wash gothic matte painting, heavy layered fog between depth planes, strong rim light on silhouettes, exactly the style of the reference image. No people, figures or creatures. No readable text, watermark or border.
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
| 1 | 2026-10-12T00:02Z | IMG-0063-v1.png, IMG-0063-v2.png | openai/gpt-image-2.5-flare | 3072x1072 / high | 0.091 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T07:10Z | **accepted: v1** | Claude's pick (#29): the lit avenue, headless statue, theatre, gallows and Hall of Records all read. |
