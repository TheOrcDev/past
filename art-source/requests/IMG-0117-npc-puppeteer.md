# IMG-0117 — NPC: the Puppeteer

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-12 by Claude for plan 008, slice 7 (NPC)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Puppeteer (`docs/story/cast.md`), on the stage of `theater_stage`. Skinned (decision #49).

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
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the Puppeteer: a slender woman in a dramatic cape cut like a stage curtain with tassels, a theatrical half-mask over her eyes, a glove puppet on each hand: a robed magistrate and a little veiled dove.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (the half-mask and the shadow of her hood hide her face). Pose: standing theatrically with both puppet hands raised at shoulder height as if mid-performance, facing three-quarters to the viewer's right. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] Whole, facing right, on transparency.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-12T01:01Z | IMG-0117-v1.png, IMG-0117-v2.png, IMG-0117-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T14:30Z | **accepted: v2** | Claude's pick (#29), reviewed on contact sheets; then-edits checked with `align` (chapter 3: p90 1.10–1.59 px). It is the variant traced and built into the game (`art-source/work/`). |
