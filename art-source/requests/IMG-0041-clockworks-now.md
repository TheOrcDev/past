# IMG-0041 — Inside the clock, now

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 10)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 10 of chapter 1, `clockworks` (`docs/story/atlas.md`, `docs/story/ch1-puzzles.md`).

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
    "art-source/raw/IMG-0014/IMG-0014-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the inside of a great clock tower's mechanism at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: Towering iron gears and wheels of every size fill the space, meshed into each other; a huge pendulum hangs still in the centre. On the right, the escapement: a large toothed escape wheel with its anchor and pallet pin hanging loose, and beside it a square iron winding post. Pale light falls through the backs of the clock face's glass high above. A wooden ladder on the left climbs up to a high gallery; an open trapdoor in the floor at the left.

The lower third of the image is open, walkable ground: a wooden gallery floor runs in front of the machinery across the whole width. It is lit by shafts of pale moonlight through the clock face's glass with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- Huge meshed gears, the still pendulum, the escape wheel and loose pin and the winding post on the right, the ladder and trapdoor on the left.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It matches chapter 1's style key (IMG-0027 v1).
- [ ] Every object the chart names can be a hotspot.
- [ ] Unknown would read against the ground.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:54Z | IMG-0041-v1.png, IMG-0041-v2.png, IMG-0041-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
