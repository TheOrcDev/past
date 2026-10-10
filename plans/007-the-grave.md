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
  hotspot until a screen-shaped frame round it fills the screen. The close-up
  stays pinned over that frame with soft edges and fades in, so the detail grows
  out of the thing clicked. It takes about 0.9 s and eases in and out.
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
- **2026-10-10, slice 2:** the close-up system.
  - **Pieces:** `Closeup` (a scene with a Background and Hotspots; its script
    answers `<verb>_<id>`) and the `Closeups` autoload.
  - **Opening:** the close-up starts as a screen-shaped frame over the clicked
    hotspot and grows to fill the screen in 0.9 s, while the room's camera
    pushes in 1.7×. Closing reverses it.
  - **Inside:** `Interaction` sends clicks and hover to its screen-space
    hotspots, with no walking. A right-click, Esc or the ‹ glyph backs out.
    `Say` speaks from below the image.
  - **Tests:** three integration tests.
- **2026-10-10, slice 3:** the grave room and the new start.
  - **Room:** `cemetery_grave`, built from IMG-0009 v1 by
    `art-source/work/rooms/cemetery_grave/build.py`. It has a walk area, scale
    zones, fog and moonlight, five hotspots, and an exit east to the cathedral.
    The cathedral gets a way back, over the rubble on the left.
  - **Close-up:** `tombstone`, built from IMG-0010 v1 through the new
    `new_closeup.gd` scaffold. Its hotspots are the U, the inscription and the
    dove, each with Unknown's lines in `content/dialogue/cemetery.dialogue`.
  - **New start:** the opening hands off to the grave. Unknown says one line on
    arrival, the first time only.
  - **Push-in reworked:** in slice 2 the close-up grew from the hotspot on its
    own, so mid-move it was a hard-edged picture that didn't sit on the stone.
    Now the camera zooms until the hotspot's frame fills the screen, and the
    close-up stays pinned over that frame with soft edges. The room preloads the
    close-up, which removed a 41 ms frame in Chrome.
  - **Fixes:** `Exit` finds `Rooms` by path, so the room scaffold (which runs
    without autoloads) can compile it. `browser-qa.ts` keeps covered Chrome
    windows running, and a QA timeout names its step.
  - **Checks:** 72 GUT tests pass, 5 new in `test_grave.gd`. The `grave` QA
    scenario passes in the editor, the macOS app and the browser. Chrome holds
    60 fps through the close-up. Evidence is in `docs/qa/007/`.
