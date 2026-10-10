# IMG-0009 — Cemetery: Unknown's grave, now

status: accepted
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for the operator's grave opening (plan 007)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request (plan 002's, with the operator's request).

## Purpose

The first playable room (operator request, 2026-10-10): the game starts in the
cemetery by Unknown's own grave. Clicking the gravestone opens a close-up
(IMG-0010) where only the first letter of the name, a "U", survives above the
words "I know you are happy now. Your dove". It must match the cemetery vista
of the opening reveal (IMG-0006) and follow the room composition rules
(`art-pipeline.md` §3).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-flare",
  "size": "2560x1440",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["art-source/raw/IMG-0006/IMG-0006-v1.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a new scene in exactly the same monochrome greyscale ink-wash gothic style as the reference image: a quiet corner of the same old cemetery at night under a pale moon, seen from eye level, slightly above, for a point-and-click adventure game.

Composition: in the middle ground, a little left of centre, a single weathered upright gravestone stands at the head of a sunken, overgrown grave. The stone is tall and arched, broken off at one upper corner, cracked across its face and half covered in moss; nothing on it can be read from this distance. A small worn dove is carved at the top of the arch. Around and behind it: leaning tombstones, a rusted iron fence, a stone angel with lowered head, a mausoleum, bare twisted trees, and far away the cathedral city's spires dissolving into fog.

The lower third of the image is open, walkable ground: a cracked flagstone path enters from the left edge, passes in front of the grave and leaves at the right edge towards the distant city, with damp earth and low dead grass on either side. That ground is lit by pale moonlight with drifting fog behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The reference's monochrome ink-wash style and moonlit fog.
- One clear, prominent gravestone a little left of centre, at the head of a grave, unreadable from here, with a small dove carved at the top.
- An open, light walkable band across the lower third, with exits to the left and right.

## Must not have

- Figures, color, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It reads as the same cemetery as the reveal's vista.
- [ ] The gravestone is the clear focus and could carry an inscription in a close-up.
- [ ] Unknown, a black silhouette, would read against the walkable band (luminance of the band and behind it).
- [ ] The operator likes it (review after the fact, decision #29).

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T20:21Z | IMG-0009-v1.png, IMG-0009-v2.png | openai/gpt-image-2.5-flare | 2560x1440 / medium | 0.056 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T20:45Z | **accepted: v1** | Claude's pick (decision #29). Both match the vista's ink-wash style, moon and fog. v1's arched gravestone, with its carved dove, is the clear focus left of centre, and the moonlit path across the bottom is open walkable ground. v2 frames the stone well but puts a foreground fence across the walkable band. |
