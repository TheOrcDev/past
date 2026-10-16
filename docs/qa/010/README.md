# Plan 010 — Unknown, redrawn: evidence

Unknown is a hand-inked comic-cartoon character now, painted by Sol over the
old rig's poses (decision #53). Measured 2026-10-16 in the exported macOS app
and in Chrome.

## Look

- `model-sheet.jpg`: IMG-0157 v2, the design: a living shadow in a torn
  greatcoat with a tall collar, a shock of hair and round eyes.
- `before-after-gravedigger.jpg`, `before-after-maud.jpg`: the same
  checkpoints of the `--qa=game` run, before (plan 008) and after. The camera
  scrolls with him, so the framing differs; his frames are the same height as
  before (about 480 px at scale 1).
- `in-the-nave.jpg`: front, profile and back, standing.
- `every-action.jpg`: every action in every direction, shot at its most
  extreme drawing (`--qa=unknown_anims`): idle, two talks, use, give, pick up
  low and high, look around, two fidgets, flare. Rows: right, front, back.
- `whole-game.jpg`: all 28 checkpoints of the whole game.
- `guide-and-painting.jpg`: the side walk's pose guide (the old rig) and
  Sol's painting over it (IMG-0160 v3).
- `unknown-reel.mp4`: 36 s. He walks every direction across the nave, then
  talks, uses, gives, picks up low and high, looks around and flinches
  (`--qa=unknown_reel`).

## Checks

| Check | Result |
|---|---|
| GUT (`tools/test.sh`) and the content lint | PASS: 133 tests (the step-rate test now follows the walk's own 8 fps) |
| The art tools' tests (`uv run pytest` in `tools/art`) | PASS: 15, 5 of them new for `past-art painted` |
| The image tool's tests (`bun test` in `tools/images`) | PASS: 26 |
| The whole game in the macOS app (`--qa=game`) | PASS, grave to dawn |
| Every action in every direction (`--qa=unknown_anims`) | PASS: 30 one-shots and loops, each past its middle |
| Each part's tour (`--qa=rooms --part=…`), all 52 rooms in both eras | PASS. Video memory 102–144 MiB a room (was 182–224), loads 38–258 ms, frame p95 8.3–16.7 ms |
| The opening reveal (`--qa=cemetery_reveal`) | PASS; the close shot holds up at its zoom |
| Chrome: the prologue (`browser-qa.ts prologue`) and `unknown_look` | PASS |
| The browser demo's pack | 52.6 MB (was 143.3 MB): his sprites are 6.1 MB, were 97 MB |
| His sheets' video memory | 26.5 MiB of texture data (budget 128 MiB) |

## Production

| What | Count |
|---|---|
| Sol requests | IMG-0155 to IMG-0184: 25 run (75 images), 5 cancelled before running |
| Accepted | IMG-0157 v2 (model sheet) and 12 sheets: 3 walks, 9 key-pose sheets |
| Painted drawings in the game | 96: 8 walk frames and 24 key drawings per direction |
| Cost | $0, on the operator's ChatGPT plan |

## How it was made

1. **Design:** two rounds of model sheets. A naked shadow read as a grey alien
   (IMG-0155, IMG-0156). The shadow of a man's clothes, a torn greatcoat with
   a tall collar and a shock of hair, read as a gothic comic hero (IMG-0157).
2. **Motion:** drawn free, Sol repeated one stride (IMG-0159). Painted over
   pose guides from the old rig, every frame followed its pose.
3. **Build:** the front and back guides were thinned and squeezed to 80%, or
   Sol copied the mannequin's heavy build; the low pick-up became a stoop,
   because the rig's squat on tiptoe painted as a jump.
   `tools/build/unknown_sprites.sh` rebuilds it all.
