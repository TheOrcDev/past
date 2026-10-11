# IMG-0017 — The choir loft, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P5)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room P5, `choir_loft`: the gallery above the nave. The hymn book on the one upright stand opens the `hymn_book` close-up and the vision "The singer".

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
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the choir loft of a ruined gothic cathedral: a high wooden gallery above the nave, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: On the left, a towering wall of tall organ pipes, dusty and some bent, above a wooden organ console with broken keys. Across the middle, toppled wooden music stands lie on the floor; one music stand still stands upright near the centre, holding a single open hymn book. On the right, a carved stone balustrade at the gallery's edge looks out over the vast ruined nave below, with shafts of moonlight and a broken rose window far away. Torn banners hang from the vault. A small arched doorway at the far left leads to a stair down.

The lower third of the image is open, walkable ground: the gallery's wooden floor runs across the whole width in front of the stands. It is lit by shafts of pale moonlight from the nave's windows with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Organ pipes and console on the left, the one upright stand with an open book near the centre, the balustrade over the nave on the right, a doorway on the far left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The upright stand and its book are the clear focus.
- [ ] Unknown would read against the floor.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:03Z | IMG-0017-v1.png, IMG-0017-v2.png, IMG-0017-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v3** | Claude's pick (#29). v3 has the organ and the stair doorway on the left, the one upright stand with its open book at the centre, the balustrade over the nave, and a moonlit floor that Unknown reads against. The balustrade runs across the back rather than at the right edge, which suits the room. |
