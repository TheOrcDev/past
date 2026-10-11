# IMG-0015 — The ossuary, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P3)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room P3, `ossuary`: the crypt beneath the cemetery chapel. The lantern glass is in the crow's nest on the high ledge (a pickup_high); a blank plaque opens the vision "The edict" and the `ossuary_niche` close-up.

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
    "art-source/style/cathedral-nave-now-style-key.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: a low vaulted crypt beneath a cemetery chapel: an ossuary, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: The side walls are built of stacked skulls and long bones in neat rows. Along the back wall, three tiers of small arched burial niches, each with a small stone name plaque scraped smooth and blank. Stubs of melted candles stand on ledges. High on the right, on a stone ledge just below the vault, a crow's nest of twigs glinting with small scraps of metal and glass. On the left, a narrow stone stair climbs up to a heavy wooden door.

The lower third of the image is open, walkable ground: the crypt's stone floor is clear and open in the middle. It is lit by a pale shaft of moonlight falling from an iron grate in the vault onto the floor with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Skull walls, three tiers of niches with blank plaques at the back, the crow's nest high on the right, the stair and door on the left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The crow's nest is clearly visible and reachable-looking from the floor.
- [ ] The stair and door read as the way out.
- [ ] Unknown would read against the lit floor.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:05Z | IMG-0015-v1.png, IMG-0015-v2.png, IMG-0015-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v1** | Claude's pick (#29). All three have the stair and door on the left, three tiers of blank niches and skull walls. v1's crow's nest is clear on the high right ledge and its moonlit floor is the widest. |
