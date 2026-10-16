# IMG-0172 — Unknown redesign: key poses B, back

status: cancelled
operator-approval: not-required
plan: 010
requested: 2026-10-16 by Claude for plan 010, slice 3 (key poses)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Plan 010: key drawings for Unknown's limited animation (reaching out to use something, handing something over, a startled flinch and a hand raised to his chin), painted over the old rig's poses. The game holds them in turn on the rig's timing.

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
    "art-source/work/characters/unknown2/guides/sheets/poses_b_u.png",
    "art-source/raw/IMG-0157/IMG-0157-v2.png",
    "art-source/raw/IMG-0160/IMG-0160-v3.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit the first image. It is a pose guide: 8 separate poses in 2 rows of 4, each grey mannequin showing one key drawing of a 2D game character's actions (reaching out to use something, handing something over, a startled flinch and a hand raised to his chin). Repaint it as a finished sheet of key drawings of the living shadow from the model sheet (the second image): a slim, lean man in a long, fitted, torn greatcoat with a tall upturned collar, its ragged hem fraying into wisps of ink, slim trousers and pointed shoes, a messy swept-back shock of shadow hair, and two small round glowing white eyes; solid ink-black, with a bold brush outline, a thin silver moonlight rim line and sparse hatching, drawn halfway between an inked comic and a hand-drawn animated film, exactly as in the third image, a finished sheet of him, keeping the layout exactly as in the guide: the same 8 poses in the same cells, each with the same pose of the legs, feet, arms, hands, body and head as its mannequin, at the same place and size. He faces away from the viewer, seen from behind as in the guide, so his eyes are not visible: we see the back of his hair, the tall collar and the long back of the coat with its split tail. Copy only the poses from the guide, never the mannequin's build: Unknown is much slimmer than the mannequin, with a narrow chest, thin arms and thin legs, as in the model sheet. Draw him identically in all 8 poses, as a professional animator would draw the keys of one character, so that they can be played in sequence: the same proportions, coat, collar, hair, line weight and hatching throughout. His coat and hair follow each pose naturally: the coat hangs and folds as he bends or reaches, and the hem drapes on the ground when he crouches.

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

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
