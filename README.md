# ExamPrep

A production-quality, offline-first exam preparation app built with Flutter. Features a beautiful pink-themed design with exam tracking, Pomodoro focus timer, syllabus management, progress analytics, and local notifications.

## Features

- **Exam Tracking**: Create and manage multiple exams with countdown timers
- **Focus Timer**: Pomodoro-style timer with focus sessions, short breaks, and long breaks
- **Syllabus Management**: Organize subjects and chapters with progress tracking
- **Progress Analytics**: Visual charts showing weekly progress, focus time, and streaks
- **Task Management**: Daily study tasks with due dates
- **Local Notifications**: Timer completion and daily reminder notifications
- **Offline-First**: All data stored locally using Hive database
- **Beautiful UI**: Custom pink-themed design with smooth animations

## Tech Stack

- **Flutter 3.22+** / **Dart 3** (null-safe)
- **State Management**: `flutter_riverpod` with code generation
- **Navigation**: `go_router` with `StatefulShellRoute.indexedStack`
- **Local Database**: `hive` + `hive_flutter` with generated adapters
- **Charts**: `fl_chart` for progress visualization
- **Fonts**: `google_fonts` (Plus Jakarta Sans for UI, Inter for numbers)
- **Notifications**: `flutter_local_notifications` + `timezone`
- **Utilities**: `intl`, `uuid`, `wakelock_plus`

## Architecture

```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── router.dart          # GoRouter configuration with bottom nav
│   ├── theme.dart           # Material 3 theme with custom design system
│   └── app.dart             # App widget
├── core/
│   ├── constants/
│   │   ├── app_design.dart  # Colors, spacing, radii, shadows, durations
│   │   └── app_text_styles.dart # Typography system
│   ├── extensions/
│   │   └── extensions.dart  # Dart extensions for DateTime, Duration, etc.
│   ├── utils/
│   │   └── date_utils.dart  # Date formatting utilities
│   └── widgets/
│       └── common_widgets.dart # Reusable UI components
├── data/
│   ├── models/
│   │   ├── exam.dart
│   │   ├── subject.dart
│   │   ├── chapter.dart
│   │   ├── study_task.dart
│   │   ├── focus_session.dart
│   │   └── settings.dart
│   ├── adapters/
│   │   └── hive_adapters.dart # Hive adapter registration
│   └── repositories/
│       └── exam_repository.dart # Data access layer
└── features/
    ├── home/
    │   ├── presentation/
    │   │   └── home_screen.dart
    │   └── providers/
    │       ├── home_providers.dart    # Derived state providers
    │       └── task_providers.dart    # Task mutations
    ├── focus/
    │   ├── presentation/
    │   │   └── focus_screen.dart
    │   └── providers/
    │       └── focus_providers.dart   # Timer state management
    ├── syllabus/
    │   ├── presentation/
    │   │   └── syllabus_screen.dart
    │   └── providers/
    │       └── syllabus_providers.dart
    ├── progress/
    │   ├── presentation/
    │   │   └── progress_screen.dart
    │   └── providers/
    │       └── progress_providers.dart
    ├── exams/
    │   ├── presentation/
    │   │   ├── exams_screen.dart
    │   │   └── new_exam_sheet.dart
    │   └── providers/
    │       └── exams_providers.dart
    ├── settings/
    │   ├── presentation/
    │   │   └── settings_screen.dart
    │   └── providers/
    │       └── settings_providers.dart
    └── onboarding/
        ├── presentation/
        │   └── onboarding_screen.dart
        └── providers/
            └── onboarding_providers.dart
```

## Design System

### Colors
- **Primary Pink**: `#E9547B`
- **Gradient**: `#F07A98` → `#E04A72`
- **Background**: `#FCE4EC` → `#FFF7F9` (vertical gradient)
- **Surface**: White at 92% opacity
- **Success Green**: `#34B98A`
- **Indigo**: `#2E3192`
- **Blue**: `#3D7BF5`
- **Orange**: `#F57C3A`
- **Purple**: `#8B6CF0`

### Typography
- **Screen Title**: Plus Jakarta Sans 28/700
- **Body**: Plus Jakarta Sans 14/500
- **Huge Numbers**: Inter 84/800
- **Timer**: Inter 64/800
- **Stat Numbers**: Plus Jakarta Sans 24/700

### Components
- `AppScaffold` - Gradient background with sparkles
- `SoftCard` - White card with subtle shadow
- `IconBadge` - Colored icon in soft background
- `PillProgressBar` - Animated progress bar
- `ExamSelectorChip` - Exam switcher with dropdown
- `ProgressRing` - Circular progress indicator
- `PrimaryPillButton` - Main action button
- `SegmentedControl` - Animated segment selector
- Custom floating bottom navigation

## Getting Started

### Prerequisites
- Flutter SDK 3.22+
- Dart 3.0+
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ExamPrep
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Riverpod, Hive adapters):
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Code Generation

The project uses code generation for:
- Riverpod providers (`@riverpod`)
- Hive type adapters (`@HiveType`)

After modifying models or providers, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch for changes:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Project Structure Details

### Data Models (Hive)

All models are `@HiveType` annotated with generated adapters:
- **Exam**: id, name, examDate, createdAt, isActive, colorValue, dailyGoalMinutes
- **Subject**: id, examId, name, order, colorValue
- **Chapter**: id, subjectId, name, order, isCompleted, completedAt
- **StudyTask**: id, examId, title, subjectId, chapterId, dueDate, isDone, createdAt
- **FocusSession**: id, examId, type, startedAt, durationMinutes, completed, completedAt
- **Settings**: focusMinutes, shortBreakMinutes, longBreakMinutes, sessionsBeforeLongBreak, autoStartBreaks, sound, vibration, dailyReminderTime, onboardingDone

### State Management (Riverpod)

Providers are organized by feature:
- **Repository Provider**: Single `ExamRepository` instance
- **Stream Providers**: Watch boxes for reactive UI
- **Derived Providers**: Computed values (daysLeft, percentPrepared, streaks, weekly data)
- **Notifier Providers**: Mutable state (FocusTimer, Settings)

### Navigation

Uses `StatefulShellRoute.indexedStack` for 5 bottom tabs:
1. **Home** (`/home`) - Dashboard with countdown, stats, focus card, tasks
2. **Focus** (`/focus`) - Pomodoro timer with session management
3. **Syllabus** (`/syllabus`) - Expandable subject/chapter list
4. **Progress** (`/progress`) - Donut chart, weekly bar charts, summary stats
5. **Exams** (`/exams`) - Exam list with active exam details

Settings (`/settings`) and Onboarding (`/onboarding`) are separate routes.

## Key Features Implementation

### Focus Timer
- Stores end timestamp for background survival
- 1-second tick updates from `DateTime.now()`
- Auto-advances: Focus → Short Break → Focus → Long Break (after N sessions)
- Schedules local notifications for session end
- Wakelock keeps screen on during active timer
- Haptic feedback and sound on completion

### Progress Calculations
- **Days Left**: Exam date - today (clamped at 0)
- **Percent Prepared**: Completed chapters / Total chapters
- **Current Streak**: Consecutive days with activity (focus session or chapter completion)
- **Longest Streak**: Maximum consecutive days ever
- **Weekly Data**: Last 7 days of chapters completed and focus minutes
- **Subject Status**: "On track" if completed ratio ≥ expected ratio (elapsed/total days)

### Data Persistence
All data stored in Hive boxes:
- `exams`, `subjects`, `chapters`, `study_tasks`, `focus_sessions`, `settings`
- Automatic cascade deletes (exam → subjects → chapters)
- Reactive streams for real-time UI updates

## Testing

### Unit Tests
```bash
flutter test test/providers_test.dart
```

Tests cover:
- Date utilities
- Exam daysLeft calculation
- Streak calculations
- Weekly aggregations
- Subject status logic
- Focus timer state transitions

### Widget Tests
```bash
flutter test test/widget_test.dart
```

Tests cover:
- Home screen empty state
- New Exam sheet validation
- Navigation tab switching

### Run All Tests
```bash
flutter test
```

## Platform Support

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- Portrait only orientation

## Permissions

Android (`android/app/src/main/AndroidManifest.xml`):
- `POST_NOTIFICATIONS` (Android 13+)
- `SCHEDULE_EXACT_ALARM` (for timer notifications)
- `VIBRATE`
- `WAKE_LOCK`

iOS (`ios/Runner/Info.plist`):
- Background modes for notifications

## Building for Release

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and analysis: `flutter analyze && flutter test`
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Acknowledgments

- Design inspired by modern exam preparation apps
- Icons from Material Design
- Fonts from Google Fonts
- Charts from fl_chart