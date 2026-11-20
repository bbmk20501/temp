# HARP Presentation — Prep Plan

**Presentation:** Monday 23 Nov 2026, afternoon
**Prep window:** Fri evening → Sat → Sun → Mon morning
**Format:** Slides + pre-recorded video demos only (**no live demos**)

---

## Storyline (one arc, repeated three times, then a vision close)

Every demo section follows the same beat so the audience learns the rhythm:

> **Today (the pain) → How HARP solves it → Demo (proof)**

| # | Section | Today (pain) | HARP approach | Demo | Mode |
|---|---------|--------------|---------------|------|------|
| 0 | Opening | — | What HARP is, why now, the 3 problems we'll fix | — | Slides |
| 1 | **Application registration** | Cumbersome: forms, tickets, hand-offs, waits, duplicate data entry | Single self-service registration flow | Register an app end to end in HARP | Video |
| 2 | **Deployment** | Manual / multi-team steps, inconsistent environments, slow lead time | Standardised, automated deployment from the registered app | Deploy the app just registered | Video |
| 3 | **Day-2 management & lifecycle** | Ad-hoc changes, tickets for routine ops, no single view of app state | Vision: Day-2 actions (scale, restart, config change, patch, rotate secrets, decommission) + lifecycle view | Show what exists today; walk through the vision with mock-ups | Video + slides |
| 4 | **Claim service** | (frame the gap it fills) | How we intend to build it, flow, ownership, timeline | Talk-through on slides/diagram (no live demo) | Slides |
| 5 | Close | — | Recap, roadmap, asks / decisions needed | — | Slides + Q&A |

**Key trick:** use the *same sample application* across sections 1 → 2 → 3, so the story is "register it, deploy it, run it."

---

## Suggested timing (assume ~45 min; adjust once slot length is confirmed)

| Section | Minutes |
|---------|---------|
| Opening | 4 |
| 1. Registration (pain 2 / HARP 2 / demo 5) | 9 |
| 2. Deployment (pain 2 / HARP 2 / demo 6) | 10 |
| 3. Day-2 (pain 2 / vision 4 / demo 4) | 10 |
| 4. Claim service | 5 |
| Close + Q&A | 7 |

---

## Deliverables checklist

### Slides (~18–22 slides)
- [ ] Title + agenda
- [ ] "What is HARP" one-pager (architecture diagram)
- [ ] Registration: current-process swimlane (who/what/how long) + pain numbers
- [ ] Registration: HARP flow + before/after comparison
- [ ] Deployment: current-process swimlane + pain numbers
- [ ] Deployment: HARP flow + before/after comparison
- [ ] Day-2: current state pain
- [ ] Day-2: vision — list of Day-2 actions, lifecycle stages (onboard → run → change → retire)
- [ ] Day-2: mock-ups for anything not yet built
- [ ] Claim service: problem, proposed design/flow diagram, phases & timeline
- [ ] Recap: before vs after table (time, steps, hand-offs, tickets)
- [ ] Roadmap + asks
- [ ] Backup slides: screenshots of every demo step (in case video/live fails)

### Videos (record each 3–6 min, narrated or captioned)
- [ ] V1 — Registration in HARP
- [ ] V2 — Deployment via HARP (same app)
- [ ] V3 — Day-2 actions on the deployed app (what's available today)
- [ ] Optional V0 — 60-sec "today" montage showing the old process (tickets, forms) for contrast

### Recording setup (no live demo on the day)
- [ ] Demo environment confirmed working, sample app name agreed
- [ ] Clean browser profile, zoom ~125%, notifications off, no secrets/tokens on screen
- [ ] Record at 1080p; trim waits/spinners; add captions or callouts on key clicks
- [ ] Narrate in the video, or keep silent and talk over it (decide before recording)
- [ ] Export MP4, embed in slides **and** keep standalone copies locally

---

## Schedule

### Friday evening (today)
- [ ] Confirm: slot length, audience, presenter(s), slide template
- [ ] Confirm what in HARP is **real vs. mock** for each section (drives video vs. slide)
- [ ] Gather "today" evidence: current registration/deployment steps, ticket counts, lead times
- [ ] Pick the sample application

### Saturday — Build content
- [ ] Morning: draft full slide outline + speaker notes skeleton
- [ ] Afternoon: write click-by-click scripts for V1 & V2; dry-run in the environment; fix blockers
- [ ] Evening: record V1 (registration) and V2 (deployment)

### Sunday — Day-2, Claim service, polish
- [ ] Morning: Day-2 vision slides + mock-ups; record V3
- [ ] Afternoon: Claim service slides + design diagram
- [ ] Evening: embed videos, add backup screenshots, first full run-through with timer

### Monday morning — Rehearse & lock
- [ ] Full timed rehearsal (ideally with one reviewer)
- [ ] Test video playback on the actual presenting laptop / screen-share setup
- [ ] Export slides to PDF + keep videos locally (no reliance on network)
- [ ] Lock deck; no changes after ~1 hr before the session

---

## Risk & fallback

| Risk | Fallback |
|------|----------|
| Video won't play | Backup screenshot slides |
| Feature not ready for Day-2 | Mock-ups framed explicitly as "vision" |
| Over time | Trim talk-track; videos are fixed length |
| Screen-share drops video frames / audio | Share the video file directly, or play from local player |

---

## Open questions (need answers to finalise)
1. How long is the slot, and who is the audience (execs, engineering, app teams)?
2. For each area, what's actually working in HARP today vs. planned?
3. Is there an existing slide template / brand to use?
4. Who presents which section? Single presenter or split?
5. Any metrics for the "today" pain (lead time, # steps, # tickets, # teams)?
6. Claim service — any existing design notes or is this to be written from scratch?
