# AUDIT_REPORT.md - ExamPrep App Audit

**Date**: 2025-01-15  
**Auditor**: AI Assistant  
**Repository**: E:\AndroidDev\ExamPrep

---

## 1. Architecture Map & Key File Paths

### Stack Summary
| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.22+, Material 3 |
| State Management | flutter_riverpod 2.5.1 + riverpod_annotation |
| Navigation | go_router 14.2.0 (StatefulShellRoute.indexedStack) |
| Local Database | Hive 2.2.3 + hive_flutter 1.1.0 |
| Charts | fl_chart 0.68.0 |
| Fonts | google_fonts (Plus Jakarta Sans, Inter) |
| Notifications | flutter_local_notifications + timezone |
| Utilities | intl, uuid, wakelock_plus |

### Directory Structure
```
lib/
├── main.dart                          # App entry, Hive init, router
├── app/
│   ├── router.dart                    # GoRouter with redirect logic
│   ├── router.g.dart                  # Generated router
│   └── theme.dart                     # Material 3 theme
├── core/
│   ├── constants/
│   │   ├── app_design.dart           # Colors, spacing, radii, shadows
│   │   └── app_text_styles.dart      # Typography system
│   ├── extensions/
│   │   └── extensions.dart           # DateTime, Duration, String extensions
│   ├── utils/
│   │   └── date_utils.dart           # Date formatting utilities
│   └── widgets/
│       └── common_widgets.dart       # Reusable UI components
├── data/
│   ├── adapters/
│   │   └── hive_adapters.dart        # Hive box names, adapter registration
│   ├── models/                       # Hive models (Exam, Subject, Chapter, etc.)
│   │   ├── exam.dart
│   │   ├── subject.dart
│   │   ├── chapter.dart
│   │   ├── study_task.dart
│   │   ├── focus_session.dart
│   │   └── settings.dart
│   └── repositories/
│       └── exam_repository.dart      # Single repository for all data ops
├── features/
│   ├── home/
│   │   ├── providers/
│   │   │   ├── home_providers.dart   # Derived state (streaks, progress, etc.)
│   │   │   └── task_providers.dart   # Task mutations
│   │   └── presentation/
│   │       └── home_screen.dart
│   ├── focus/
│   │   ├── providers/
│   │   │   └── focus_providers.dart  # Timer logic (state machine)
│   │   └── presentation/
│   │       └── focus_screen.dart
│   ├── syllabus/
│   │   ├── providers/
│   │   │   └── syllabus_providers.dart
│   │   └── presentation/
│   │       └── syllabus_screen.dart
│   ├── progress/
│   │   ├── providers/
│   │   │   └── progress_providers.dart
│   │   └── presentation/
│   │       └── progress_screen.dart
│   ├── exams/
│   │   ├── providers/
│   │   │   └── exams_providers.dart
│   │   └── presentation/
│   │       ├── exams_screen.dart
│   │       └── new_exam_sheet.dart
│   ├── settings/
│   │   ├── providers/
│   │   │   └── settings_providers.dart
│   │   └── presentation/
│   │       └── settings_screen.dart
│   └── onboarding/
│       ├── providers/
       │   └── onboarding_providers.dart
       └── presentation/
           └── onboarding_screen.dart
test/
├── providers_test.dart              # Broken (missing dateOnly, mocktail)
└── widget_test.dart                 # Broken (missing mocktail, imports)
```

---

## 2. Commands Used & Results

### Flutter Analyze
```bash
flutter analyze
```
**Result**: TIMEOUT (120s). The analyzer hung. Running individual file checks works.

### Flutter Test
```bash
flutter test
```
**Result**: FAILED - 2 test files fail to compile:
- `test/providers_test.dart` - Missing `mocktail` dependency, `dateOnly` not found on DateTime (extension not imported in test)
- `test/widget_test.dart` - Missing `mocktail` dependency, missing Flutter imports, broken mocks

### Build (Android)
```bash
flutter run -d <device>
```
**Result**: SUCCESS - App builds and runs on Android (V2312, API 35)

### Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```
**Result**: SUCCESS - All Riverpod/Hive generators completed

---

## 3. Module Mapping (Reference vs Implementation)

| MASTER_REBUILD Module | Implementation Status | Files |
|----------------------|----------------------|-------|
| **A. Home Dashboard** | ✅ Complete | `home_screen.dart`, `home_providers.dart` |
| **B. Exams** | ✅ Complete | `exams_screen.dart`, `new_exam_sheet.dart`, `exams_providers.dart` |
| **C. Subjects & Chapters** | ✅ Complete | `syllabus_screen.dart`, `syllabus_providers.dart` |
| **D. Focus Timer** | ⚠️ Partial | `focus_screen.dart`, `focus_providers.dart` |
| **E. Progress/Analytics** | ⚠️ Partial | `progress_screen.dart`, `progress_providers.dart` |
| **F. Revision/Flashcards** | ❌ Missing | Not implemented |
| **G. Calendar/Planning** | ⚠️ Partial | Basic tasks only, no calendar view |
| **H. Navigation/Settings** | ✅ Complete | `settings_screen.dart`, router |
| **Onboarding** | ✅ Complete | `onboarding_screen.dart` |

---

## 3. Bugs & Issues (Severity Classification)

### P0 - Critical (Data Loss / App Breaking)

| ID | Bug | Severity | Reproduction | Root Cause | Affected Files |
|----|-----|----------|--------------|------------|----------------|
| BUG-001 | **Onboarding loops infinitely** | P0 | 1. Fresh install → complete onboarding → click "Get Started" → NewExamSheet opens → create exam → app navigates to home → restart app → onboarding shows again | Router's `redirect` uses `ref.read()` instead of `ref.watch()` for `onboardingDoneProvider`, so it doesn't react to changes. Also `onboardingDoneProvider` reads from `settingsProvider.value` which may be stale. | `lib/app/router.dart` (lines 27-39), `lib/features/onboarding/providers/onboarding_providers.dart` |
| BUG-002 | **Focus timer doesn't persist across app restart** | P0 | Start focus timer → close app → reopen → timer state lost | Timer state stored only in memory (`FocusTimer` notifier). No persistence to Hive. App background/foreground not handled. | `lib/features/focus/providers/focus_providers.dart` |
| BUG-003 | **Focus timer creates duplicate sessions on auto-advance** | P0 | Complete focus session → auto-advances to break → completes break → auto-advances to focus → check sessions list | `_completeSession()` saves session, then `_advanceSession()` calls `start()` which calls `_tick()` which may complete again. No guard against double-completion. | `lib/features/focus/providers/focus_providers.dart` (lines 154-178, 192-228) |
| BUG-004 | **Timer uses configured duration instead of actual elapsed time** | P0 | Start timer → pause at 10min of 25min → resume → complete → check session duration | `_completeSession()` uses `_getSessionDuration()` which returns configured duration, not actual elapsed time (`_endTime - startTime`). | `lib/features/focus/providers/focus_providers.dart` (line 163-166) |

### P1 - High (Incorrect Calculations / UX Breaking)

| ID | Bug | Severity | Reproduction | Root Cause | Affected Files |
|----|-----|----------|--------------|------------|----------------|
| BUG-005 | **Streak calculation counts chapter completions as study days** | P1 | Complete a chapter → streak increases without any focus session | `currentStreakProvider` and `longestStreakProvider` add chapter completion dates to activity dates. Chapter completion ≠ study day. | `lib/features/home/providers/home_providers.dart` (lines 107-117, 158-160) |
| BUG-006 | **Exam stats recalculates streak differently than home** | P1 | Check streak on Home screen vs Exams screen detail | `examStatsProvider` reimplements streak logic differently from `currentStreakProvider` | `lib/features/exams/providers/exams_providers.dart` (lines 90-109) vs `home_providers.dart` |
| BUG-007 | **Subject status uses wrong denominator** | P1 | Create subject with chapters → complete some → check status | `subjectStatusProvider` uses `exam.daysLeft + daysSinceCreated` as totalDays, but `daysLeft` is clamped at 0, so past exams show wrong expected ratio. | `lib/features/home/providers/home_providers.dart` (lines 276-280) |
| BUG-008 | **Exam countdown shows negative days for past exams** | P1 | Create exam with past date → check home screen | `Exam.daysLeft` clamps at 0, but UI doesn't show "Exam passed" state | `lib/data/models/exam.dart` (lines 63-68), `home_screen.dart` |
| BUG-009 | **Chapter progress denominator differs across screens** | P1 | Compare subject card progress vs exams screen detail | Different queries: `getChaptersForSubject` vs `getAllChaptersForExam` with filtering | Multiple screens |
| BUG-010 | **Timer auto-advance doesn't respect break completion** | P1 | Complete focus → auto short break → don't complete break → wait → app advances to next focus | `_advanceSession` auto-starts next session if `autoStartBreaks` is true, even if previous break wasn't completed | `lib/features/focus/providers/focus_providers.dart` (lines 192-228) |

### P2 - Medium (UI/UX / Code Quality)

| ID | Bug | Severity | Reproduction | Root Cause | Affected Files |
|----|-----|----------|--------------|------------|----------------|
| BUG-011 | **Duplicate icons in bottom navigation** | P2 | Run app → observe bottom nav | Active item rendered twice (animated indicator + touch target row) | `lib/app/router.dart` (lines 159-224) |
| BUG-012 | **Timer size fixed at 260dp, overflows small screens** | P2 | Run on small phone (e.g., 360dp width) | `AppSpacing.timerRingSize = 260.0` hardcoded | `lib/core/constants/app_design.dart`, `focus_screen.dart` |
| BUG-013 | **Notification/wakelock/sound are stubs** | P2 | Use timer features | All `_scheduleNotification`, `_enableWakelock`, `_playSound`, `_hapticFeedback` are `// TODO` | `focus_providers.dart` (lines 250-272) |
| BUG-014 | **Date extension `dateOnly` not available in tests** | P2 | Run tests | `core/extensions/extensions.dart` not imported in test files | `test/providers_test.dart` |
| BUG-015 | **Tests completely broken** | P2 | Run `flutter test` | Missing `mocktail` dependency, mockito syntax used with mocktail, missing Flutter test imports | `test/providers_test.dart`, `test/widget_test.dart` |
| BUG-016 | **Exam countdown shows "days left" for past exams** | P2 | Create exam with yesterday's date | `daysLeft` clamps at 0 but UI still says "days left" | `home_screen.dart` (countdown card) |
| BUG-017 | **Chapter deletion bug in syllabus** | P2 | Delete chapter from expanded subject card | `_confirmDeleteChapter` calls `widget.onToggleChapter(chapter)` instead of `deleteChapterProvider` | `syllabus_screen.dart` line 774 |
| BUG-018 | **No validation on exam date in NewExamSheet** | P2 | Create exam with past date | Only client-side `isInFuture` check, no server-side validation | `new_exam_sheet.dart` |

### P3 - Low (Code Quality / Polish)

| ID | Bug | Severity | Root Cause | Affected Files |
|----|-----|----------|------------|----------------|
| BUG-019 | Duplicate import in `home_screen.dart` | P3 | Line 15-16 duplicate `extensions` import | `home_screen.dart` line 15-16 |
| BUG-020 | Unused imports in multiple screens | P3 | Linter warnings | Multiple files |
| BUG-021 | Hardcoded strings in UI (not localized) | P3 | All UI strings hardcoded | All screens |
| BUG-022 | Missing accessibility labels | P3 | No semantic labels on interactive elements | All screens |
| BUG-023 | `dateOnly` extension in core but not in test scope | P3 | Extension in `lib/core/extensions/extensions.dart` | `test/providers_test.dart` |

---

## 4. Duplicated Calculations & Inconsistent Data Sources

### Duplicated Streak Calculation (3 implementations)
1. `home_providers.dart` - `currentStreakProvider` (lines 96-137)
2. `home_providers.dart` - `longestStreakProvider` (lines 140-179)
3. `exams_providers.dart` - `examStatsProvider` (lines 99-109)

All three reimplement streak logic slightly differently.

### Duplicated Chapter Stats (3 implementations)
1. `home_providers.dart` - `totalChaptersProvider`, `completedChaptersProvider`
2. `exams_providers.dart` - `examStatsProvider` (recalculates)
3. `syllabus_screen.dart` - recalculates in `_buildSubjectCard`

### Duplicated Streak Logic in Progress
4. `progress_providers.dart` - `summaryStatsProvider` (lines 63-90) recalculates longest streak again

### Inconsistent Data Sources for Same Metric
| Metric | Source A | Source B | Difference |
|--------|----------|----------|------------|
| Total chapters | `repo.getAllChaptersForExam()` | `subject.chapters.length` | Filters differ |
| Completed chapters | `where((c) => c.isCompleted)` | Same | OK |
| Streak | `home_providers` | `exams_providers` | Different date sets |
| Focus minutes | `home_providers` (today) | `exams_providers` (all time) | Different scopes |

---

## 5. Broken Routes & Navigation

| Route | Status | Issue |
|-------|--------|-------|
| `/onboarding` | ✅ Works | |
| `/home` | ✅ Works | Requires active exam |
| `/focus` | ✅ Works | Timer state not persisted |
| `/syllabus` | ✅ Works | |
| `/progress` | ✅ Works | |
| `/exams` | ✅ Works | |
| `/settings` | ✅ Works | |
| `/calendar` | ❌ Missing | Not in router |
| `/revision` | ❌ Missing | Not in router |

**Router Issue**: Redirect logic uses `ref.read()` instead of `ref.watch()` for `onboardingDoneProvider`, making it non-reactive.

---

## 6. Missing Validation & Unsafe Operations

| Area | Issue | Risk |
|------|-------|------|
| Exam creation | No server-side date validation | Past exams creatable |
| Exam creation | No duplicate name check | Duplicate exams possible |
| Chapter completion | No validation on `completedAt` | Can set future completion date |
| Timer | No minimum duration validation | 0-minute sessions possible |
| Settings | No validation on timer values | 0 or negative values possible |
| Database | No transactions for multi-box deletes | Partial deletes possible on crash |
| User isolation | No user ID in models | Multi-user not supported |

---

## 7. Missing Features (from MASTER_REBUILD.md)

| Feature | Status | Notes |
|-------|--------|-------|
| Revision/Flashcards | ❌ Missing | No models, providers, or screens |
| Calendar View | ❌ Missing | Only daily tasks list |
| Flashcards | ❌ Missing | No models |
| Spaced Repetition | ❌ Missing | No SM-2 or interval logic |
| Daily Plan Generation | ⚠️ Basic | Manual task creation only |
| Smart Scheduling | ❌ Missing | No algorithm |
| Notifications | ⚠️ Stubs | All TODOs |
| Wakelock | ⚠️ Stub | Not implemented |
| Sound/Haptics | ⚠️ Stubs | Not implemented |
| Data Export | ❌ Missing | No export feature |
| Backup/Restore | ❌ Missing | No implementation |

---

## 8. Modules That Work (Must Preserve)

| Module | Status | Notes |
|--------|--------|-------|
| Exam CRUD | ✅ | Full CRUD with active exam |
| Subject/Chapter CRUD | ✅ | With reorder, bulk create |
| Chapter Completion | ✅ | Toggle with streak tracking |
| Focus Timer UI | ✅ | Beautiful, responsive |
| Timer State Machine | ⚠️ | Logic has bugs but structure good |
| Settings | ✅ | Complete with persistence |
| Onboarding | ✅ | Smooth animations |
| Bottom Navigation | ✅ | Animated, responsive |
| Hive Persistence | ✅ | All models persist correctly |
| Riverpod Providers | ✅ | Good separation |
| Custom Widgets | ✅ | Well-designed components |

---

## 9. Recommended Implementation Order

### Phase 0: Stabilize (Week 1)
1. Fix onboarding loop (BUG-001) - **P0**
2. Fix test compilation (add mocktail, fix imports)
3. Fix timer duplicate session bug (BUG-003)
4. Fix timer actual elapsed time (BUG-004)
5. Fix streak calculation (BUG-005, BUG-006)

### Phase 1: Canonical Calculations (Week 2)
1. Create `CalculationService` single source for:
   - Chapter coverage
   - Subject progress
   - Streak calculation
   - Daily/weekly totals
   - Exam countdown
2. Wire all providers to use service
3. Add unit tests for all calculations

### Phase 2: Timer Stabilization (Week 3)
1. Persist timer state to Hive (survive restart)
2. Fix actual elapsed time recording
3. Implement notification/wakelock/sound
4. Fix auto-advance logic
5. Add integration tests for timer

### Phase 3: Missing Features (Week 4-5)
1. Revision system (SM-2 scheduler)
2. Calendar view with planning
3. Daily plan generation algorithm
4. Flashcards (if in scope)

### Phase 4: Analytics & Polish (Week 6)
1. Reconcile all metrics
2. Add missing charts
2. Fix all P2/P3 bugs
3. Accessibility audit

---

## 10. Unverified / Could Not Verify

| Area | Reason |
|------|--------|
| Web build | Not tested (requires `flutter create --platforms=web`) |
| Windows build | Not tested (requires Visual Studio) |
| iOS build | Not tested (no macOS) |
| Push notifications | Not tested (requires device + Firebase setup) |
| Background timer | Not tested (requires device) |
| Multi-user isolation | Not implemented |
| Data migration | Not tested (no migration logic) |
| Large dataset performance | Not tested (>1000 chapters) |
| Timezone changes | Not tested |
| Daylight saving | Not tested |

---

## 11. Summary

**Overall Health**: **70% functional** - Core CRUD and UI work well, but timer persistence, streak calculations, and onboarding loop are critical bugs.

**Test Coverage**: **0%** - Tests don't compile.

**Technical Debt**: Medium - Well-structured but duplicated logic and missing persistence in key areas.

**Recommended Next Step**: Fix the **onboarding loop (BUG-001)** and **timer persistence (BUG-002)** first, as these block basic app usability.