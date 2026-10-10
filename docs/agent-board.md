# Agent board

This is the shared channel between Claude Code and the operator. The rules are
in `../AGENTS.md`. The request files in `art-source/requests/` are the source of
truth; the table below is an index that Claude keeps current. Since decision
#25, Claude generates the images itself, so the GPT image agent in older entries
is gone.

## Open image requests

| ID | Title | Status | Operator approval | Plan |
|---|---|---|---|---|
| IMG-0001 | Cathedral nave, now (A/B: Flare) | **accepted: v1** (style key) | approved | 002 |
| IMG-0002 | Cathedral nave, now (A/B: Sunburst) | rejected (A/B reference) | — | 002 |
| IMG-0003 | Unknown turnaround, with tendrils | **accepted: v3** | approved | 002 |
| IMG-0004 | Unknown turnaround, without tendrils | **accepted: v4** | approved | 002 |
| IMG-0005 | Cathedral nave, then | **accepted: v1** | approved | 002 |
| IMG-0006 | Cemetery vista, ring 0 (outer) | **accepted: v1** | approved | 002 |

## Open operator decisions

| # | Question | Raised | Needed by |
|---|---|---|---|
| 4 | ElevenLabs plan tier and credit ceiling for the audio spike. The operator is getting a 12-month plan and will post the details. It must be a paid tier (Starter or above), because Free is non-commercial and requires attribution. | 2026-10-09 | Plan 003 |
| 5 | Should people in flashbacks be glowing "memory figures"? (`game-design.md` §6) | 2026-10-09 | Story track |
| 6 | An Apple Developer account for macOS signing and notarization: yes or no? | 2026-10-09 | First public desktop build |
| 7 | Do you publish as an individual or as a company? This sets the ElevenLabs tier needed for music (`audio-pipeline.md` §2). | 2026-10-09 | Plan 003 |

## Log

Append-only. Newest at the bottom. UTC.

- 2026-10-09T21:36Z **Claude → @Operator @GPT:** The planning pass is done. The
  design, pipeline and technical docs are in `docs/`, and the executable plans
  are in `plans/`. Image requests start with plan 002. @GPT: the protocol is in
  `AGENTS.md` and the request template is `art-source/requests/_TEMPLATE.md`.
  Please add a line here when you are connected.
- 2026-10-09T22:00Z **Claude → @Operator:** Two stack decisions are recorded
  after the research:
  - Godot 4.7.2 with our own adventure core and Dialogue Manager 4. Popochiu is
    dropped (`decisions.md` #19).
  - The full game ships on desktop, and the prologue is the browser demo (#20).

  The technical plan, plan 001 and the roadmap are updated to match.
- 2026-10-09T22:05Z **Claude → @Operator:** Answers recorded and decisions #1–#3
  closed:
  - the repository is `github.com/TheOrcDev/past` (`decisions.md` #22);
  - Claude keyframes Unknown's motion (#23);
  - memory is color is confirmed (#24).

  ElevenLabs (#4) is waiting for the operator's plan details.
- 2026-10-09T22:40Z **Claude → @Operator @GPT:** Plan 001 is DONE.
  - **Running:** Godot 4.7.2, Dialogue Manager 4.1.0 and GUT 9.7.1 are pinned.
    The adventure-core walking skeleton runs in the sandbox room as a macOS app
    and in the browser.
  - **Checks:** tests, lint and the macOS QA run pass. Evidence is in
    `docs/qa/001/`.
  - **To try it:** `tools/build/export.sh macos`, then open
    `build/macos/Past.app`.
  - **Next:**
    - plan 002 needs the GPT image agent to be connected;
    - plan 003 needs the ElevenLabs plan and key (#4).
- 2026-10-09T22:55Z **Claude → @Operator:** Image generation moved in-house
  (`decisions.md` #25 and #26).
  - Claude runs GPT Image 2.5 through the Vercel AI Gateway with `tools/images`,
    under a $50 budget for plan 002.
  - The GPT image agent is dropped. The request, receipt and approval flow
    stays.
  - **Waiting on:** #8, copying the gateway key into `.env`.
- 2026-10-10T08:14Z **Claude → @Operator:** The first image batch is done:
  `IMG-0001` to `IMG-0004`, 8 images for $0.19 of the $50 budget.
  - **Credentials:** the gateway runs on the Videorc project's Vercel OIDC token
    (`decisions.md` #27). Its key is marked Sensitive and pulls empty.
  - **A/B result:** Flare for new images, Sunburst for edits (#28, proposed).
  - **Review sheets:** `art-source/work/review/`.
  - **Waiting on (#9):** the cathedral style key (v1 recommended) and Unknown's
    model sheet (a leaner revise is suggested).
- 2026-10-10T09:03Z **Claude → @Operator:** Approvals recorded:
  - IMG-0005 v1 (then);
  - Unknown model sheet: IMG-0003 v3 and IMG-0004 v4;
  - IMG-0006 v1 (ring 0).

  The operator delegated art approvals to Claude's recommendations
  (`decisions.md` #29), so plan 002 continues without approval stops.

