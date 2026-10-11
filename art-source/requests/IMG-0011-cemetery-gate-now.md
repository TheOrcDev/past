# IMG-0011 — Cemetery gate and the Gravedigger's lodge, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 0 (the Sol spike) and slice 4 (room P1)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room P1, `cemetery_gate` (`docs/story/atlas.md`): the cemetery's main gate,
with the Gravedigger's lodge and a row of freshly dug, empty graves. It is
also plan 008's Sol spike: the first image GPT-6.1 Sol makes for the game
through Codex (decision #44), measured for size, style and its then-edit
(IMG-0012).

The Gravedigger stands by the graves as a separate layer. His lantern pole is
in the earth beside them.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "opaque",
  "references": ["art-source/raw/IMG-0009/IMG-0009-v1.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the main gate of the same old hilltop cemetery at night under a pale moon, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: on the left third, a small stone gatekeeper's lodge with a steep slate roof, a crooked chimney, a dark arched door facing us and one small dark window. In the centre background, a tall wrought-iron cemetery gate between two stone posts topped with stone urns; one leaf of the gate hangs off its hinge, and beyond the gate the road dissolves into thick fog. On the right, in the middle ground, a neat row of four freshly dug, empty rectangular graves with mounds of dark earth beside them, and a tall wooden pole planted in one mound with an empty iron lantern frame hanging from it. Behind them, leaning tombstones, bare twisted trees, a small chapel with stone steps leading down into a crypt door, and far away the cathedral city's spires in the fog.

The lower third of the image is open, walkable ground: a wide gravel path runs from the lodge door across the whole width of the image to the right edge, passing in front of the gate and the graves, lit by pale moonlight with drifting fog behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The reference's monochrome ink-wash style, moon and fog.
- The lodge with a door on the left, the gate in the centre, and the row of
  open graves with the lantern pole on the right.
- A light, open walkable band across the lower third, with an exit at the
  right edge.

## Must not have

- Figures, color, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It reads as the same cemetery as IMG-0009 and the vista.
- [ ] The lodge door, the gate, the graves and the crypt steps are each
      clear enough to be a hotspot.
- [ ] Unknown would read against the walkable band.
- [ ] Measured for the spike: pixel size, time per image, prompt sent
      verbatim, files only where they belong.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T21:39Z | IMG-0011-v1.png, IMG-0011-v2.png, IMG-0011-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-11T21:45Z | **accepted: v1** | Claude's pick (decision #29). All three match IMG-0009's ink-wash style, moon, fog and city. v1 has the widest, lightest path across the lower third, the lodge door with its steps clear on the left, the gate centred, the open graves and lantern pole, and the chapel's crypt steps upper right. v2 crowds the graves into the foreground; v3 darkens the left foreground with tombstones. Spike: 1672×941 per image, ~40 s each, only the raws, ledger and request changed. |
