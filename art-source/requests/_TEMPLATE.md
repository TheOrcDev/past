# IMG-0000 — <title>

status: open
operator-approval: not-required
requested: <YYYY-MM-DD> by Claude for plan <NNN>, slice <N>

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required.

## Purpose

Where this image is used in the game and what it has to do there.

## Output

- Variants: 3
- Aspect and size: 16:9, the largest size the tool offers
- Background: an opaque scene, or flat light grey (#d0d0d0) for cut-outs and
  character sheets
- Format: PNG. No text, no watermark, no frame.
- Characters: none, unless this is a character request

## References

- `docs/reference/…`: what to take from it
- `art-source/style/…`: style key or landmark crop to match

## Prompt draft

Written by Claude. Adapt it freely, but record the final prompt in `receipt.md`.

> …

## Must have

- …

## Must not have

- …

## Acceptance criteria

Claude checks these.

- [ ] …

## Delivery

Filled in by the GPT image agent. Files go to `art-source/raw/<ID>/`, unmodified,
with `receipt.md` next to them. The receipt records the final prompt, the tool
and model, the output size, the date (UTC) and the references used.

| Round | Date (UTC) | Files | Notes |
|---|---|---|---|

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
