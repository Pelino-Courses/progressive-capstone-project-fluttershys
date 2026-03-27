# Team Charter — MarketConnect Team
## SukaApp Progressive Project

**Date Created:** March 23, 2026  
**Review Date:** End of Week 3  
**Course:** Flutter Widgets & UI Design  

---

## 1. Our Team

| Member | Role Primary | Strength | GitHub Handle |
|--------|---------------|----------------------|---------------|
| Member A | Team Lead & Flutter Dev | UI components, project coordination | @member-a |
| Member B | UX/Research Lead | User interviews, wireframing | @member-b |
| Member C | Backend & Data | Local DB (Hive), state management | @member-c |

*Roles will rotate partially in Phase 2 to ensure everyone learns all layers.*

---

## 2. Working Protocols

### Communication 
- **Primary channel:** WhatsApp group — "SukaApp Team 🛒"
- **Response time:** Reply within **2 hours** during 8AM–9PM
- **Weekly sync:** Every **Tuesday and Friday at 6:00 PM** (Google Meet or in-person)
- **Decision rule:** major decisions require **2/3 agreement**; minor decisions by the person responsible for that area
- **Language:** Mix of Kinyarwanda and English — whomever explains clearest wins 🙂

### Code & GitHub
- **Repository:** `github.com/team-marketconnect/sukaapp`
- **Branch strategy:** `main` (protected) → feature branches named `feature/[name]`
- **Pull requests:** Need **1 review** before merging
- **Commit messages:** English, descriptive (e.g., `add: seller rating widget`)
- **No direct push to main** — ever

### Meetings
- Agenda shared **24 hours before** each meeting
- Minutes documented in `/docs/meeting_notes/` folder
- Absent member must review notes within 24 hours and comment

### Conflict Resolution
1. Discuss openly in the group —one-on-one first if personal
2. If unresolved after 24 hours → team vote
3. If still unresolved → escalate to course instructor
4. Rule: **No silent disagreement** — if you disagree, speak. Silence = consent.

---

## 3. Project Roadmap

| Week | Phase | Key Deliverables | Owner |
|------|-------|-----------------|-------|
| **1** | Phase 1 — Ideation | field_research.md, app_concept.md, team_charter.md, wireframes | All |
| **2** | Phase 1 — Foundation | Flutter project scaffold, basic navigation, home screen skeleton | Member A + C |
| **3** | Phase 2 — Core UI | Product listing Grid, Seller card widget, search bar | Member A |
| **4** | Phase 2 — Data Layer | Hive local DB setup, Product & Seller models | Member C |
| **5** | Phase 2 — Features | Pre-order flow, seller dashboard, reservation timer | All |
| **6** | Phase 3 — Integration | MoMo payment simulation, rating system | Member B + C |
| **7** | Phase 3 — Polish | Kinyarwanda localization, low-data mode, offline sync | All |
| **8** | Phase 4 — Testing | User testing with 3 real vendors, bug fixes, performance | All |
| **9** | Phase 4 — Showcase | Final demo, presentation slides, video walkthrough | All |

---

## 4. GitHub Repository Structure

```
sukaapp/
├── lib/                    # Flutter source code
├── docs/
│   ├── field_research.md
│   ├── app_concept.md
│   ├── team_charter.md
│   └── meeting_notes/
├── wireframes/
│   ├── home_screen.png
│   ├── seller_dashboard.png
│   └── checkout_flow.png
├── test/                   # Widget & unit tests
├── pubspec.yaml
└── README.md
```

---

## 5. Success Criteria for Phase 4 Showcase

For our Week 9 presentation to be compelling (guteza imbere neza), we define success as:

### Must Have 
- [ ] App runs without crashes on a real Android device
- [ ] All 5 MVP features are demonstrable end-to-end
- [ ] Kinyarwanda UI is complete and correct
- [ ] At least 1 real vendor has used a prototype and provided feedback
- [ ] GitHub history shows consistent contributions from all 3 members

### Should Have
- [ ] Offline mode works (demo without internet)
- [ ] MoMo payment flow is simulated realistically
- [ ] App loads in <3 seconds on an entry-level device
- [ ] Video demo recorded (2–3 min) for backup

### Nice to Have
- [ ] Real vendor testimonial (video or quote) in presentation
- [ ] Comparison chart vs. existing solutions
- [ ] GitHub Actions CI running widget tests

## 6. Tools Used & Rationale

| Tool | Purpose | Impamvu (Why) |
|------|---------|----------------|
| Flutter/Dart | App development | Course requirement; cross-platform |
| Hive | Local offline storage | Lightweight, no SQL needed, works offline |
| GitHub | Version control | Collaboration + submission |
| Figma | Wireframing | Free, team-collaborative, good for wireframes |
| WhatsApp | Team communication | Everyone already has it; low data |
| Claude AI | Documentation drafting, idea synthesis | Used to help structure documents and generate initial content framework. All research data, concepts, and decisions are original team work. AI was used as a writing assistant, not a decision-maker. |
| Google Meet | Virtual meetings | Free, integrates with Gmail |


## 7. Team Agreement

By contributing to this repository, all team members agree to:
- Conduct original research — no hypothetical data
- Contribute code and documentation equally
- Cite all external inspiration including AI tools (as done above)
- Respect all team members' ideas — *Ibitekerezo byawe ni ingenzi / Your ideas matter*
- Meet deadlines or communicate blockers **at least 24 hours early**

*We finish together.*  
**MarketConnect Team — Kigali, May 2026**
