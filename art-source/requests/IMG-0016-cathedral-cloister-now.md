# IMG-0016 — The cathedral cloister, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P4)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room P4, `cathedral_cloister`: the Sister's cloister beside the nave. A doorway on the left leads back to the nave; a stair turret on the right climbs to the choir loft.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "opaque",
  "references": [
    "art-source/raw/IMG-0011/IMG-0011-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the square cloister walk of a ruined gothic cathedral at night, beside an overgrown garden, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: A gallery of pointed gothic arches on slender columns runs along the back, opening onto a square garden choked with dead roses that climb the columns. In the centre of the garden, a dry stone well with a broken iron winch, and to its right a cracked sundial on a pedestal. On the left, a small arched doorway leads back into the cathedral. On the right, a narrow round stair turret with an open arched doorway at its foot. The cathedral's tall windows and a spire loom above the arcade against the moonlit sky.

The lower third of the image is open, walkable ground: the flagstone cloister walk runs in front of the garden across the whole width. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The arcade, the garden with the dry well and sundial, the doorway on the left and the stair turret on the right.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It reads as part of the same cathedral as the nave.
- [ ] The doorway and turret read as exits.
- [ ] Unknown would read against the walk.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:06Z | IMG-0016-v1.png, IMG-0016-v2.png, IMG-0016-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v2** | Claude's pick (#29). v2 has the doorway on the left, the dry well and sundial in the garden, the stair turret with its door on the right, and an open, moonlit walk across the front. |
