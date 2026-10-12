# IMG-0055 — Close-up: the edict board

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (close-up)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The `edict_board` close-up in `alley_of_doors`: the High Magistrate's notices. Hotspots: the main edict, the posting time, the seals.

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
    "art-source/raw/IMG-0038/IMG-0038-v3.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the wooden notice board of edicts from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: the weathered notice board fills the frame: several pinned paper proclamations, curling and water-stained, each closed with the same worn wax seal. The largest notice, in the middle, is clear and legible.

On the largest notice, in old printed capitals, exactly:
BY ORDER OF THE HIGH MAGISTRATE
A NAME IS A PRIVILEGE, NOT A RIGHT
and beneath it, in smaller italic print, exactly:
Posted at the eleventh bell

Every other notice is illegible. No people or figures. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] The main notice reads exactly as written.
- [ ] Wax seals on the notices.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T23:04Z | IMG-0055-v1.png, IMG-0055-v2.png, IMG-0055-v3.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v3** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
