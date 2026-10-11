# IMG-0000 — <title>

status: open
operator-approval: not-required
plan: 002
requested: <YYYY-MM-DD> by Claude for plan <NNN>, slice <N>

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request.

## Purpose

Where this image is used in the game and what it has to do there.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-flare",
  "size": "2560x1440",
  "quality": "medium",
  "n": 3,
  "background": "opaque",
  "references": [],
  "mask": null
}
```

- **`model`:** `codex/gpt-6.1-sol` sends the request to Sol (decision #47).
  It returns 1672×941 images whatever `size` says (`size` then only sets
  the shape), and it can't take a mask.
- **`references`:** repository paths of input images. With references, the call
  is an edit. Use `openai/gpt-image-2.5-sunburst` for edits.
- **`mask`:** optional. A PNG with alpha, the same size as the first reference,
  transparent where the image may change.
- **`size`:** both sides must be multiples of 16, with an aspect between 1:3 and
  3:1. Rooms use 2560×1440.
- **`background`:** `opaque`, or `transparent` for cut-outs, character sheets
  and UI art.

## Prompt

The tool sends this text block verbatim.

```text
…
```

## Must have

- …

## Must not have

- …

## Acceptance criteria

Claude checks these.

- [ ] …

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
