import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/focus_session.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/features/focus/providers/focus_providers.dart';
import 'package:exam_prep/features/settings/providers/settings_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(focusTimerProvider);
    final settings = ref.watch(settingsProvider).value ?? Settings();
    final completedToday = ref.watch(completedFocusSessionsTodayProvider);
    final dailyGoal = ref.watch(dailyGoalMinutesProvider);
    final todayMinutes = ref.watch(todayFocusMinutesProvider);
    final progress = ref.watch(todayFocusProgressProvider);
    
    // Initialize timer if not already
    ref.listen(focusTimerProvider, (prev, next) {
      if (prev == null || prev.currentType != next.currentType) {
        // Timer type changed, will be initialized on first build
      }
    });
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.sectionVertical,
            AppSpacing.screenHorizontal,
            AppSpacing.bottomPadding,
          ),
          sliver: SliverList.list(
            children: [
              _buildHeader(context, ref),
              const SizedBox(height: AppSpacing.sectionVerticalLarge),
              _buildSegmentedControl(ref, timerState),
              const SizedBox(height: AppSpacing.sectionVerticalLarge),
              _buildTimerCircle(context, ref, timerState, settings),
              const SizedBox(height: AppSpacing.sectionVerticalLarge),
              _buildSessionDots(ref, completedToday, settings),
              const SizedBox(height: AppSpacing.sectionVerticalLarge),
              _buildControls(ref, timerState),
              const SizedBox(height: AppSpacing.sectionVerticalLarge),
              _buildDailyGoalCard(ref, todayMinutes, dailyGoal, progress, completedToday),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('One block at a time', style: AppTextStyles.overline),
              const SizedBox(height: 4),
              Text('Focus', style: AppTextStyles.screenTitle),
            ],
          ),
        ),
        SquareIconButton(
          icon: Icons.edit_rounded,
          iconColor: AppColors.primary,
          onTap: () => _showTimerSettingsSheet(context, ref),
        ),
      ],
    );
  }
  
  Widget _buildSegmentedControl(WidgetRef ref, FocusTimerState state) {
    return SegmentedControl<SessionType>(
      options: const [SessionType.focus, SessionType.shortBreak, SessionType.longBreak],
      selectedValue: state.currentType,
      onChanged: (type) => ref.read(focusTimerProvider.notifier).setType(type),
      labelBuilder: (type) => type.label,
      trackColor: AppColors.segmentedTrack,
    );
  }
  
  Widget _buildTimerCircle(
    BuildContext context,
    WidgetRef ref,
    FocusTimerState state,
    Settings settings,
  ) {
    final progress = ref.watch(focusProgressProvider);
    // Responsive timer size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final timerSize = (screenWidth * 0.7).clamp(200.0, 280.0);
    final strokeWidth = (timerSize * 0.03).clamp(6.0, 10.0);
    
    return Center(
      child: SizedBox(
        width: timerSize,
        height: timerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ProgressRing(
              value: progress,
              size: timerSize,
              strokeWidth: strokeWidth,
              color: state.currentType == SessionType.focus ? AppColors.primary : AppColors.success,
              trackColor: state.currentType == SessionType.focus 
                  ? AppColors.primarySoft 
                  : AppColors.successSoft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.currentType.label,
                    style: AppTextStyles.timerLabel.copyWith(
                      color: state.currentType == SessionType.focus 
                          ? AppColors.primary 
                          : AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.remaining.formatMMSS(),
                    style: AppTextStyles.timerNumber.copyWith(fontSize: timerSize * 0.24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.currentType.subtitle,
                    style: AppTextStyles.timerSubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSessionDots(WidgetRef ref, int completed, Settings settings) {
    final total = settings.sessionsBeforeLongBreak;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(total, (index) {
          final filled = index < completed % total;
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : AppColors.track,
              shape: BoxShape.circle,
            ),
          );
        }),
        const SizedBox(width: 12),
        Text(
          '$completed done',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
  
  Widget _buildControls(WidgetRef ref, FocusTimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareIconButton(
          icon: Icons.refresh_rounded,
          iconColor: AppColors.primary,
          onTap: () => ref.read(focusTimerProvider.notifier).reset(),
        ),
        const SizedBox(width: 24),
        AnimatedScale(
          scale: 1.0,
          duration: AppDurations.pressScale,
          child: InkWell(
            onTap: state.isRunning
                ? () => ref.read(focusTimerProvider.notifier).pause()
                : () => ref.read(focusTimerProvider.notifier).start(),
            borderRadius: BorderRadius.circular(AppSpacing.playButtonSize / 2),
            child: Container(
              width: AppSpacing.playButtonSize,
              height: AppSpacing.playButtonSize,
              decoration: BoxDecoration(
                gradient: AppGradients.gradientCard,
                shape: BoxShape.circle,
                boxShadow: [AppShadows.buttonShadow],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => RotationTransition(
                  turns: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Icon(
                  state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey(state.isRunning),
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        SquareIconButton(
          icon: Icons.skip_next_rounded,
          iconColor: AppColors.primary,
          onTap: () => ref.read(focusTimerProvider.notifier).skip(),
        ),
      ],
    );
  }
  
  Widget _buildDailyGoalCard(
    WidgetRef ref,
    int todayMinutes,
    int dailyGoal,
    double progress,
    int sessions,
  ) {
    final remaining = (dailyGoal - todayMinutes).clamp(0, dailyGoal);
    
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProgressRing(
                value: progress,
                size: 56,
                strokeWidth: 6,
                color: AppColors.primary,
                trackColor: AppColors.primarySoft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$todayMinutes',
                      style: AppTextStyles.statNumber.copyWith(fontSize: 18),
                    ),
                    Text('MIN', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily goal', style: AppTextStyles.caption),
                    const SizedBox(height: 2),
                    Text(
                      '${dailyGoal} min',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PillProgressBar(
            value: progress,
            color: AppColors.primary,
            height: 6,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$sessions sessions',
                style: AppTextStyles.caption,
              ),
              Text(
                '$remaining min to go',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showTimerSettingsSheet(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider).value ?? Settings();
    
    int focusMinutes = settings.focusMinutes;
    int shortBreakMinutes = settings.shortBreakMinutes;
    int longBreakMinutes = settings.longBreakMinutes;
    int sessionsBeforeLongBreak = settings.sessionsBeforeLongBreak;
    bool autoStartBreaks = settings.autoStartBreaks;
    bool sound = settings.sound;
    bool vibration = settings.vibration;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.track,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text('Timer Settings', style: AppTextStyles.sheetTitle),
                  const SizedBox(height: 20),
                  _buildDurationRow(
                    'Focus',
                    focusMinutes,
                    (val) => setState(() => focusMinutes = val),
                    AppColors.primary,
                  ),
                  _buildDurationRow(
                    'Short Break',
                    shortBreakMinutes,
                    (val) => setState(() => shortBreakMinutes = val),
                    AppColors.success,
                  ),
                  _buildDurationRow(
                    'Long Break',
                    longBreakMinutes,
                    (val) => setState(() => longBreakMinutes = val),
                    AppColors.successDark,
                  ),
                  const SizedBox(height: 16),
                  _buildStepperRow(
                    'Sessions before long break',
                    sessionsBeforeLongBreak,
                    (val) => setState(() => sessionsBeforeLongBreak = val),
                    2,
                    10,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Auto-start breaks', style: AppTextStyles.body),
                    value: autoStartBreaks,
                    onChanged: (val) => setState(() => autoStartBreaks = val),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Sound', style: AppTextStyles.body),
                    value: sound,
                    onChanged: (val) => setState(() => sound = val),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Vibration', style: AppTextStyles.body),
                    value: vibration,
                    onChanged: (val) => setState(() => vibration = vibration),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        ref.read(updateSettingsProvider(
                          Settings(
                            focusMinutes: focusMinutes,
                            shortBreakMinutes: shortBreakMinutes,
                            longBreakMinutes: longBreakMinutes,
                            sessionsBeforeLongBreak: sessionsBeforeLongBreak,
                            autoStartBreaks: autoStartBreaks,
                            sound: sound,
                            vibration: vibration,
                            dailyReminderTime: settings.dailyReminderTime,
                            onboardingDone: settings.onboardingDone,
                          ),
                        ));
                        Navigator.pop(context);
                      },
                      child: Text('Save', style: AppTextStyles.buttonText),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildDurationRow(
    String label,
    int minutes,
    ValueChanged<int> onChanged,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.body),
          const Spacer(),
          _buildStepper(
            minutes,
            onChanged,
            1,
            120,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepperRow(
    String label,
    int value,
    ValueChanged<int> onChanged,
    int min,
    int max,
  ) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        _buildStepper(value, onChanged, min, max),
      ],
    );
  }
  
  Widget _buildStepper(int value, ValueChanged<int> onChanged, int min, int max) {
    return Row(
      children: [
        InkWell(
          onTap: value > min ? () => onChanged(value - 1) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value > min ? AppColors.primarySoft : AppColors.track,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.remove_rounded,
              color: value > min ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 48,
          child: Text(
            '$value',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: value < max ? () => onChanged(value + 1) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value < max ? AppColors.primarySoft : AppColors.track,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add_rounded,
              color: value < max ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}