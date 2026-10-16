# 010 — Unknown, redrawn

Status: done 2026-10-16; the operator shipped it. Written the same day at the
operator's request. Owner: Claude.
Images are made by Sol on the operator's ChatGPT plan, at $0. No gateway
spend: this plan has no image budget, so the gateway stays closed to it.

## Goal

The operator's brief (2026-10-16): "make our main character much better than
it is right now. It is looking very bad compared to our graphics with the
levels and with other characters in the games. … It needs to be something
between comic and cartoon. … don't stop until you get it to look perfect."

Unknown was a 3D render of a realistic base mesh (decision #32). Next to the
painted rooms and the Sol-painted NPCs (decision #49), it read as a grey
mannequin. He is redrawn as a hand-inked character, painted by Sol, frame by
frame.

## Design (slice 1)

- **Who he is, unchanged:** a living shadow in the shape of a man, ink-black,
  with two glowing white eyes and no mouth (`game-design.md` §2).
- **New:** the shadow of the clothes he died in, a long torn greatcoat with a
  tall upturned collar whose hem frays into ink, slim trousers, pointed shoes
  and a messy shock of shadow hair. Round eyes, not almond. Drawn between an
  inked comic and a hand-drawn animated film: a bold brush outline, a thin
  moonlight rim and sparse hatching.
- **Rounds:** IMG-0155 and IMG-0156 (a naked figure) read as grey aliens and
  were set aside. IMG-0157 (the greatcoat, with hair) and IMG-0158 (bald)
  followed. **IMG-0157 v2** is the model sheet.

## Animation route (slice 2)

Sol can't keep a walk cycle's legs right on its own (IMG-0159: most frames
repeated one stride). Given a pose guide, it can:

- **Guides:** frames rendered from the old rig (`tools/blender/unknown.py`),
  thinned and tone-lifted, laid 4 × 2 on a sheet. Sol repaints each mannequin
  as Unknown in the same pose and place, with the model sheet and the accepted
  side walk as references.
- **Frames:** `past-art painted` cuts each cell, maps it back into the render
  frame, registers its legs on the guide's (so a planted foot stays planted),
  and paints out the painted eyes, recording where they were. The rig's
  anchors, step events and ground speed carry over.
- **Walks:** 8 painted frames per direction, played at 8 fps.
- **Everything else is limited animation:** each action (talk, use, give, pick
  up, look around, fidgets, flare) has two or three painted key drawings, and
  each frame of the rig's animation shows the key nearest its pose. The rig's
  timing and events are kept. A held drawing breathes a little, so he never
  freezes.
- **In the game:** the frames pack as grey + alpha (`--style painted`), drawn
  as painted with a gentle curve to deepen the black. The game draws his eyes
  (round, matching the painted ones) so they still blink, flare and react to
  his voice. The old ink tendrils are off for the painted body: the coat
  frays into ink of its own.

## Slices

1. Design: model sheet. **Done:** IMG-0157 v2.
2. Walks, right, front and back. **Done:** IMG-0160 v3, IMG-0174 v2 and
   IMG-0175 v2 (front and back on guides thinned and squeezed to 80%).
3. Key poses, three sheets per direction. **Done:** IMG-0165, 0166, 0182
   (right), 0176, 0177, 0183 (front), 0179, 0180, 0184 (back). The low
   pick-up became a stoop in the rig first.
4. Build, pack, import; replace the old sprite set. **Done:**
   `tools/build/unknown_sprites.sh`.
5. Check. **Done:** `docs/qa/010/README.md`. The operator looked and said
   "push to main and deploy".

## Done when

- Unknown is painted in every animation and direction, and looks of a piece
  with the rooms and NPCs.
- The walk never slides, every action plays, eyes blink and flare.
- All tests, the lint and the QA runs pass; the browser demo fits its pack.
