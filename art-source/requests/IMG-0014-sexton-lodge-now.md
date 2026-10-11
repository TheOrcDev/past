# IMG-0014 — The Gravedigger's lodge, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 4 (room P2)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room P2, `sexton_lodge` (`docs/story/atlas.md`): inside the Gravedigger's lodge. The burial register on its lectern opens the `burial_register` close-up; the key wall gives the ossuary key. The Gravedigger stands here as a layer once he's met.

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
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the cramped interior of an old cemetery gatekeeper's stone lodge at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: On the left, a cold cast-iron stove with a crooked flue pipe, and beside it a narrow cot with a rumpled blanket. Along the back wall, a long wooden board hung with dozens of old iron keys on hooks, and above it shelves of old, dead lanterns. On the right, under a small leaded window letting in moonlight, a tall wooden lectern holding a huge open ledger. In the left wall, a heavy wooden door stands ajar onto the night fog.

The lower third of the image is open, walkable ground: a worn flagstone floor runs across the whole width of the room, clear of furniture in the middle. It is lit by pale moonlight from the window on the right and a faint glow of fog through the door with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The stove and cot on the left, the key board and lantern shelves at the back, the lectern with an open ledger under the window on the right, a door ajar on the left.
- A clear flagstone floor across the lower third.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches the nave's monochrome ink-wash style.
- [ ] The lectern, key board, stove, lanterns and door can each be a hotspot.
- [ ] Unknown would read against the floor.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:03Z | IMG-0014-v1.png, IMG-0014-v2.png, IMG-0014-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T00:40Z | **accepted: v2** | Claude's pick (#29). v2 has the clearest layout for the room: the door ajar and the stove on the left, the cot and key board at the back, the lectern with its open ledger under the window on the right, and the most open, lightest floor. |
