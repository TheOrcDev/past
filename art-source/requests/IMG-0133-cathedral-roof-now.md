# IMG-0133 — The cathedral roof, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (room 1)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 1 of chapter 4, `cathedral_roof` (`docs/story/atlas.md`, `docs/story/ch4-puzzles.md`).

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
    "art-source/raw/IMG-0064/IMG-0064-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: a walkway along the lead roof ridge of a huge gothic cathedral, high above a city at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: The roof ridge runs from the left foreground into the distance, flanked by carved stone pinnacles. On the left, the arched door of the covered bridge opens onto the roof. Loose stones and broken slates lie along the ridge; one large loose block of stone sits by itself near the centre. Beyond, the entire grey city spreads out far below in fog, and on the right the great belfry tower rises out of frame.

The lower third of the image is open, walkable ground: the flat lead walkway along the ridge runs across the lower third. It is lit by a huge full moon with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The bridge door on the left, the loose stone block near the centre, the city below, the belfry on the right.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the heights' reveal (IMG-0064 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:22Z | IMG-0133-v1.png, IMG-0133-v2.png, IMG-0133-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v3** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
