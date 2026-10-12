# IMG-0027 — The cathedral square, now (chapter 1 style key)

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (chapter 1 style key)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 1 of chapter 1, `cathedral_parvis` (atlas), and chapter 1's style key: the square before the cathedral's west front where the great doors open onto the old town. The Crier stands on his platform as a layer.

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
Paint a NEW scene (do not copy the reference's layout) in exactly the same monochrome greyscale ink-wash gothic matte-painting style as the reference image: the broad cobbled square in front of a great gothic cathedral's west front, in a ruined old town at night, seen from eye level, slightly above, for a point-and-click adventure game background.

Composition: On the far left, the cathedral's massive carved west front rises out of the top of the frame, with its huge pair of carved wooden doors at the top of a few wide steps, standing ajar. Left of centre, a raised wooden crier's platform with a tall iron post and a bracket for a handbell. To the right, a dry stone horse trough. Narrow streets leave the square between tall, leaning gothic houses with steep gables: one street behind the platform lined with iron lamp posts, and one narrow stepped alley at the right edge. Beyond the rooftops, a tall clock tower with a large round clock face, and other spires dissolving into fog.

The lower third of the image is open, walkable ground: the cobbled square runs across the whole width, open and clear. It is lit by pale moonlight with drifting fog or haze behind it, so that a black figure standing on it would read clearly. Strong rim light on silhouettes and layered fog, as in the reference. Dark framing only in the top corners and the extreme foreground edges.

No people, figures, animals or creatures. No readable text, letters or numbers anywhere. No watermark, signature or border.
```

## Must have

- The cathedral's doors on the left, the crier's platform, the trough, the lamp-lined street and the alley, the clock tower beyond.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] It reads as the same world as the cemetery and the nave.
- [ ] The doors, platform, trough, street and alley can each be a hotspot or exit.
- [ ] Unknown would read against the cobbles.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:51Z | IMG-0027-v1.png, IMG-0027-v2.png, IMG-0027-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
