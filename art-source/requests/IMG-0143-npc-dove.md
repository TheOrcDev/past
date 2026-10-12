# IMG-0143 — NPC: the Dove

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 8 (NPC)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Dove, Elise (`docs/story/cast.md`), in `dovecote`, `dove_room` and the epilogue. One painting, skinned (decision #49); she keeps a trace of color (`keep_color`).

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "1440x2560",
  "quality": "high",
  "n": 3,
  "background": "transparent",
  "references": [
    "art-source/raw/IMG-0013/IMG-0013-v2.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the Dove: a slight, graceful woman in a long simple choir singer's gown and a long flowing veil over her head and shoulders; the veil is a very faint, soft blue, the only hint of color on her. A small white dove perches on her raised right hand.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (her face is hidden behind her veil, turned slightly toward the dove). Pose: standing gently, her right hand raised at shoulder height with the dove on it, her left hand at her side holding the veil's edge, facing three-quarters to the viewer's right. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Whole, facing right, on transparency.
- [ ] The veil is the faintest blue; everything else grey.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:25Z | IMG-0143-v1.png, IMG-0143-v2.png, IMG-0143-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T16:40Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 4: p90 1.42–1.85 px). It is the variant traced and built into the game (`art-source/work/`). |
