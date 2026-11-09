# Student Study Planner — Master Rebuild & Repair Specification

> **Purpose:** Use this document as the source of truth to audit, repair, complete, and improve the existing student study-planner application shown in the supplied reference screenshots.
>
> **Critical instruction:** Do not blindly regenerate the whole application. First inspect the existing repository, identify its actual stack and working modules, preserve useful code/data, then implement and test changes in small phases. Do not claim a feature is complete until it works end-to-end and passes its acceptance tests.

---

## 0. Product vision

Build a reliable, polished student productivity application that helps a student:

1. Create exams and set exam dates.
2. Organize subjects, chapters, topics, and learning tasks.
3. Plan daily study sessions based on time remaining, chapter workload, priorities, and revision needs.
4. Focus using a configurable study/break timer.
5. Track actual study time and completed work.
6. Schedule spaced revision and track retention.
7. Understand preparation through accurate analytics, streaks, milestones, and progress.
8. Receive useful reminders without duplicate or misleading notifications.

The reference UI uses a clean, light neutral background, dark text, green/teal primary actions, rounded cards, compact charts, and a persistent bottom navigation bar. Match the reference's information architecture and visual character, but prioritize accessibility, responsive layout, and correctness over pixel imitation.

## 1. Reference screens and expected modules

### A. Home dashboard
- Greeting and active exam selector.
- Exam title, exam date, days remaining, and preparation summary.
- Progress bar and completed/remaining chapter counts.
- “Up next” card for the next due revision or planned task.
- Quick actions: short study win, deep-work session, continue plan.
- Today's focus time versus daily goal.
- Today's plan with task duration, subject, chapter, priority, and completion control.
- Empty, loading, error, and completed-day states.

### B. Exams
- Create, view, edit, archive, and delete an exam.
- Exam fields: title, exam date/time, timezone, academic board/course, status, notes.
- Associate subjects with an exam.
- Support multiple exams; one can be selected as active.
- Countdown must be calculated from the exam's local date/time and the user's timezone.
- Past exams must not show negative countdowns as “days left”; show “Exam completed” or “Exam date passed”.

### C. Subjects and chapters
- Subject cards with name, color/icon, chapter count, and completion percentage.
- Add/edit/archive/delete subjects.
- Add/edit/reorder chapters.
- Chapter fields: title, subject, estimated study minutes, difficulty, priority, status, notes, exam association.
- Chapter states: `not_started`, `in_progress`, `completed`.
- Separate revision state from learning completion. Completing a chapter must not silently mark all revisions complete.
- Chapter detail should show study sessions, revision history, notes, and next due date.

### D. Focus timer
- Configurable focus duration, short break, long break, and long-break interval.
- Start, pause, resume, reset, skip, and finish actions.
- Select the subject and optionally a chapter before starting.
- Persist timer/session state safely so app refresh or navigation does not create duplicate sessions.
- Record actual elapsed focus time, not merely the configured duration.
- Break time must not count as study time.
- Handle app backgrounding, browser refresh, device sleep, and clock changes sensibly.
- Show session completion confirmation and allow the student to discard an accidental session.
- Do not create a study record until a session is completed or explicitly saved.

### E. Progress and analytics
- Overall preparation overview.
- Syllabus coverage.
- Revision health / overdue revisions.
- Study consistency.
- Study streaks.
- Personal records: longest streak, most study time in a day, most chapters completed in a day, total study time, active study days.
- Milestones and weekly challenges.
- Chapters completed per day/week.
- Focus minutes per day/week.
- Time per subject.
- Daily average and all-time totals.
- Every chart must use the same underlying records as its summary cards.

### F. Revision and flashcards
- Create revision items for chapters/topics.
- Optional flashcards with front/back, tags, and confidence rating.
- Review outcomes: `again`, `hard`, `good`, `easy`.
- Save every review event with timestamp and next due date.
- Show due today, overdue, upcoming, and completed reviews.
- Never count a planned revision as a completed revision.
- A chapter's learning completion and its revision completion are different metrics.

### G. Calendar and planning
- Daily/weekly plan view.
- Add, edit, reschedule, complete, and cancel planned tasks.
- Avoid scheduling overlapping tasks.
- Respect available study windows, breaks, and daily limits.
- Rescheduling must not duplicate a task.
- Clearly distinguish planned minutes from actual recorded study minutes.

### H. Navigation and settings
- Main navigation based on the reference: Home, Focus, Subjects, Progress, Exams; add Calendar/Revision where appropriate without overcrowding mobile navigation.
- Settings: timezone, week start, theme, timer presets, daily goal, reminders, data export, account and privacy controls.
- Responsive mobile-first UI, with a useful desktop layout.

---

## 2. Source-of-truth data model

Inspect the current database before changing it. Adapt these entities to the existing ORM/database rather than creating duplicate tables.

### Core entities

**User**
- `id`, `name`, `email` (if accounts exist), `timezone`, `created_at`, `updated_at`.

**Exam**
- `id`, `user_id`, `title`, `exam_at`, `timezone`, `status`, `created_at`, `updated_at`.

**Subject**
- `id`, `user_id`, `name`, `color`, `icon`, `sort_order`, `archived_at`.

**ExamSubject**
- `exam_id`, `subject_id` (many-to-many relationship if a subject can belong to multiple exams).

**Chapter**
- `id`, `subject_id`, `title`, `description`, `estimated_minutes`, `difficulty`, `priority`, `status`, `sort_order`, `completed_at`, `created_at`, `updated_at`.

**StudySession**
- `id`, `user_id`, `exam_id` (nullable), `subject_id`, `chapter_id` (nullable), `started_at`, `ended_at`, `duration_seconds`, `status`, `source`, `created_at`.
- `status`: `completed`, `discarded`, `interrupted`.
- Store timestamps consistently (UTC recommended); render them in the user's timezone.
- Enforce that duration is non-negative and that one session cannot be counted twice.

**RevisionItem**
- `id`, `user_id`, `chapter_id`, `title`, `due_at`, `interval_days`, `ease_factor` (if using an SM-2-style scheduler), `repetitions`, `status`, `created_at`, `updated_at`.

**RevisionReview**
- `id`, `revision_item_id`, `reviewed_at`, `rating`, `previous_due_at`, `next_due_at`, `response_time_seconds` (optional).

**Flashcard**
- `id`, `user_id`, `chapter_id` (nullable), `front`, `back`, `tags`, `created_at`, `updated_at`.

**DailyPlanTask**
- `id`, `user_id`, `plan_date`, `subject_id`, `chapter_id` (nullable), `revision_item_id` (nullable), `title`, `planned_minutes`, `priority`, `status`, `sort_order`, `completed_at`.

**DailyGoal**
- `user_id`, `goal_date`, `target_minutes`.

**Achievement / UserAchievement**
- Store achievement definitions separately from each user's earned achievement record. Do not award the same achievement repeatedly.

**Reminder**
- `id`, `user_id`, `type`, `scheduled_at`, `status`, `deduplication_key`.

### Data integrity requirements
- Every user-owned record must be scoped to the authenticated user.
- Use foreign keys and appropriate indexes.
- Use database transactions for operations that update multiple related records.
- Use soft deletion/archive where history should remain available.
- Never store derived totals as independently editable facts.
- If caching derived values, invalidate/update them transactionally and verify against source records.
- Add migrations with rollback strategy. Back up existing data before destructive migrations.

---

## 3. Canonical calculation rules

Create one shared domain/service layer for these calculations. UI components must not reimplement formulas independently.

### 3.1 Chapter coverage
For an exam:

`totalChapters = count of non-archived chapters attached to the exam's subjects`

`completedChapters = count of those chapters where status = completed`

`coveragePercent = totalChapters == 0 ? 0 : round(completedChapters / totalChapters * 100)`

Use integer counts as the authoritative values. Use the same denominator in every screen. If subjects have different exam associations, count only chapters relevant to the selected exam.

### 3.2 Subject progress
`subjectPercent = subjectChapterCount == 0 ? 0 : round(completedSubjectChapters / subjectChapterCount * 100)`

Do not use a different formula on subject cards and progress charts.

### 3.3 Study duration
- `sessionSeconds = max(0, endedAt - startedAt)` after validating the saved session.
- Prefer a monotonic timer for measuring elapsed time while the app is active; use persisted timestamps for recovery.
- Aggregate only valid `completed` sessions.
- Convert seconds to minutes only for display/goal calculations.
- Keep seconds internally to avoid rounding loss.
- Display rounding policy: `8h 40m` for 520 minutes; `9h` may be used only if the UI explicitly uses rounded whole hours. Label the format consistently.
- Do not add planned task duration to actual study time.

### 3.4 Daily and weekly totals
- Define a day using the user's configured timezone.
- A session belongs to the local calendar date on which it started, unless product requirements explicitly define another rule.
- Weekly totals must use one consistent week-start setting (default Monday).
- Use half-open date ranges: `[start, nextStart)` to avoid double counting at midnight.
- Handle daylight-saving changes even if the initial target audience is in a timezone without them.

### 3.5 Daily goal
`goalProgressPercent = targetMinutes <= 0 ? 0 : min(100, round(actualMinutes / targetMinutes * 100))`

`remainingMinutes = max(0, targetMinutes - actualMinutes)`

If actual time exceeds the goal, show the actual total and cap only the progress bar at 100%.

### 3.6 Streaks
Define a study day as a local date with at least the configured minimum qualifying study duration (default: 1 completed focus minute; make configurable).
- Current streak: consecutive qualifying local dates ending today; if today has no study yet, allow the streak to remain active through yesterday.
- Longest streak: maximum consecutive qualifying dates in history.
- Never count break sessions, discarded sessions, or planned tasks.
- Test midnight, timezone, missed-day, and first-study-day cases.
- Revision streak and study streak are separate metrics.

### 3.7 Consistency score
Do not invent a score or show a vague label without a documented formula. A simple explainable initial model:

`consistency = round(activeStudyDaysInLast14Days / 14 * 100)`

Exclude future dates. Display the numerator, denominator, and period in the UI, e.g. `4 of 14 days`. If the product chooses a different formula, document it and test it. Do not compare a 7-day count against a 14-day denominator.

### 3.8 Milestones
Examples:
- 600 focus minutes.
- 7 qualifying study days in a row.
- 50 flashcards reviewed.
- 3 chapters revised.

Each milestone must have:
- A stable ID.
- A clearly defined source metric.
- A target and current value.
- A one-time earned event.
- A deterministic progress calculation.
- Tests for exactly-at-target and above-target values.

A label such as “10 hours studied” must use 600 minutes as its target. If progress is 520 minutes, show `520 / 600 min` or `8h 40m / 10h`, not an inconsistent value.

### 3.9 Overall preparation score
Do not mix unlike percentages without explaining the weights. Keep the following separate:
- Syllabus coverage.
- Revision health.
- Study consistency.
- Practice/retention (only if practice data exists).

If a composite score is shown, define it explicitly, for example:

`overallScore = round(coverage * 0.50 + revisionHealth * 0.20 + consistency * 0.15 + practiceScore * 0.15)`

Rules:
- Weights must sum to 1.0.
- If a component has no data, do not silently treat it as 0 or 100. Either show “not enough data” and renormalize available weights, or do not show the composite score yet.
- Clearly label it “weighted readiness estimate,” not “syllabus completed.”
- The same service must return the same score to all screens.
- Do not show 4% in one place and 6% elsewhere for the same metric and selected exam/date. If one is syllabus coverage and one is weighted readiness, label them distinctly.

### 3.10 Exam countdown
- Calculate from the exam's local date/time and timezone.
- Define whether the UI displays calendar days remaining or exact 24-hour periods. Prefer calendar days for an exam countdown.
- Test today, tomorrow, past date, leap day, and timezone boundaries.

---

## 4. Planning and recommendation algorithms

### 4.1 Task priority
Use a transparent priority score, not random ordering. Example:

`priorityScore = urgencyWeight + examWeight + overdueWeight + difficultyWeight + userPriorityWeight`

Possible inputs:
- Days until exam.
- Chapter importance set by the student/teacher.
- Revision overdue status.
- Chapter difficulty.
- Estimated minutes.
- Whether the chapter is already in progress.

Normalize scores to a documented range. Let the student override automatic ordering.

### 4.2 Daily plan generation
Inputs:
- Available study minutes for the day.
- Daily goal and existing completed minutes.
- Exam date.
- Incomplete chapters and estimated minutes.
- Due/overdue revisions.
- Existing planned tasks.
- Preferred focus block and break lengths.
- User priorities and unavailable time windows.

Algorithm:
1. Validate inputs and available time.
2. Add overdue revision tasks first, within a configurable cap.
3. Add revisions due today.
4. Rank incomplete chapters by priority score.
5. Split long work into reasonable blocks without losing the parent chapter/task relationship.
6. Fit tasks into remaining available minutes.
7. Insert breaks between focus blocks.
8. Avoid overlapping tasks.
9. Save the generated plan as draft or ask for confirmation before replacing an existing plan.
10. Explain why each task was selected.

Do not promise that the whole syllabus will fit if estimated workload exceeds available time. Show the workload gap and let the student adjust.

### 4.3 Revision scheduler
Start with a simple, explainable spaced-repetition schedule (example intervals: 1, 3, 7, 14, 30 days), then adapt based on review rating.
- `again`: schedule soon and reset/shorten interval.
- `hard`: increase interval slightly.
- `good`: use the normal next interval.
- `easy`: increase interval more.
- Store every review event; never overwrite history.
- Make interval rules configurable and unit tested.
- Explain that the schedule is a study aid, not a guarantee of memory retention.

---

## 5. API and architecture requirements

First identify the existing stack from the repository. Keep the existing framework unless there is a clear technical reason to migrate.

If the current app uses a typical web stack, keep a clean separation:

- Presentation: pages/screens, reusable components, design tokens.
- Application: use cases such as `CreateExam`, `CompleteChapter`, `FinishStudySession`, `GenerateDailyPlan`.
- Domain: entities, validation, calculation services, scheduling rules.
- Infrastructure: database repositories, notifications, analytics adapters.
- API: validated routes/controllers, authentication, authorization, consistent errors.

### API behavior
- Validate request bodies, query params, and IDs at the server boundary.
- Return consistent response shapes and meaningful HTTP status codes.
- Enforce authentication and ownership on every user-specific endpoint.
- Use pagination for long histories.
- Use idempotency keys for actions that could be retried, especially finishing timer sessions and awarding achievements.
- Never trust client-provided totals or progress percentages; calculate on the server/domain layer.
- Add rate limits to authentication and expensive endpoints.
- Do not expose secrets or stack traces to clients.

### Suggested endpoint groups
Adapt naming to existing conventions:
- `/api/exams`
- `/api/subjects`
- `/api/chapters`
- `/api/study-sessions`
- `/api/revisions`
- `/api/flashcards`
- `/api/plans`
- `/api/analytics`
- `/api/goals`
- `/api/achievements`
- `/api/settings`

Document each endpoint's method, request schema, response schema, permissions, and error cases.

---

## 6. UI/UX requirements

- Match the reference's calm green/teal student-product style.
- Use consistent spacing, typography, colors, card radius, and icon sizes.
- Make mobile the primary layout; ensure desktop/tablet layouts are also usable.
- Provide accessible contrast, keyboard navigation, focus indicators, and labels.
- Never communicate status using color alone.
- Use skeletons or loading indicators; do not show fake zero values while data is loading.
- Provide useful empty states and recovery actions.
- Prevent double taps from creating duplicate records.
- Confirm destructive actions.
- Use optimistic updates only when rollback/error handling exists.
- Avoid horizontal overflow and bottom navigation covering content.
- Ensure charts have text summaries for accessibility.
- Keep date/time formatting consistent and locale-aware.

---

## 7. Required automated tests

### Unit tests
- Chapter and subject coverage.
- Duration aggregation and rounding.
- Daily/weekly date boundaries.
- Streak calculation.
- Consistency score.
- Milestone progress and award-once behavior.
- Exam countdown.
- Overall readiness weighting and missing-data behavior.
- Priority ranking.
- Daily plan capacity and overlap rules.
- Revision interval updates.

### Integration tests
- Create exam → add subjects → add chapters → complete chapter → verify dashboard and subject progress.
- Start timer → pause/resume → finish → verify one session and correct totals.
- Discard timer → verify no study-time increase.
- Review item → verify review history and next due date.
- Generate plan → verify no overlapping tasks and no duplicate tasks.
- User A must never read or edit User B's records.
- Retry the same completion request → verify no duplicate completion/session/achievement.

### End-to-end tests
At minimum, automate these journeys:
1. New user creates an exam and subjects.
2. User adds chapters and completes one.
3. User starts and finishes a focus session.
4. Dashboard, subject, and analytics screens agree.
5. User reviews a due item and sees its next due date.
6. User edits the exam date and countdown updates.
7. User refreshes during a timer and the session recovers safely.
8. User exports their data if export is implemented.

### Regression checklist
- No console errors.
- No unhandled API errors.
- No broken navigation.
- No duplicate sessions.
- No negative durations.
- No negative countdowns.
- No inconsistent chapter totals.
- No chart/card disagreement.
- No timezone boundary bugs.
- No data loss after refresh/re-login.

---

## 8. Development phases and definition of done

### Phase 0 — Repository audit (no feature changes)
- Identify frontend, backend, database, ORM, auth, routing, state management, test tools, build scripts, deployment setup.
- Run the existing app and tests.
- Record all errors and broken flows.
- Map every reference screen to current files/components/routes.
- Identify duplicated calculations and duplicated data.
- Produce `AUDIT_REPORT.md` with severity, reproduction steps, likely cause, and affected files.

**Done when:** the app's actual architecture and known failures are documented; no assumptions about the stack remain.

### Phase 1 — Stabilize foundation
- Fix startup/build/runtime errors.
- Fix environment configuration and database connection.
- Add/repair migrations and seed data.
- Add validation, error handling, logging, and authorization.
- Add a smoke test.

**Done when:** clean install, migration, seed, start, and basic authenticated flow work.

### Phase 2 — Canonical data and domain logic
- Implement the entities/relations needed by the existing architecture.
- Create shared calculation services.
- Remove duplicated UI-side calculations.
- Add unit and integration tests before wiring all screens.

**Done when:** calculation tests pass and every screen reads the same domain results.

### Phase 3 — Core study workflow
- Exams, subjects, chapters.
- Chapter status and completion.
- Focus timer and session persistence.
- Daily goals and study history.

**Done when:** the complete workflow works from UI to database and back.

### Phase 4 — Revision and planning
- Due/overdue revision.
- Review history and scheduling.
- Daily plan generation and manual editing.
- Conflict detection and rescheduling.

**Done when:** plans are feasible, revisions are not duplicated, and history is preserved.

### Phase 5 — Analytics and achievements
- Dashboard and progress screens.
- Streaks, milestones, challenges, records.
- Weekly and subject charts.
- Consistent rounding and timezone rules.

**Done when:** analytics reconcile exactly with source records.

### Phase 6 — Polish and release readiness
- Responsive UI and accessibility.
- Performance and security checks.
- Backup/export and error recovery.
- Full regression and end-to-end suite.
- Production build and deployment documentation.

**Done when:** all critical acceptance tests pass and known limitations are documented.

---

## 9. AI coding-agent execution commands

Run these prompts one at a time in your coding agent (Cursor, Claude Code, Codex, or another repository-aware agent). Give the agent access to the project repository and this specification file.

### Command 1 — Audit the existing project

```text
Read MASTER_REBUILD.md completely. Do not modify code yet.

Inspect the entire existing repository. Identify the actual frontend/backend
stack, package manager, database, ORM, auth, routing, state management,
environment variables, scripts, tests, and current architecture.

Run the existing app/build/tests where possible. Reproduce errors rather
than guessing. Map each reference module to the current implementation:
Home, Exams, Subjects, Chapters, Focus Timer, Progress, Revision,
Planning, Analytics, Settings.

Find duplicated calculations, inconsistent data sources, broken routes,
missing validation, unsafe database operations, and UI-only fake data.

Create AUDIT_REPORT.md containing:
- architecture map and important file paths
- commands used and their results
- bugs with severity (P0/P1/P2/P3)
- exact reproduction steps
- likely root cause and affected files
- modules that already work and must be preserved
- recommended implementation order

Do not rewrite the project, change dependencies, delete files, or alter
the database during this audit. Report anything you could not verify.
```

### Command 2 — Create implementation plan

```text
Read MASTER_REBUILD.md and AUDIT_REPORT.md.

Create IMPLEMENTATION_PLAN.md with small, ordered tasks. For every task
include: objective, affected files, dependencies, migration impact,
test cases, acceptance criteria, and rollback approach.

Prioritize data integrity and calculation correctness before visual polish.
Reuse the current stack and working code. Do not start unrelated rewrites.
Identify any missing product decisions and ask only questions that block
safe implementation. Do not invent credentials or production settings.
```

### Command 3 — Repair the foundation

```text
Implement only Phase 1 from MASTER_REBUILD.md and IMPLEMENTATION_PLAN.md.

Fix reproducible startup, build, database, migration, validation,
authentication/authorization, and error-handling problems. Preserve
existing working behavior. Add or repair a minimal smoke test.

Before changing schema, inspect current data and create a safe migration
plan. Never drop or reset user data to make tests pass.

After changes, run the relevant lint, type-check, build, migration,
and tests. Fix failures caused by your changes. Update AUDIT_REPORT.md
with resolved and remaining issues. Do not claim success without logs.
```

### Command 4 — Implement canonical calculations

```text
Implement the calculation/domain layer from Section 3 of MASTER_REBUILD.md.

Create one authoritative service for chapter coverage, subject progress,
study duration, daily/weekly totals, daily goals, streaks, consistency,
milestones, exam countdown, and weighted readiness (only if supported
by real data).

UI components and API controllers must call these shared services.
Do not duplicate formulas. Keep actual study time separate from planned
time and break time. Use the user's timezone for calendar grouping.

Write unit tests for normal, empty, boundary, rounding, duplicate,
timezone, and missing-data cases. In particular verify that every screen
uses the same chapter denominator and that 520 minutes is represented
consistently against a 600-minute goal.

Do not proceed to analytics UI until these tests pass.
```

### Command 5 — Implement core study workflow

```text
Implement Exams, Subjects, Chapters, Focus Timer, Study Sessions,
and Daily Goals using the existing architecture.

Wire every screen to real persisted data. Implement create/read/update/
archive flows, server-side ownership checks, validation, loading/error/
empty states, and duplicate-submission protection.

Timer requirements: start, pause, resume, reset, skip, finish, break
handling, refresh recovery, and accurate elapsed-time recording.
Breaks and discarded sessions must never count as study time.
Finishing/retrying a session must not create duplicate records.

Add integration and end-to-end tests for the complete user journey.
Do not use hardcoded demo totals in production screens.
```

### Command 6 — Implement revision and daily planning

```text
Implement revision items, review history, flashcards (if included in
the existing product scope), daily plans, and task scheduling.

Follow the revision rules in MASTER_REBUILD.md. Preserve review history.
Generate plans from available minutes, incomplete chapters, priorities,
due revisions, exam date, and existing schedule. Prevent overlapping
and duplicate tasks. Let the user edit the generated plan.

Show why tasks were recommended and show a workload warning if the
remaining syllabus cannot fit into available time.

Add unit, integration, and end-to-end tests. Do not silently replace
an existing plan or delete revision history.
```

### Command 7 — Rebuild dashboard and analytics

```text
Implement the reference dashboard and Progress screens using real
domain-service results.

Include exam countdown, preparation summary, today's plan, revision
alerts, focus goal, subject progress, weekly activity, time per subject,
streaks, records, milestones, challenges, and charts where supported.

Every displayed metric must have a documented formula and source.
Use consistent timezone boundaries and rounding. Label syllabus
coverage separately from any weighted readiness estimate. Do not show
fake values or silently convert missing data to zero.

Add reconciliation tests proving that cards, charts, and subject pages
agree with the same underlying records.
```

### Command 8 — Match and improve the reference UI

```text
Compare the implemented application against all supplied screenshots
and MASTER_REBUILD.md.

Improve the mobile-first visual design: green/teal primary color,
neutral background, rounded cards, typography, spacing, progress
indicators, charts, timer, and bottom navigation.

Preserve existing framework conventions. Check all screen sizes,
safe areas, keyboard behavior, accessibility contrast, focus states,
empty/loading/error states, and navigation overlap. Do not sacrifice
functionality for screenshot similarity.

Run visual and end-to-end regression tests after each group of changes.
```

### Command 9 — Full QA and bug fixing

```text
Perform a complete QA pass against every requirement and acceptance
test in MASTER_REBUILD.md.

Run formatting, lint, type-check, unit tests, integration tests,
end-to-end tests, production build, and migration checks.

Manually verify:
- exam -> subjects -> chapters -> completion
- timer -> pause/resume -> finish -> analytics
- timer discard -> no study-time increase
- revision -> review -> next due date
- daily plan -> no overlaps or duplicates
- dashboard and Progress metric reconciliation
- timezone and midnight boundaries
- authorization between different users
- refresh/restart recovery

Fix root causes, not symptoms. Do not hide errors, weaken tests,
hardcode expected values, or remove failing tests. Produce
QA_REPORT.md with commands, pass/fail results, remaining bugs,
reproduction steps, and release blockers.
```

### Command 10 — Final release review

```text
Act as a senior engineer reviewing this application for release.

Read MASTER_REBUILD.md, AUDIT_REPORT.md, IMPLEMENTATION_PLAN.md,
and QA_REPORT.md. Inspect the actual code and test evidence.

Check security, authorization, data integrity, migrations, backups,
logging, privacy, performance, accessibility, responsive UI,
environment configuration, and deployment instructions.

Fix only verified release blockers. Ensure secrets are not committed.
Document local setup, environment variables (names only, no secret
values), database migration/backup/restore, test commands, build,
deployment, and known limitations in README.md.

Do not claim 100% bug-free. State exactly which tests passed,
which were not run, and what remains unverified.
```

---

## 10. Rules the coding agent must never violate

1. Do not replace the existing stack without approval.
2. Do not delete working modules just to simplify implementation.
3. Do not reset, truncate, or drop a database containing user data.
4. Do not use fake/static analytics values in real screens.
5. Do not calculate the same metric differently in multiple components.
6. Do not count breaks, planned minutes, or discarded sessions as study time.
7. Do not award duplicate milestones or create duplicate sessions.
8. Do not trust client-supplied totals or progress percentages.
9. Do not ignore timezone, midnight, rounding, or empty-data cases.
10. Do not mark a task complete unless its tests and acceptance criteria pass.
11. Do not hide a failing test or weaken an assertion to get a green build.
12. Keep a record of changed files, migrations, commands, test results, and known issues.

## 11. Final acceptance checklist

- [ ] Existing project audited before code changes.
- [ ] Existing working functionality preserved.
- [ ] App installs, starts, builds, and migrates successfully.
- [ ] Exams, subjects, and chapters persist correctly.
- [ ] Chapter completion and subject progress agree.
- [ ] Timer survives refresh/recovery without duplicate sessions.
- [ ] Only actual focus time counts toward study totals.
- [ ] Revision history and due dates work.
- [ ] Daily plans avoid overlap and duplication.
- [ ] Dashboard and analytics reconcile with source records.
- [ ] Streaks, milestones, and challenges pass boundary tests.
- [ ] User data is isolated and protected.
- [ ] Mobile and desktop layouts are usable.
- [ ] Unit, integration, and end-to-end tests pass.
- [ ] Backup, restore, setup, and deployment instructions exist.
- [ ] Remaining limitations are documented honestly.

---

## 12. Information needed to tailor this specification to the actual repository

The screenshots describe the target behavior and UI, but they do not reveal your existing source code, database schema, or current bugs.

For a repository-specific repair plan, provide:
- The project ZIP or repository files.
- Frontend and backend technologies.
- Database and ORM.
- The exact errors/logs you currently see.
- Which features currently work and which do not.

**Start with Command 1.** Do not ask the coding agent to implement all ten phases in one prompt. Audit first, then execute one phase at a time and verify the tests before moving forward.
