# 007 — The grave: start at Unknown's grave, close-up views

Status: written 2026-10-10 at the operator's request. Owner: Claude. Images
are paid from plan 002's image budget, at the operator's request.

## Goal

The operator's brief (2026-10-10):
- The game starts in the cemetery, by Unknown's own grave.
- Clicking the gravestone zooms in until a detailed view of it takes over the
  whole screen.
- Only the first letter of the name, a "U", survives; the rest is destroyed.
  Below it reads "I know you are happy now. Your dove".
- We need a concept for zooming into scenes, so close-ups become a reusable
  system any hotspot can open.

## Depends on

- Plan 002's look: the cemetery vista, the reveal, Unknown (decision #32).
- Plan 004's interaction: hotspots, verbs, `Say`, exits.

## The close-up concept

- **Opening:** a hotspot opens a close-up by id. The camera pushes in on the
  hotspot while the close-up, first framed exactly over the hotspot, grows to
  fill the screen. It takes about 0.9 s and eases in and out.
- **While open:** the close-up is its own small scene: a full-screen image with
  its own hotspots. There is no walking; verbs run at once, and Unknown
  comments.
- **Leaving:** a right-click, Esc, or the small "back" glyph in the corner pulls
  back out, in the same move reversed.
- **Input:** clicks go to the close-up's hotspots while it is open. The room
  behind is hidden and keeps its state.

## Slices

### Slice 1 — Art

- **Images:** `IMG-0009` (the grave room) and `IMG-0010` (the gravestone
  close-up).
- **The stone:** the close-up carves the surviving U, the destroyed rest of
  the name, and the inscription. The lettering is checked against the brief.

### Slice 2 — Close-up system

- `Closeup` scenes in `content/closeups/<id>/`.
- `Closeups` opens and closes them with the push-in.
- `Interaction` routes clicks to the open close-up.
- Tests.

### Slice 3 — The grave room and the new start

1. `content/rooms/cemetery_grave`, built from IMG-0009: walk area, scale,
   hotspots (the gravestone opens the close-up), fog, and an exit to the
   cathedral.
2. The tombstone close-up, with hotspots for the U, the inscription and the
   dove.
3. Unknown's lines in `content/dialogue/cemetery.dialogue`.
4. The opening reveal hands off into the grave room.
5. Tests and QA.

### Slice 4 — Show it

Screenshots and a short video of the start: the reveal, the grave, the close-up.

## STOP conditions

- The carved lettering cannot be made to read exactly as the brief after two
  rounds. Carve it in post instead (render the text into the stone).
- Image spend for this plan passes $5. Stop and report.

## Execution record
- **2026-10-10, slice 1:** `IMG-0009` v1 (the grave room) and `IMG-0010` v1 (the
  close-up) are generated and accepted, for $0.11. The close-up spells the
  inscription exactly, "I KNOW YOU ARE HAPPY NOW." and "YOUR DOVE". Only the
  capital U of the name survives; the rest is unreadable splinters.
