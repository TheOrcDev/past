# IMG-0082 — On the aqueduct, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 6 (room 10)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 10 of chapter 2, `aqueduct_channel` (`docs/story/atlas.md`, `docs/story/ch2-puzzles.md`).

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
    "art-source/raw/IMG-0062/IMG-0062-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the top of a long ruined stone aqueduct high above a drowned city at night, seen along its dry water channel, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: The dry stone channel runs from the left foreground toward the right; in the middle distance a whole span of the aqueduct has collapsed, leaving a gap with a sheer drop between two broken ends. Beyond the gap, at the far right, a squat stone valve house with a heavy iron-bound door stands on the aqueduct. Below on the left, a wide view over the drowned quarter: rooftops in water, the chapel spire, the hospice on stilts, moonlight on the flood.

The lower third of the image is open, walkable ground: the dry channel's floor and its low parapet run across the lower third up to the gap. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The dry channel, the collapsed gap, the valve house beyond it on the right, the view over the drowned quarter on the left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the drowned quarter's reveal (IMG-0062 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T00:30Z | IMG-0082-v1.png, IMG-0082-v2.png, IMG-0082-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T09:40Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits and clean plates checked with `align` (chapter 2: p90 1.14–2.35 px). It is the variant traced and built into the game (`art-source/work/`). |
