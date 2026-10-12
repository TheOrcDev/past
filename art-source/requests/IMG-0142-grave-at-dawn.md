# IMG-0142 — The grave at dawn (the epilogue)

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (room 10, the epilogue)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Room 10 of chapter 4, `grave_at_dawn` (atlas): the epilogue. The same composition as the grave (IMG-0009 v1), at dawn and in full color, the stone recut with the name. It is the game's last room and has no now/then pair: it is the color.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 2,
  "background": "opaque",
  "references": [
    "art-source/raw/IMG-0009/IMG-0009-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective and every shape where it stands: the gravestone, the grave, the angel, the mausoleum, the trees, the path and the distant city. Restore the whole scene to full, rich, warm color at sunrise: a golden-pink dawn sky in place of the moon, warm early sunlight raking from the right, dew on green grass, wildflowers, the city's spires gleaming gold and blue in the distance. The gravestone is clean and whole, its broken corner mended, and its name line freshly recarved in deep classic Roman capitals reading exactly: ULRIC. No other text or numbers. No people, figures or animals other than a single small white dove perched on top of the gravestone. No watermark or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0009 v1.
- [ ] The stone reads exactly ULRIC; one white dove on it.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:23Z | IMG-0142-v1.png, IMG-0142-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
