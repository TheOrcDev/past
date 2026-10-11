# IMG-0013 — NPC: the Gravedigger

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 3 (the NPC route)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The Gravedigger (`docs/story/cast.md`), the first NPC and plan 008 slice 3's proof of the NPC route: one painting on a transparent background, deformed in Godot by a Skeleton2D (RigBody). He stands by the open graves in `cemetery_gate` and inside `sexton_lodge`.

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
    "art-source/raw/IMG-0011/IMG-0011-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A single full-body character for a dark gothic point-and-click adventure game, painted in the same monochrome greyscale ink-wash matte-painting style as the reference image: the old Gravedigger of a ruined cemetery: short, broad and heavy-set, in a long heavy patched coat with a deep hood pulled forward, thick gloves, mud-caked boots, a scarf wound at his throat, leaning slightly on a long-handled spade planted beside him.

They are a grey shade of a person: solid, made of mid and light greys with soft ink texture, never pure black, with no visible face (his face is lost in the deep shadow of his hood; only the tip of a nose and a grizzled beard edge catch a little light). Pose: standing, slightly stooped, his left hand resting on top of the spade's handle beside him, his right arm hanging relaxed at his side, his head a little forward. Shown whole from head to feet, facing three-quarters to the viewer's left, filling most of the image height, with a little space around them. Even soft light from the upper left with a gentle cool rim light. On a fully transparent background, with no ground, shadow or scenery.

No text, labels, letters or numbers. No other figures. No watermark, signature or border.
```

## Must have

- A clearly readable outline: hood, broad back, spade.
- Mid and light greys, not black.
- A fully transparent background around the whole figure.

## Must not have

- A face with eyes or mouth.
- Ground, shadow, scenery, text or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The figure is whole, from hood to boots, with nothing cropped.
- [ ] The arms and head are separate enough from the body to bend with a few bones.
- [ ] It reads as grey against the dark cemetery, and different from Unknown's black.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T21:54Z | IMG-0013-v1.png, IMG-0013-v2.png, IMG-0013-v3.png | codex/gpt-6.1-sol | 1440x2560 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-11T23:55Z | **accepted: v2** | Claude's pick (decision #29). All three are whole, grey (not black), hooded and faceless with a real transparent background, 1024×1536. v2's hanging right arm stands clear of the coat, which bends best, and its lighter grey reads against the dark cemetery. He faces right, the convention the Actor mirrors from. |
