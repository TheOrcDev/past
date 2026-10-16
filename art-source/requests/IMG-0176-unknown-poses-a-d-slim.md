# IMG-0176 — Unknown redesign: key poses A, front, slim

status: accepted
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 3 (key poses)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: the front and back sheets copied the mannequin's heavy build and cut the coat short (IMG-0163, IMG-0164). This round paints over guides squeezed to 80% width and asks for the coat to mid-calf. key drawings for Unknown's limited animation (standing still, two talking gestures, a two-handed explaining gesture, looking around over each shoulder and a thoughtful head tilt), painted over the old rig's poses. The game holds them in turn on the rig's timing.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "codex/gpt-6.1-sol",
  "size": "2560x1440",
  "quality": "high",
  "n": 3,
  "background": "transparent",
  "references": [
    "art-source/work/characters/unknown2/guides/sheets/poses_a_d.png",
    "art-source/raw/IMG-0157/IMG-0157-v2.png",
    "art-source/raw/IMG-0160/IMG-0160-v3.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit the first image. It is a pose guide: 8 separate poses in 2 rows of 4, each grey mannequin showing one key drawing of a 2D game character's actions (standing still, two talking gestures, a two-handed explaining gesture, looking around over each shoulder and a thoughtful head tilt). Repaint it as a finished sheet of key drawings of the living shadow from the model sheet (the second image): a slim, lean man in a long, fitted, torn greatcoat with a tall upturned collar, its ragged hem fraying into wisps of ink, slim trousers and pointed shoes, a messy swept-back shock of shadow hair, and two small round glowing white eyes; solid ink-black, with a bold brush outline, a thin silver moonlight rim line and sparse hatching, drawn halfway between an inked comic and a hand-drawn animated film, exactly as in the third image, a finished sheet of him, keeping the layout exactly as in the guide: the same 8 poses in the same cells, each with the same pose of the legs, feet, arms, hands, body and head as its mannequin, at the same place and size. He faces the viewer, seen from the front as in the guide, with both glowing eyes visible. Copy only the poses from the guide, never the mannequin's build: Unknown is much slimmer than the mannequin, with a narrow chest, thin arms and thin legs, as in the model sheet. His greatcoat is long in every view: it reaches to mid-calf, well below his knees, with its torn, fraying hem, exactly as long as in the side views of the third image; only his lower legs and shoes show beneath it. Draw him identically in all 8 poses, as a professional animator would draw the keys of one character, so that they can be played in sequence: the same proportions, coat, collar, hair, line weight and hatching throughout. His coat and hair follow each pose naturally: the coat hangs and folds as he bends or reaches, and the hem drapes on the ground when he crouches.

Every figure is whole from hair to shoes and stays inside its own cell, at the same place and size as its mannequin, with clear empty space between neighbouring figures so none touch. Replace the grey background with full transparency: a fully transparent background, with no ground, cast shadow, smoke or scenery. No text, numbers, labels, grid lines or borders.
```

## Must have

- The guide's 8 poses in its layout, painted as IMG-0157 v2

## Must not have

- The mannequin's heavy build
- Figures touching, text or grid lines

## Acceptance criteria

Claude checks these.

- [ ] Each pose matches its guide
- [ ] The design matches across the 8 drawings and IMG-0160 v3
- [ ] The coat reaches mid-calf, as in the side views

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-16T05:22Z | IMG-0176-v1.png, IMG-0176-v2.png, IMG-0176-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-16T05:27Z | **accepted: v1** | Claude's pick (#29): long coat, slim, and the gestures read from the front. |
