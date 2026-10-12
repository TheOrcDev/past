# 009 — The start screen

Status: written and done 2026-10-12 at the operator's request. Owner: Claude.
No paid API: the picture is the grave room's existing painting.

## Goal

The operator's brief (2026-10-12): "a start screen for our game … New Game,
Save Game, Load Game, Quit, and stuff like that, with some nice image in the
background (which is maybe a little bit blurry) and that we can start from
there instead of starting automatically with our game."

## Design (decision #52)

- **At launch** the game opens on the start screen instead of the opening
  cutscene. Unknown's grave under the moon (`cemetery_grave`'s now painting)
  fills the screen, softly blurred, with two bands of fog drifting across it
  and a slow drift and zoom. "PAST" in the opening's spaced capitals sits
  over a shade on the left, with the menu under it.
- **Entries at launch:** Continue (the newest save, autosave included, only
  when there is one), New Game, Load Game, Settings, Quit.
- **Over a game:** the top bar gains **Main menu**, which brings the same
  screen up over the paused game, with Resume and Save Game first. Save Game
  keeps the game as it was before the menu opened as its thumbnail.
- **New Game** plays the opening and starts at the grave, as before. It asks
  first when a game is in progress or a save exists.
- **The browser demo** has no Quit, as in the bar. Its shell's "Click to
  remember" now leads to the start screen.
- **Scripted QA runs** (`--qa=…`, `?qa=…`) skip the start screen, so every
  existing scenario runs as before. `--qa=title` runs the start screen itself.
- **Mouse only**, like every other page (game-design §8).

## Done when

- The macOS app opens on the start screen, and New Game, Continue, Load,
  Settings, Main menu, Resume, Save Game and Quit all work: `--qa=title`
  passes, with its screenshots in `docs/qa/009/`.
- GUT covers the entries, the pause, Resume, New Game and Continue's pick.
- Every existing test and the lint still pass, and the browser prologue check
  still passes.
