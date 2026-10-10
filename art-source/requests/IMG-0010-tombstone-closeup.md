# IMG-0010 — Close-up: Unknown's gravestone

status: accepted
operator-approval: required
plan: 002
requested: 2026-10-10 by Claude for the operator's grave opening (plan 007)

`status` is one of open, delivered, revise, accepted, rejected or cancelled.
`operator-approval` is required or not-required. `plan` names the plan whose
image budget pays for this request (plan 002's, with the operator's request).

## Purpose

The close-up that takes over the screen when the player clicks the gravestone
in the grave room (IMG-0009 v1). The operator's brief: the name begins with a
"U" and the rest of it is destroyed, and below it reads "I know you are happy
now. Your dove". It is the same stone as in the room, much closer.

## Generation

`tools/images/run.ts` reads this block.

```json
{
  "model": "openai/gpt-image-2.5-flare",
  "size": "2560x1440",
  "quality": "medium",
  "n": 2,
  "background": "opaque",
  "references": ["art-source/raw/IMG-0009/IMG-0009-v1.png"],
  "mask": null
}
```

## Prompt

The tool sends this text block verbatim.

```text
A close-up of the arched gravestone from the reference image, in exactly the same monochrome greyscale ink-wash gothic style: the stone's weathered face fills most of the frame, seen straight on, lit by cold moonlight from the upper left, with fog and dark twisted branches behind it and moss and dead grass at its foot. Keep its shape: the broken upper corner, the crack across the face, and the small worn dove carved at the top of the arch.

Carved into the stone, in deep classic Roman capitals:
- the name line is shattered: only its first letter, a capital U, survives clearly; everything after the U is chipped and broken away, with only splinters of letter strokes left, impossible to read;
- below it, smaller and intact but worn, two lines:
I KNOW YOU ARE HAPPY NOW.
YOUR DOVE

No other text, dates or numbers. No people or figures. No watermark, signature or border.
```

## Must have

- The same stone as IMG-0009 v1: arched, broken corner, crack, carved dove.
- A surviving "U" with the rest of the name destroyed and unreadable.
- The inscription, spelled exactly: "I KNOW YOU ARE HAPPY NOW." and "YOUR DOVE".

## Must not have

- Any other words, dates or numbers, misspellings, figures, or color.

## Acceptance criteria

Claude checks these.

- [ ] The lettering reads exactly as above, zoomed in.
- [ ] It is clearly the room's gravestone, closer.
- [ ] The operator likes it (review after the fact, decision #29).

## Delivery

Written by `tools/images`. Files go to `art-source/raw/<ID>/`, unmodified, with
`receipt.json` next to them.

| Round | Date (UTC) | Files | Model | Size / quality | Cost (USD) |
|---|---|---|---|---|---|
| 1 | 2026-10-10T20:22Z | IMG-0010-v1.png, IMG-0010-v2.png | openai/gpt-image-2.5-flare | 2560x1440 / medium | 0.055 |

## Review

Filled in by Claude and the operator.

| Round | Date (UTC) | Verdict | Notes |
|---|---|---|---|
| 1 | 2026-10-10T20:55Z | **accepted: v1** | Claude's pick (decision #29). Both spell the inscription exactly, "I KNOW YOU ARE HAPPY NOW." and "YOUR DOVE", with a clear capital U. In v1 everything after the U breaks into unreadable splinters; in v2 the fragments half-read as letters. v1 is also clearly the room's stone: the same broken corner, crack and dove. |
