# IMG-0148 — Close-up: the gravestone, recut at dawn

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `gravestone_restored` close-up in `grave_at_dawn`: the tombstone close-up (IMG-0010 v1) at dawn, in color, the name recut.

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
    "art-source/raw/IMG-0010/IMG-0010-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same stone, its shape, its crack, the carved dove at the top, and the composition. Turn the scene to full warm color at sunrise: golden-pink dawn light on the stone, green moss, wildflowers at its foot, a soft blue sky behind. The shattered name line is now freshly and cleanly recarved in deep classic Roman capitals reading exactly: ULRIC. The two lines below stay exactly as they are: I KNOW YOU ARE HAPPY NOW. and YOUR DOVE. No other text. A single small white dove perches on top of the stone. No people, no watermark or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] ULRIC reads exactly; the inscription is unchanged.
- [ ] Warm dawn color.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:29Z | IMG-0148-v1.png, IMG-0148-v2.png, IMG-0148-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
