# IMG-0132 — The Registrar's chamber, then

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (room 10, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `registrar_chamber`, an edit of IMG-0113-v2. The vision "The first entry" plays over it.

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
    "art-source/raw/IMG-0113/IMG-0113-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: the narrow door, the standing desk, the wall of pigeonholes, the round vault door with its dials, the window and the floor. Only change the time and the condition.

Restore the same chamber to how it looked decades earlier, on the day a new clerk started work, in full rich warm color, as a painterly gothic matte painting: the chamber freshly built and gleaming: polished brass dials on the vault door, the pigeonholes empty and new, a new standing desk with a vase of flowers and a fresh ledger, lamps lit warm, morning sunlight through the window. The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0113-v2.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:15Z | IMG-0132-v1.png, IMG-0132-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
