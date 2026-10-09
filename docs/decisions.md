# Past — Decision log

Newest entries go at the bottom. **Confirmed** means the operator (OrcDev) said
it. **Proposed** means an agent recommends it and it stands until the operator
changes it or a plan gate replaces it. Add to the log; never rewrite a past
entry. To reverse a decision, add a new entry that points back to the old one.

| # | Date | Decision | Status | Source / notes |
|---|---|---|---|---|
| 1 | 2026-10-09 | The game is called **Past**. The protagonist has lost his memory and calls himself **Unknown**. The game is his search for who he was, told through flashbacks that show areas as they used to be. | Confirmed | Operator brief |
| 2 | 2026-10-09 | The project lives in `~/projects/past` and is separate from Videorc. Videorc skills do not apply. | Confirmed | Operator; handoff |
| 3 | 2026-10-09 | The engine is **Godot 4 + Popochiu**, written in GDScript only. C# web export is limited. | Confirmed | Operator; handoff |
| 4 | 2026-10-09 | The art style follows the concept images in `reference/`: monochrome gothic matte paintings with fog, silhouettes and ruins. | Confirmed | Operator: "art like on screenshots" |
| 5 | 2026-10-09 | **Memory is color.** The present is monochrome and the past is in full color. | Proposed | Inferred from the concepts: the only color image is the cathedral "then" |
| 6 | 2026-10-09 | Desktop only. The project stays **browser-compatible** and also exports macOS / Windows / Linux. Whether the browser gets the full game or a demo is decided later. | Confirmed | Operator chose "Both" |
| 7 | 2026-10-09 | Controls are **mouse only**. | Confirmed | Operator |
| 8 | 2026-10-09 | **ElevenLabs** makes the voice acting, sound effects and music. Every line is voiced. | Confirmed | Operator |
| 9 | 2026-10-09 | The game is long. Its exact length is decided in the story track. | Confirmed | Operator |
| 10 | 2026-10-09 | Flashbacks are **mostly cinematic**, and a few key ones are playable. | Confirmed | Operator |
| 11 | 2026-10-09 | A **GPT image agent** generates every image. **Claude** does everything else: processing, rigging, animation, code, audio, docs. The two coordinate through the repo. | Confirmed | Operator |
| 12 | 2026-10-09 | The tone is a **dark mystery with dry humor**, close to *Grim Fandango*. | Confirmed | Operator |
| 13 | 2026-10-09 | Interaction uses a CMI-style press-and-hold **verb coin** (Look / Use / Talk) and opens the inventory on right-click. | Proposed | Handoff recommendation; confirm in M3 |
| 14 | 2026-10-09 | The base resolution is **1920×1080** with a 16:9 letterbox. | Proposed | `technical-plan.md` |
| 15 | 2026-10-09 | The **Compatibility** renderer is used on every platform, because the web export requires it. | Proposed | `technical-plan.md` |
| 16 | 2026-10-09 | Unknown gets **no mouth lip sync**. His eye glow and smoke react to a precomputed loudness envelope of each voice line. Rhubarb is kept only for any future character with a visible mouth. | Proposed | This replaces the handoff's Rhubarb plan, because the concepts give Unknown no mouth |
| 17 | 2026-10-09 | Unknown is animated by **rendering a rigged 3D silhouette from Blender into 2D sprites**. A 2D cut-out rig is the fallback. | Proposed (gated) | This replaces the handoff's hybrid cut-out plan. Plan 002's look gate decides. |
| 18 | 2026-10-09 | Then/now image pairs are made as **edits of one composition**, so a flashback can restore the room in place. | Proposed | Measured on the concept pair (cathedral 02 ↔ 05): similarity transform scale 1.0012, rotation −0.03°, offset under 1 px, corners within 4 px |
| 19 | 2026-10-09 | **Popochiu is dropped.** The engine stays Godot (4.7.2), with a small adventure core of our own and **Dialogue Manager 4** for dialogue. This replaces the Popochiu part of #3. | Confirmed | Operator, after the Popochiu research. Popochiu 2.2.0 has no verb coin. Its cutscene skipping is uneven and tied to a queue system that may be deprecated. It has no per-line voice and loads every audio cue at startup. Its camera has bugs. Objects are created from an editor dock. |
| 20 | 2026-10-09 | The **full game ships on desktop** as macOS, Windows and Linux downloads. The **prologue runs in the browser as a free demo**. This settles the open part of #6. | Confirmed | Operator, after the browser research. itch.io caps browser games at 500 MB total and 200 MB per file. Godot 4.7.2 downloads the whole pack before starting. Browser "Sample" audio freezes the first time a long clip plays and never frees decoded audio. |
| 21 | 2026-10-09 | Every spoken line lives in a Dialogue Manager file with a static `[ID:…]`. That ID names its voice file and is its translation key. | Proposed | `technical-plan.md` §5.6 |
| 22 | 2026-10-10 | The repository is **github.com/TheOrcDev/past** (private). | Confirmed | Operator. The repository was empty on 2026-10-10. Plan 001 pushes `main` once pushes are authorized. |
| 23 | 2026-10-10 | **Claude keyframes Unknown's motion** in Blender. No Mixamo or Meshy. | Confirmed | Operator. This settles where the motion in #17 comes from. #17 stays gated by plan 002. |
| 24 | 2026-10-10 | **Memory is color** is confirmed: the present is monochrome and the past is in full color. | Confirmed | Operator. Confirms #5. |
