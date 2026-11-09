# IMPLEMENTATION_PLAN.md - ExamPrep Implementation Plan

**Based on**: MASTER_REBUILD.md + AUDIT_REPORT.md  
**Generated**: 2025-01-15  
**Approach**: Phase-based, data-integrity first, preserve working code

---

## Phase 0: Stabilize Foundation (Week 1)
**Goal**: Fix critical blockers, make tests pass, establish CI baseline

### Task 0.1: Fix Onboarding Infinite Loop (BUG-001) — P0
**Objective**: Fix router redirect to properly react to `onboardingDone` changes

| Aspect | Details |
|--------|---------|
| **Objective** | Fix router redirect to use `ref.watch()` so it reacts to `onboardingDone` changes |
| **Affected Files** | `lib/app/router.dart` (lines 27-39) |
| **Dependencies** | `onboardingDoneProvider` must be stable |
| **Migration Impact** | None (logic fix only) |
| **Test Cases** | 1. Fresh install → complete onboarding → app restarts → stays on home<br>2. Fresh install → skip onboarding → app restarts → stays on home<br>3. Reset data → onboarding shows again |
| **Acceptance Criteria** | • Onboarding completes once and never repeats<br>• Router redirects correctly on app restart<br>• No infinite redirect loops |
| **Rollback** | Revert `router.dart` to previous version |
| **Files to Modify** | `lib/app/router.dart` (lines 27-39: change `ref.read` → `ref.watch`) |

### Task 0.2: Fix Test Compilation — P0
**Objective**: Make tests compile and run

| Aspect | Details |
|--------|---------|
| **Objective** | Fix test dependencies and imports |
| **Affected Files** | `pubspec.yaml`, `test/providers_test.dart`, `test/widget_test.dart` |
| **Dependencies** | Add `mocktail` to dev_dependencies |
| **Migration Impact** | None (test-only) |
| **Test Cases** | `flutter test` passes without compilation errors |
| **Acceptance Criteria** | `flutter test` runs and shows results (even if tests fail logically) |
| **Rollback** | Revert pubspec.yaml and test files |
| **Files to Modify** | `pubspec.yaml` (add `mocktail: ^1.0.0`), `test/providers_test.dart` (add extensions import), `test/widget_test.dart` (fix imports, use mocktail correctly) |

### Task 0.3: Fix Timer Duplicate Session Bug (BUG-003) — P0
**Objective**: Prevent duplicate sessions on auto-advance

| Aspect | Details |
|--------|---------|
| **Objective** | Add guard to prevent double-completion on auto-advance |
| **Affected Files** | `lib/features/focus/providers/focus_providers.dart` (lines 154-178, 192-228) |
| **Dependencies** | Task 0.1 (router stable) |
| **Migration Impact** | None (logic fix) |
| **Test Cases** | 1. Complete focus → auto short break → complete break → verify only 2 sessions<br>2. Complete focus → skip break → verify 1 session<br>3. Pause/resume during break → verify no duplicate |
| **Acceptance Criteria** | • No duplicate sessions created on auto-advance<br>• `_completeSession` called exactly once per session |
| **Rollback** | Revert `focus_providers.dart` changes |
| **Files to Modify** | `lib/features/focus/providers/focus_providers.dart` (add `_isCompleting` guard in `_completeSession` and `_advanceSession`) |

### Task 0.4: Fix Timer Records Configured Duration Instead of Actual Elapsed (BUG-004) — P0
**Objective**: Record actual elapsed time, not configured duration

| Aspect | Details |
|--------|---------|
| **Objective** | Record actual elapsed time when session completes |
| **Affected Files** | `lib/features/focus/providers/focus_providers.dart` (lines 160-166, 180-190) |
| **Dependencies** | Task 0.3 |
| **Migration Impact** | Session duration calculation changes |
| **Test Cases** | 1. Start 25min timer → pause at 10min → resume → complete at 15min actual → session shows 15min<br>2. Start → complete without pause → shows configured duration |
| **Acceptance Criteria** | • Actual elapsed time recorded, not configured duration<br>• Paused time excluded from duration |
| **Rollback** | Revert `focus_providers.dart` changes |
| **Files to Modify** | `lib/features/focus/providers/focus_providers.dart` (track actual start time, compute elapsed on complete) |

### Task 0.5: Fix Streak Calculation (BUG-005, BUG-006) — P1
**Objective**: Unify streak calculation, exclude chapter completions

| Aspect | Details |
|--------|---------|
| **Objective** | Single streak implementation; only focus sessions count |
| **Affected Files** | `lib/features/home/providers/home_providers.dart` (lines 96-179), `lib/features/exams/providers/exams_providers.dart` (lines 90-109) |
| **Dependencies** | Task 0.1-0.4 complete |
| **Migration Impact** | Streak values may change for existing users |
| **Test Cases** | 1. No activity → streak 0<br>2. Focus session today → streak 1<br>3. Focus session yesterday + today → streak 2<br>4. Chapter completion only → streak 0<br>5. Focus session today, gap tomorrow, focus day after → streak 1 |
| **Acceptance Criteria** | • Single streak implementation shared by all providers<br>• Chapter completions don't count as study days<br>• Home and Exams screens show identical streak |
| **Rollback** | Revert both provider files |
| **Files to Modify** | Create `lib/core/services/calculation_service.dart`, update `home_providers.dart` and `exams_providers.dart` to use it |

### Task 0.6: Fix Exam Countdown for Past Exams (BUG-008, BUG-016) — P1
**Objective**: Show "Exam passed" instead of "0 days left"

| Aspect | Details |
|--------|---------|
| **Objective** | Display "Exam passed" when exam date has passed |
| **Affected Files** | `lib/data/models/exam.dart` (add `isPast` getter), `lib/features/home/presentation/home_screen.dart` (countdown card) |
| **Dependencies** | None |
| **Migration Impact** | UI text change only |
| **Test Cases** | 1. Future exam → shows "X days left"<br>2. Today exam → shows "Today"<br>3. Past exam → shows "Exam passed" |
| **Acceptance Criteria** | • Past exams show "Exam passed" not "0 days left"<br>• UI clearly distinguishes past/upcoming |
| **Rollback** | Revert model and screen changes |
| **Files to Modify** | `lib/data/models/exam.dart` (add `isPast` getter), `home_screen.dart` countdown card |

### Task 0.7: Fix Test Infrastructure — P2
**Objective**: Make `flutter test` pass

| Aspect | Details |
|--------|---------|
| **Objective** | Fix all test compilation errors |
| **Affected Files** | `pubspec.yaml`, `test/providers_test.dart`, `test/widget_test.dart` |
| **Dependencies** | Task 0.2 |
| **Test Cases** | `flutter test` exits with code 0 |
| **Acceptance Criteria** | All test files compile and run (logical correctness not required yet) |
| **Rollback** | Revert test files |
| **Files to Modify** | `pubspec.yaml` (add mocktail), `test/providers_test.dart` (import extensions, fix dateOnly), `test/widget_test.dart` (fix imports, use mocktail correctly) |

### Task 0.8: Fix Settings Validation — P1
**Objective**: Add validation to timer settings

| Aspect | Details |
|--------|---------|
| **Objective** | Prevent invalid timer values (0, negative, excessive) |
| **Affected Files** | `lib/features/settings/presentation/settings_screen.dart`, `lib/data/models/settings.dart` |
| **Dependencies** | None |
| **Test Cases** | 1. Set focus to 0 → shows error, reverts<br>2. Set focus to -5 → shows error<br>3. Set focus to 180 → shows error (max 120)<br>3. Valid values (5-120) accepted |
| **Acceptance Criteria** | • Invalid values rejected with user feedback<br>• Valid values saved correctly |
| **Rollback** | Revert settings screen and model |
| **Files to Modify** | `settings_screen.dart` (add validation in `_updateSettings`), `settings.dart` (add validation in copyWith) |

### Task 0.9: Fix Duplicate Bottom Nav Icons (BUG-011) — P2
**Objective**: Remove duplicate active icon in bottom nav

| Aspect | Details |
|--------|---------|
| **Objective** | Show active item only in animated indicator, not in touch row |
| **Affected Files** | `lib/app/router.dart` (lines 205-224) |
| **Dependencies** | None |
| **Test Cases** | 1. Active tab shows icon+label in indicator only<br>2. Inactive tabs show icons in row<br>3. Tap inactive → becomes active, indicator animates |
| **Acceptance Criteria** | • No duplicate icons visible<br>• Touch targets still work |
| **Rollback** | Revert `_CustomBottomNavBar.build` |
| **Files to Modify** | `lib/app/router.dart` (touch targets row: skip currentIndex) |

### Task 0.10: Fix Chapter Deletion Bug (BUG-017) — P2
**Objective**: Delete chapter calls correct provider

| Aspect | Details |
|--------|---------|
| **Objective** | Fix `_confirmDeleteChapter` to call `deleteChapterProvider` |
| **Affected Files** | `lib/features/syllabus/presentation/syllabus_screen.dart` (line 774) |
| **Dependencies** | None |
| **Test Cases** | 1. Expand subject → tap chapter menu → Delete → chapter removed<br>2. Cancel deletion → chapter remains |
| **Acceptance Criteria** | • Delete removes chapter from list<br>• No crash |
| **Rollback** | Revert line 774 |
| **Files to Modify** | `syllabus_screen.dart` line 774 (change `onToggleChapter` to `deleteChapterProvider`) |

---

## Phase 1: Canonical Calculation Service (Week 2)
**Goal**: Single source of truth for all calculations

### Task 1.1: Create CalculationService — P0
**Objective**: Centralize all calculations in one service

| Aspect | Details |
|--------|---------|
| **Objective** | Create single authoritative service for all calculations |
| **Affected Files** | New: `lib/core/services/calculation_service.dart`<br>Modify: All providers using calculations |
| **Dependencies** | Tasks 0.1-0.9 complete |
| **Migration Impact** | All calculation logic moves; providers become thin wrappers |
| **Test Cases** | Unit tests for every public method:<br>- Chapter coverage (0, partial, full)<br>- Subject progress (0, partial, full)<br>- Streak (empty, single day, multi-day, gap, chapter-only)<br>- Daily/weekly totals (empty, partial, full week)<br>- Daily goal progress (0%, partial, 100%, over)<br>- Consistency score (0/14, 7/14, 14/14)<br>- Milestone progress (at target, over, under)<br>- Exam countdown (future, today, past, leap year) |
| **Acceptance Criteria** | • All calculations in one class<br>• All providers delegate to service<br>• 100% unit test coverage for service<br>• No calculation logic in UI/providers |
| **Rollback** | Delete service, revert providers |
| **Files to Create/Modify** | New: `lib/core/services/calculation_service.dart`<br>Modify: `home_providers.dart`, `exams_providers.dart`, `progress_providers.dart`, `syllabus_providers.dart` |

### Task 1.2: Wire Providers to CalculationService — P0
**Objective**: All providers delegate to CalculationService

| Aspect | Details |
|--------|---------|
| **Objective** | Remove duplicated logic from providers |
| **Affected Files** | `home_providers.dart`, `exams_providers.dart`, `progress_providers.dart`, `syllabus_providers.dart` |
| **Dependencies** | Task 1.1 complete |
| **Migration Impact** | Providers become thin wrappers |
| **Test Cases** | 1. All existing provider tests pass<br>2. Home/Exams/Progress screens show identical values<br>3. No calculation logic remains in provider files |
| **Acceptance Criteria** | • Zero calculation logic in provider files<br>• All metrics consistent across screens<br>• Unit tests pass |
| **Rollback** | Revert provider changes |
| **Files to Modify** | `home_providers.dart`, `exams_providers.dart`, `progress_providers.dart`, `syllabus_providers.dart` |

### Task 1.3: Add Calculation Unit Tests — P0
**Objective**: 100% coverage for CalculationService

| Aspect | Details |
|--------|---------|
| **Objective** | Comprehensive test coverage for all calculations |
| **Affected Files** | New: `test/calculation_service_test.dart` |
| **Dependencies** | Task 1.1 complete |
| **Test Cases** | See Task 1.1 test cases + edge cases:<br>- Empty data<br>- Boundary values (0, 1, max)<br>- Rounding (520/600 = 86.67% → 87%)<br>- Timezone boundaries<br>- Leap year<br>- DST transitions<br>- Empty data |
| **Acceptance Criteria** | • 100% line coverage<br>• All edge cases covered<br>• Tests run in <5 seconds |
| **Rollback** | Delete test file |
| **Files to Create** | `test/calculation_service_test.dart` |

---

## Phase 2: Timer Stabilization (Week 3)

### Task 2.1: Persist Timer State to Hive — P0
**Objective**: Timer survives app restart

| Aspect | Details |
|--------|---------|
| **Objective** | Save/restore timer state (type, remaining, running, completed count) to Hive |
| **Affected Files** | New: `lib/data/models/timer_state.dart`<br>Modify: `focus_providers.dart`, `exam_repository.dart` |
| **Dependencies** | Phase 0 complete, Hive box for timer state |
| **Migration Impact** | New Hive box; existing timer state lost on upgrade (acceptable) |
| **Test Cases** | 1. Start timer → kill app → reopen → timer resumes with correct remaining<br>2. Pause timer → kill app → reopen → timer paused with correct remaining<br>3. Timer completed → kill app → reopen → shows completed state |
| **Acceptance Criteria** | • Timer state survives app kill/restart<br>• No data loss on crash<br>• Backward compatible (no timer state = fresh start) |
| **Rollback** | Remove timer state box, revert FocusTimer |
| **Files to Create/Modify** | New: `lib/data/models/timer_state.dart`, `lib/data/adapters/timer_state.g.dart`<br>Modify: `lib/data/repositories/exam_repository.dart`, `lib/features/focus/providers/focus_providers.dart`, `lib/data/adapters/hive_adapters.dart` |

### Task 2.2: Fix Actual Elapsed Time Recording — P0
**Objective**: Timer records actual elapsed, not configured duration

| Aspect | Details |
|--------|---------|
| **Objective** | Timer records wall-clock elapsed time (excluding pauses) |
| **Affected Files** | `lib/features/focus/providers/focus_providers.dart` |
| **Dependencies** | Task 2.1 |
| **Migration Impact** | Session duration values change for existing users |
| **Test Cases** | 1. Start 25min → pause at 10:00 → resume → complete at 15:00 actual → duration = 15min<br>2. Multiple pauses → total paused time excluded<br>3. App backgrounded during timer → time continues |
| **Acceptance Criteria** | • Actual wall-clock elapsed recorded<br>• Paused time excluded<br>• Survives app backgrounding |
| **Rollback** | Revert FocusTimer changes |
| **Files to Modify** | `lib/features/focus/providers/focus_providers.dart` (track actual start, compute elapsed on complete) |

### Task 2.3: Implement Notification/Wakelock/Sound — P1
**Objective**: Replace stubs with working implementations

| Aspect | Details |
|--------|---------|
| **Objective** | Implement actual notifications, wakelock, sound, haptics |
| **Affected Files** | `lib/features/focus/providers/focus_providers.dart` (lines 250-272) |
| **Dependencies** | `flutter_local_notifications`, `wakelock_plus`, `audioplayers`/`just_audio` |
| **Test Cases** | 1. Timer completes → notification fires<br>2. Timer completes → sound plays<br>3. Timer completes → haptic feedback<br>4. Timer running → screen stays on |
| **Acceptance Criteria** | • All TODOs replaced with working code<br>• Permissions handled gracefully<br>• Respects user settings (sound/vibration toggles) |
| **Rollback** | Revert to stubs |
| **Files to Modify** | `pubspec.yaml` (add dependencies), `focus_providers.dart` (implement TODOs) |

### Task 2.4: Fix Auto-Advance Logic — P1
**Objective**: Only auto-advance if break was completed

| Aspect | Details |
|--------|---------|
| **Objective** | Only auto-start next session if previous break completed |
| **Affected Files** | `lib/features/focus/providers/focus_providers.dart` (lines 192-228) |
| **Dependencies** | Task 2.2 |
| **Test Cases** | 1. Focus → complete break → auto-starts next focus ✓<br>2. Focus → skip break → no auto-advance ✓<br>3. Focus → pause break → no auto-advance ✓<br>4. Auto-start disabled → no auto-advance ✓ |
| **Acceptance Criteria** | • Only completed breaks trigger auto-advance<br>• Respects `autoStartBreaks` setting |
| **Rollback** | Revert `_advanceSession` logic |
| **Files to Modify** | `lib/features/focus/providers/focus_providers.dart` (`_advanceSession` method) |

### Task 2.4: Fix Timer Responsiveness (BUG-012) — P2
**Objective**: Timer scales to screen size

| Aspect | Details |
|--------|---------|
| **Objective** | Timer circle scales with screen width |
| **Affected Files** | `lib/features/focus/presentation/focus_screen.dart` (already partially fixed), `lib/core/constants/app_design.dart` |
| **Dependencies** | None |
| **Test Cases** | 1. Small phone (360dp) → timer fits<br>2. Large phone (420dp) → timer scales up<br>3. Tablet (600dp+) → max 280dp |
| **Acceptance Criteria** | • Timer fits all screen sizes<br>• Text remains readable<br>• No overflow |
| **Rollback** | Revert `focus_screen.dart` timer size logic |
| **Files to Modify** | `lib/features/focus/presentation/focus_screen.dart` (already has responsive logic, verify), `app_design.dart` (remove hardcoded timerRingSize) |

### Task 2.5: Add Timer Integration Tests — P1
**Objective**: End-to-end timer tests

| Aspect | Details |
|--------|---------|
| **Objective** | Integration tests for complete timer flows |
| **Affected Files** | New: `test/focus_timer_integration_test.dart` |
| **Dependencies** | Tasks 2.1-2.4 complete |
| **Test Cases** | 1. Full focus→break→focus cycle<br>2. Pause/resume during focus<br>3. Skip break<br>4. Reset during focus<br>5. App background/foreground during timer<br>6. App kill/restart during timer |
| **Acceptance Criteria** | • All integration tests pass<br>• No flaky tests<br>• Run in <30 seconds |
| **Rollback** | Delete test file |
| **Files to Create** | `test/focus_timer_integration_test.dart` |

---

## Phase 3: Missing Features (Week 4-5)

### Task 3.1: Create Revision Models — P0
**Objective**: Add RevisionItem and RevisionReview models

| Aspect | Details |
|--------|---------|
| **Objective** | Add SM-2 based revision models |
| **Affected Files** | New: `lib/data/models/revision_item.dart`, `lib/data/models/revision_review.dart`, `lib/data/models/flashcard.dart`<br>Modify: `lib/data/adapters/hive_adapters.dart`, `lib/main.dart` |
| **Dependencies** | Phase 1 complete |
| **Migration Impact** | New Hive boxes; no existing data affected |
| **Test Cases** | 1. RevisionItem CRUD<br>2. Flashcard CRUD<br>3. RevisionReview with SM-2 intervals |
| **Acceptance Criteria** | • Models compile and persist<br>• SM-2 interval calculation correct<br>• Hive adapters generated |
| **Rollback** | Delete model files, revert adapters |
| **Files to Create/Modify** | New model files, update `hive_adapters.dart`, `main.dart` |

### Task 3.2: Create Revision Providers — P0
**Objective**: Riverpod providers for revision system

| Aspect | Details |
|--------|---------|
| **Objective** | Providers for revision CRUD, review, scheduling |
| **Affected Files** | New: `lib/features/revision/providers/revision_providers.dart` |
| **Dependencies** | Task 3.1 |
| **Test Cases** | 1. Add revision item<br>2. Review item (again/hard/good/easy) → next due date correct<br>3. Overdue items query<br>4. Due today query |
| **Acceptance Criteria** | • All revision operations work<br>• SM-2 intervals calculated correctly<br>• History preserved |
| **Rollback** | Delete provider file |
| **Files to Create** | `lib/features/revision/providers/revision_providers.dart` |

### Task 3.3: Revision UI Screens — P0
**Objective**: Revision list, review, flashcard screens

| Aspect | Details |
|--------|---------|
| **Objective** | UI for revision system |
| **Affected Files** | New: `lib/features/revision/presentation/revision_screen.dart`, `revision_review_screen.dart`, `flashcard_screen.dart` |
| **Dependencies** | Task 3.2 |
| **Test Cases** | 1. List shows due/overdue/upcoming<br>2. Review flow: again/hard/good/easy<br>3. Flashcard flip<br>4. Empty states |
| **Acceptance Criteria** | • All revision screens functional<br>• Matches reference UI<br>• Accessible |
| **Rollback** | Delete screen files |
| **Files to Create** | 3 new screen files |

### Task 3.3: Calendar View — P1
**Objective**: Monthly/weekly calendar view

| Aspect | Details |
|--------|---------|
| **Objective** | Calendar showing tasks, sessions, exams |
| **Affected Files** | New: `lib/features/calendar/presentation/calendar_screen.dart`, providers |
| **Dependencies** | Phase 2 complete |
| **Test Cases** | 1. Month view with exam dates<br>2. Week view with tasks<br>3. Tap date → see details<br>4. Responsive layout |
| **Acceptance Criteria** | • Calendar renders correctly<br>• Shows exams, tasks, sessions<br>• Responsive on mobile/desktop |
| **Rollback** | Delete calendar feature |
| **Files to Create** | Calendar screen, providers, router entry |

### Task 3.4: Daily Plan Generation — P1
**Objective**: Smart daily plan algorithm

| Aspect | Details |
|--------|---------|
| **Objective** | Generate daily plan from available time, priorities, due revisions |
| **Affected Files** | New: `lib/core/services/plan_generator.dart`, providers, UI |
| **Dependencies** | Phase 3.1-3.2 complete |
| **Test Cases** | 1. Available time filled optimally<br>2. Overdue revisions first<br>3. Due today revisions<br>3. Priority chapters by exam proximity<br>4. No overlapping tasks<br>5. Breaks inserted<br>6. Workload warning if over capacity |
| **Acceptance Criteria** | • Algorithm produces valid plans<br>• Workload warning shown<br>• User can edit generated plan |
| **Rollback** | Delete plan generator |
| **Files to Create** | `lib/core/services/plan_generator.dart`, plan providers, plan screen |

---

## Phase 4: Analytics & Polish (Week 6)

### Task 4.1: Reconcile All Metrics — P0
**Objective**: All screens show identical values

| Aspect | Details |
|--------|---------|
| **Objective** | Verify all metrics reconcile across screens |
| **Affected Files** | All providers and screens |
| **Dependencies** | Phase 1 complete |
| **Test Cases** | 1. Home streak = Exams streak = Progress streak<br>2. Home progress = Exams progress = Progress progress<br>3. Weekly charts match summary cards<br>4. Subject progress matches across screens |
| **Acceptance Criteria** | • Zero metric discrepancies<br>• Automated reconciliation test passes |
| **Rollback** | N/A (verification only) |
| **Files to Modify** | Add reconciliation test in `test/reconciliation_test.dart` |

### Task 4.2: Fix Remaining P2/P3 Bugs — P2
**Objective**: Address remaining medium/low priority bugs

| Aspect | Details |
|--------|---------|
| **Objective** | Fix all remaining P2/P3 bugs from audit |
| **Affected Files** | Multiple (see BUG-011 through BUG-023) |
| **Dependencies** | Phase 0-3 complete |
| **Test Cases** | Each bug has specific test case |
| **Acceptance Criteria** | • All P2/P3 bugs resolved<br>• No regressions |
| **Rollback** | Per-bug rollback |
| **Files to Modify** | Multiple (see AUDIT_REPORT.md P2/P3 sections) |

### Task 4.3: Accessibility Audit — P2
**Objective**: WCAG 2.1 AA compliance

| Aspect | Details |
|--------|---------|
| **Objective** | Meet accessibility standards |
| **Affected Files** | All screens |
| **Dependencies** | Phase 4.2 complete |
| **Test Cases** | 1. Screen reader navigation<br>2. Contrast ratios (4.5:1)<br>3. Touch target sizes (48dp)<br>4. Focus indicators<br>5. Semantic labels |
| **Acceptance Criteria** | • Passes axe-core audit<br>• Manual screen reader test passes |
| **Rollback** | N/A |
| **Files to Modify** | All screen files (add semantics, labels, contrast) |

### Task 4.4: Performance & Security — P2
**Objective**: Production readiness

| Aspect | Details |
|--------|---------|
| **Objective** | Performance benchmarks, security hardening |
| **Affected Files** | Multiple |
| **Dependencies** | Phase 4.3 complete |
| **Test Cases** | 1. App startup < 2s<br>2. Screen transitions < 300ms<br>3. 1000 chapters → smooth scroll<br>4. No secrets in code<br>5. SQL injection impossible (Hive) |
| **Acceptance Criteria** | • Meets performance budgets<br>• Security scan passes |
| **Rollback** | N/A |
| **Files to Modify** | Multiple (optimization) |

### Task 4.5: Documentation & Release Prep — P2
**Objective**: Production deployment ready

| Aspect | Details |
|--------|---------|
| **Objective** | Complete documentation and release artifacts |
| **Affected Files** | `README.md`, `CHANGELOG.md`, `DEPLOYMENT.md`, `pubspec.yaml` (version) |
| **Dependencies** | All previous tasks |
| **Test Cases** | 1. Clean build produces working APK/IPA<br>2. Migration from v0 works<br>3. Backup/restore documented |
| **Acceptance Criteria** | • All docs complete<br>• Release builds successfully<br>• Known limitations documented |
| **Rollback** | Revert version bump |
| **Files to Modify** | `README.md`, `CHANGELOG.md`, `pubspec.yaml`, new `DEPLOYMENT.md` |

---

## Missing Product Decisions (Blocking Questions)

| # | Question | Blocks |
|-----|----------|--------|
| 1 | **Revision scope**: Implement full SM-2 + flashcards, or just basic revision tracking? | Task 3.1-3.3 |
| 2 | **Calendar scope**: Full month/week/day views with drag-drop, or read-only month view? | Task 3.3 |
| 3 | **Daily plan**: Auto-generate and auto-schedule, or generate as draft for user to confirm? | Task 3.4 |
| 4 | **Multi-user**: Support multiple users on device, or single-user only? | Data model |
| 5 | **Cloud sync**: Local-only, or plan for Firebase/Supabase sync? | Architecture |
| 5 | **Platforms**: iOS/Web/Windows/Desktop all required, or Android-first? | Build config |

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Timer persistence breaks existing sessions | Medium | High | Add migration, default to fresh start |
| Streak recalculation changes user stats | High | Medium | Document change, consider migration |
| CalculationService breaks existing providers | Low | High | Incremental migration, feature flag |
| Android 14 notification permission | Medium | High | Handle gracefully, fallback to in-app |
| Hive migration on schema change | Low | High | Version boxes, write migrations |

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Test coverage (domain) | >90% |
| Test coverage (UI) | >70% |
| Build time | < 3 min |
| App startup (cold) | < 2s |
| Screen transition | < 300ms |
| Zero P0 bugs | 0 |
| Zero P1 bugs | 0 |
| Accessibility score | 100% (axe) |

---

## Sign-off Checklist

- [ ] Phase 0: All P0 bugs fixed, tests compile
- [ ] Phase 1: CalculationService complete, 100% unit tests
- [ ] Phase 2: Timer persists, records actual time, notifications work
- [ ] Phase 3: Revision + Calendar + Planning functional
- [ ] Phase 4: Metrics reconcile, P2/P3 fixed, accessible, documented
- [ ] Release: Clean build, migration tested, docs complete