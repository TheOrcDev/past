# IMG-0002 — Cathedral nave, now (A/B: Sunburst)

status: delivered
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for plan 002, slice 1

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The playable cathedral nave in the present. It is the first room of the
cathedral area, so it becomes that area's style key, and later the base for the
"then" edit. It is also half of the model A/B: IMG-0001 runs the same prompt on
Flare.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-sunburst",
  "size": "2560x1440",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["docs/reference/concept-02-cathedral-now.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Repaint this scene as an empty, playable background for a point-and-click adventure game, keeping its exact art style: a monochrome greyscale gothic dark-fantasy matte painting with an ink-wash texture, heavy volumetric fog between the depth planes, strong black silhouettes in the foreground and soft light shafts falling through the rose window.

Keep the same ruined cathedral nave, the same camera and broadly the same composition: an eye-level camera with the horizon about halfway up the frame, the rose window and the altar at the back as landmarks, and the saint statue on its pedestal at the left.

Change these things:
- Remove the walking figure completely. There are no people, creatures or characters anywhere in the image.
- Make the lower third of the frame a clear, walkable stone floor of cracked flagstones with shallow puddles, running from the left edge to the right edge, with rubble only at its edges.
- Set that floor against pale fog, so a black silhouette standing on it reads clearly. The darkest blacks belong in the foreground framing at the sides and in the top corners, never behind the floor.
- Give the saint statue a faint rim light so it reads as an object someone can look at.

Pure greyscale, no color at all. No text, no watermark, no border.
```

## Must have

- The same art style as concept 02: greyscale, ink-wash texture, fog, black silhouettes.
- An empty, walkable floor across the lower third, against pale fog.
- The saint statue at the left, the altar and the rose window at the back.

## Must not have

- Any figure, person or creature.
- Color, text, a watermark or a frame.

## Acceptance criteria

Claude checks these.

- [ ] There are no characters anywhere, checked by zooming in.
- [ ] The walkable floor spans the frame and its median luminance is mid to light (the `grade` check).
- [ ] The statue, altar and rose window read as distinct objects at 1080p.
- [ ] The look matches concept 02 side by side; the operator approves the style key.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T08:11Z | IMG-0002-v1.png, IMG-0002-v2.png | openai/gpt-image-2.5-sunburst | 2560x1440 / medium | 0.056 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T08:13Z | Waiting for operator approval. Not recommended as the style key. | It stays closer to concept 02's composition, keeping the pews and mid-ground rubble, which gives a busier, less playable floor (v1's floor band averages 64/255). That supports using Sunburst for precise edits (then-versions, clean plates) and Flare for new images. |
