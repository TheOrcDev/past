# IMG-0047 — Inside the clock, then (the apprentice's memory)

status: accepted
operator-approval: not-required
plan: 008
requested: 2026-10-11 by Claude for plan 008, slice 5 (room 10, then)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

The past layer of `clockworks`, an edit of IMG-0041 v1, where the playable memory "The apprentice" happens. Its clue is a chalk note beside the escapement.

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
    "art-source/raw/IMG-0041/IMG-0041-v1.png"
  ],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
Edit this image in place. Keep exactly the same composition, camera, perspective, horizon and every shape where it stands: every gear and wheel, the pendulum, the escape wheel and its anchor, the winding post, the ladder, the trapdoor and the gallery floor. Only change the time and the condition.

Restore the same clockworks to how it looked decades earlier, when the clock ran, in full rich warm color, as a painterly gothic matte painting: polished brass gears gleaming, the escapement whole and engaged, warm oil lamps hanging along the gallery, a tidy apprentice's workbench, sawdust on the boards, warm sunset light through the clock face's glass. On the wooden beam right beside the escape wheel, a hand-chalked note reading exactly: THIRD TOOTH The key light comes from the same direction as in the original.

No people, figures, animals or creatures. No readable text, letters or numbers. No watermark, signature or border.
```

## Must have

- What the purpose describes, in the game's style.

## Must not have

- Figures, readable text, or a frame.

## Acceptance criteria

Claude checks these.

- [ ] `align` p90 ≤ 3 px against IMG-0041 v1.
- [ ] The chalk note reads THIRD TOOTH.

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-11T22:59Z | IMG-0047-v1.png, IMG-0047-v2.png | codex/gpt-6.1-sol | 2560x1440 / high | 0 (ChatGPT plan) |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-12T05:30Z | **accepted: v1** | Claude's pick (#29), reviewed on contact sheets with the others; then-edits checked with `align` (all chapter 1 thens p90 1.02–2.02 px). It is the variant traced and built into the game (`art-source/work/`). |
