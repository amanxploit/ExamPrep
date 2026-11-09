import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/features/progress/providers/progress_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeExam = ref.watch(activeExamProvider).value;
    final overall = ref.watch(overallProgressProvider);
    final weeklyChapters = ref.watch(weeklyChaptersProgressProvider);
    final weeklyFocus = ref.watch(weeklyFocusMinutesProgressProvider);
    final weeklyLabels = ref.watch(weeklyLabelsProgressProvider);
    final summary = ref.watch(summaryStatsProvider);
    final subjectProgress = ref.watch(subjectProgressListProvider);
    final countdown = ref.watch(examCountdownProvider);
    final milestones = ref.watch(milestonesProvider);
    final readiness = ref.watch(readinessScoreProvider);
    final todayFocus = ref.watch(todayFocusMinutesProvider);
    final todayProgress = ref.watch(todayFocusProgressProvider);
    final dailyGoal = ref.watch(dailyGoalMinutesProvider);
    final timePerSubject = ref.watch(timePerSubjectProvider);
    final dueRevisions = ref.watch(dueRevisionsCountProvider);
    final overdueRevisions = ref.watch(overdueRevisionsCountProvider);
    final revisionHealth = ref.watch(revisionHealthProgressProvider);
    final subjectStatus = ref.watch(subjectStatusMapProvider);

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
              const SizedBox(height: AppSpacing.sectionVertical),
              if (activeExam != null) ...[
                // Exam Countdown Banner
                _buildCountdownBanner(context, countdown),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Syllabus Coverage (separate from readiness)
                _buildSyllabusCoverageCard(context, overall),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Readiness Score (weighted, if available)
                if (readiness != null) ...[
                  _buildReadinessCard(context, readiness),
                  const SizedBox(height: AppSpacing.sectionVertical),
                ],

                // Today's Plan
                _buildTodaysPlanCard(context, todayFocus, todayProgress,
                    dailyGoal, dueRevisions, overdueRevisions),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Focus Goal Progress
                _buildFocusGoalCard(
                    context, todayFocus, dailyGoal, todayProgress),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Revision Alerts
                if (dueRevisions > 0 || overdueRevisions > 0) ...[
                  _buildRevisionAlertCard(
                      context, dueRevisions, overdueRevisions, revisionHealth),
                  const SizedBox(height: AppSpacing.sectionVertical),
                ],

                // Weekly Activity Charts
                _buildWeeklyActivityCard(
                  context,
                  'This week',
                  'chapters completed',
                  weeklyChapters,
                  weeklyLabels,
                  '🔥 ${weeklyChapters.values.fold(0, (a, b) => a + b)} done',
                  AppColors.primaryLight,
                  AppColors.primary,
                  isChapters: true,
                ),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildWeeklyActivityCard(
                  context,
                  'Focus time',
                  'minutes this week',
                  weeklyFocus,
                  weeklyLabels,
                  '🔥 ${ref.watch(currentStreakProvider)} day streak',
                  AppColors.successSoft,
                  AppColors.successDark,
                  isChapters: false,
                ),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Subject Progress
                if (subjectProgress.isNotEmpty) ...[
                  _buildSubjectProgressCard(
                      context, subjectProgress, subjectStatus),
                  const SizedBox(height: AppSpacing.sectionVertical),
                ],

                // Time per Subject
                if (timePerSubject.isNotEmpty) ...[
                  _buildTimePerSubjectCard(context, timePerSubject),
                  const SizedBox(height: AppSpacing.sectionVertical),
                ],

                // Streaks & Records
                _buildStreaksRecordsCard(context, summary),
                const SizedBox(height: AppSpacing.sectionVertical),

                // Milestones
                if (milestones.isNotEmpty) ...[
                  _buildMilestonesCard(context, milestones),
                  const SizedBox(height: AppSpacing.sectionVertical),
                ],

                // Summary Stats
                _buildSummaryCard(context, summary),
              ] else ...[
                _buildNoExamState(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final activeExam = ref.watch(activeExamProvider).value;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Progress', style: AppTextStyles.screenTitle),
              const SizedBox(height: 4),
              Text(
                'All metrics from CalculationService',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        if (activeExam != null)
          ExamSelectorChip(
            examName: activeExam.name,
            dotColor: AppColors.blue,
            onTap: () => _showExamSelectorSheet(ref),
          ),
      ],
    );
  }

  void _showExamSelectorSheet(WidgetRef ref) {
    final exams = ref.read(examRepositoryProvider).getAllExams();
    final activeExam = ref.read(activeExamProvider).value;

    showModalBottomSheet(
      context: ref.context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.track,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('Select Exam', style: AppTextStyles.sheetTitle),
                    const Spacer(),
                    SquareIconButton(
                      icon: Icons.close_rounded,
                      onTap: () => Navigator.pop(context),
                      size: 36,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: exams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    final isActive = exam.id == activeExam?.id;
                    return InkWell(
                      onTap: () async {
                        if (!isActive) {
                          await ref
                              .read(examRepositoryProvider)
                              .setActiveExam(exam.id);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isActive ? AppColors.primarySoft : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isActive
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: exam.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                exam.name,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isActive)
                              Icon(Icons.check_circle_rounded,
                                  color: AppColors.primary, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownBanner(BuildContext context, ExamCountdown countdown) {
    final isPast = countdown.isPast;
    final daysLeft = countdown.daysLeft;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPast
            ? LinearGradient(
                colors: [
                  AppColors.errorSoft,
                  AppColors.errorSoft.withValues(alpha: 0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppGradients.gradientCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [AppShadows.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isPast
                  ? AppColors.error.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isPast ? '🎓' : '$daysLeft',
                style: AppTextStyles.headline.copyWith(
                  color: isPast ? AppColors.error : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPast ? 'Exam Completed' : 'Exam Countdown',
                  style: AppTextStyles.title.copyWith(
                    color: isPast ? AppColors.error : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  countdown.displayText,
                  style: AppTextStyles.body.copyWith(
                    color: isPast
                        ? AppColors.error.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                if (!isPast && daysLeft <= 7) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      daysLeft <= 3 ? 'Final sprint!' : 'Stay focused',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllabusCoverageCard(
      BuildContext context, ChapterCoverage coverage) {
    return SoftCard(
      child: Row(
        children: [
          // Donut chart
          SizedBox(
            width: AppSpacing.donutSize,
            height: AppSpacing.donutSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _DonutChart(
                  completed: coverage.completed,
                  remaining: coverage.remaining,
                  total: coverage.total,
                  size: AppSpacing.donutSize,
                  strokeWidth: AppSpacing.donutStroke,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      coverage.total == 0
                          ? '—'
                          : '${(coverage.percent * 100).round()}%',
                      style: AppTextStyles.donutPercent,
                    ),
                    Text('SYLLABUS', style: AppTextStyles.donutLabel),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Legend & details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Syllabus Coverage', style: AppTextStyles.cardTitle),
                Text(
                  'Chapters completed / total. Does not include revision or readiness.',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                _LegendRow(
                  color: AppColors.success,
                  label: 'Completed',
                  value: '${coverage.completed}',
                ),
                const SizedBox(height: 8),
                _LegendRow(
                  color: AppColors.primary,
                  label: 'Remaining',
                  value: '${coverage.remaining}',
                ),
                const SizedBox(height: 8),
                _LegendRow(
                  color: AppColors.track,
                  label: 'Total',
                  value: '${coverage.total}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessCard(BuildContext context, ReadinessScore readiness) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.psychology_rounded,
                    color: AppColors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Exam Readiness', style: AppTextStyles.cardTitle),
                    Text(
                      'Weighted estimate: syllabus, revision health, consistency',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${readiness.score}%',
                  style: AppTextStyles.title.copyWith(
                      color: AppColors.purple, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: readiness.score / 100,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppColors.track,
            valueColor: AlwaysStoppedAnimation(AppColors.purple),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: readiness.weights.entries.map((e) {
              final label = _formatWeightLabel(e.key);
              final weight = (e.value * 100).round();
              return Chip(
                label: Text('$label: $weight%', style: AppTextStyles.caption),
                backgroundColor: AppColors.purpleSoft,
                side: BorderSide.none,
              );
            }).toList(),
          ),
          if (!readiness.hasRevisionData || !readiness.hasPracticeData) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningSoft,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Weights renormalized: ${!readiness.hasRevisionData ? 'no revision data' : ''} ${!readiness.hasPracticeData ? 'no practice data' : ''}',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.warningDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatWeightLabel(String key) {
    switch (key) {
      case 'coverage':
        return 'Syllabus';
      case 'revision':
        return 'Revision';
      case 'consistency':
        return 'Consistency';
      case 'practice':
        return 'Practice';
      default:
        return key;
    }
  }

  Widget _buildTodaysPlanCard(
    BuildContext context,
    int todayFocus,
    double todayProgress,
    int dailyGoal,
    int dueRevisions,
    int overdueRevisions,
  ) {
    final remaining = (dailyGoal - todayFocus).clamp(0, dailyGoal);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.calendar_today_rounded,
                    color: AppColors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Plan", style: AppTextStyles.cardTitle),
                    Text(
                      '$todayFocus / $dailyGoal min • ${(todayProgress * 100).round()}%',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: todayProgress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppColors.track,
            valueColor: AlwaysStoppedAnimation(
                todayProgress >= 1.0 ? AppColors.success : AppColors.blue),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Completed',
                  value: '${todayFocus}m',
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Remaining',
                  value: '${remaining}m',
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Goal',
                  value: '${dailyGoal}m',
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          if (dueRevisions > 0 || overdueRevisions > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: overdueRevisions > 0
                    ? AppColors.errorSoft
                    : AppColors.warningSoft,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    overdueRevisions > 0
                        ? Icons.warning_amber_rounded
                        : Icons.schedule_rounded,
                    size: 18,
                    color: overdueRevisions > 0
                        ? AppColors.error
                        : AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      overdueRevisions > 0
                          ? '$overdueRevisions overdue, $dueRevisions due today'
                          : '$dueRevisions revisions due today',
                      style: AppTextStyles.caption.copyWith(
                        color: overdueRevisions > 0
                            ? AppColors.errorDark
                            : AppColors.warningDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('View',
                        style: AppTextStyles.caption
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFocusGoalCard(
      BuildContext context, int todayFocus, int dailyGoal, double progress) {
    return SoftCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: progress >= 1.0
                  ? AppColors.successSoft
                  : AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                progress >= 1.0
                    ? Icons.check_circle_rounded
                    : Icons.timer_rounded,
                color: progress >= 1.0 ? AppColors.success : AppColors.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Focus Goal', style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  '$todayFocus / $dailyGoal minutes',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: AppTextStyles.headline.copyWith(
                  color:
                      progress >= 1.0 ? AppColors.success : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(progress >= 1.0 ? 'Goal met!' : 'Keep going',
                  style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionAlertCard(
    BuildContext context,
    int dueRevisions,
    int overdueRevisions,
    double revisionHealth,
  ) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: overdueRevisions > 0
                      ? AppColors.errorSoft
                      : AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  overdueRevisions > 0
                      ? Icons.warning_amber_rounded
                      : Icons.schedule_rounded,
                  color: overdueRevisions > 0
                      ? AppColors.error
                      : AppColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Revision Alerts', style: AppTextStyles.cardTitle),
                    Text(
                      'Due/overdue items from SM-2 scheduler',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: revisionHealth >= 0.8
                      ? AppColors.successSoft
                      : revisionHealth >= 0.5
                          ? AppColors.warningSoft
                          : AppColors.errorSoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${(revisionHealth * 100).round()}% health',
                  style: AppTextStyles.caption.copyWith(
                    color: revisionHealth >= 0.8
                        ? AppColors.success
                        : revisionHealth >= 0.5
                            ? AppColors.warning
                            : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Overdue',
                  value: '$overdueRevisions',
                  color: AppColors.error,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Due Today',
                  value: '$dueRevisions',
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Health',
                  value: '${(revisionHealth * 100).round()}%',
                  color: revisionHealth >= 0.8
                      ? AppColors.success
                      : revisionHealth >= 0.5
                          ? AppColors.warning
                          : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityCard(
    BuildContext context,
    String title,
    String subtitle,
    Map<DateTime, int> data,
    List<String> labels,
    String badge,
    Color barColor,
    Color todayColor, {
    required bool isChapters,
  }) {
    final todayIndex = 6;
    final values = data.values.toList();
    final maxValue =
        values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isChapters ? AppColors.orangeSoft : AppColors.successSoft,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Text(
                  badge,
                  style: AppTextStyles.caption.copyWith(
                    color: isChapters ? AppColors.orange : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxValue * 1.3).ceilToDouble(),
                minY: 0,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length)
                          return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index],
                            style: AppTextStyles.caption.copyWith(
                              color: index == todayIndex
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: index == todayIndex
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(labels.length, (index) {
                  final value = data.values.elementAtOrNull(index) ?? 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value.toDouble(),
                        width: AppSpacing.barWidth,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                        color: index == todayIndex ? todayColor : barColor,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: (maxValue * 1.3).ceilToDouble(),
                          color: AppColors.track,
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }),
              ),
              swapAnimationDuration: AppDurations.chartAnimation,
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressCard(
    BuildContext context,
    List<SubjectProgress> subjectProgress,
    Map<String, SubjectStatus> subjectStatus,
  ) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.layers_rounded,
                    color: AppColors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject Progress', style: AppTextStyles.cardTitle),
                    Text(
                      'Coverage per subject with on-track/behind status',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjectProgress.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final subject = subjectProgress[index];
              final status =
                  subjectStatus[subject.subjectId] ?? SubjectStatus.onTrack;
              return _SubjectProgressRow(
                subject: subject,
                status: status,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimePerSubjectCard(
      BuildContext context, Map<String, int> timePerSubject) {
    final totalMinutes = timePerSubject.values.fold(0, (a, b) => a + b);

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.pie_chart_rounded,
                    color: AppColors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time per Subject', style: AppTextStyles.cardTitle),
                    Text(
                      'Estimated focus minutes per subject (50 min/chapter)',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (timePerSubject.isEmpty) ...[
            Text('No time tracked yet',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: timePerSubject.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final entry = timePerSubject.entries.elementAt(index);
                final percent =
                    totalMinutes > 0 ? entry.value / totalMinutes : 0.0;
                return _TimePerSubjectRow(
                  subjectName: entry.key,
                  minutes: entry.value,
                  percent: percent,
                );
              },
            ),
            const SizedBox(height: 12),
            _MetricItem(
              label: 'Total',
              value:
                  AppDateUtils.formatDuration(Duration(minutes: totalMinutes)),
              color: AppColors.blue,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStreaksRecordsCard(BuildContext context, SummaryStats summary) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.orangeSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.local_fire_department_rounded,
                    color: AppColors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Streaks & Records', style: AppTextStyles.cardTitle),
                    Text(
                      'Consecutive days with focus session or chapter completion',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RecordItem(
                  label: 'Current Streak',
                  value: '${summary.currentStreak}',
                  subtitle: 'days',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.orange,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.track),
              Expanded(
                child: _RecordItem(
                  label: 'Longest Streak',
                  value: '${summary.longestStreak}',
                  subtitle: 'days',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.warning,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.track),
              Expanded(
                child: _RecordItem(
                  label: 'Consistency',
                  value: '${summary.consistencyScore.round()}%',
                  subtitle: 'last 14 days',
                  icon: Icons.trending_up_rounded,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _RecordItem(
                  label: 'Total Focus',
                  value: AppDateUtils.formatDuration(
                      Duration(minutes: summary.totalFocusMinutes)),
                  subtitle: 'all time',
                  icon: Icons.timer_rounded,
                  color: AppColors.purple,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.track),
              Expanded(
                child: _RecordItem(
                  label: 'Total Sessions',
                  value: '${summary.totalSessions}',
                  subtitle: 'focus sessions',
                  icon: Icons.flag_rounded,
                  color: AppColors.blue,
                ),
              ),
              Container(width: 1, height: 50, color: AppColors.track),
              Expanded(
                child: _RecordItem(
                  label: 'Chapters Done',
                  value: '${summary.totalChaptersCompleted}',
                  subtitle: 'completed',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard(
      BuildContext context, List<MilestoneProgress> milestones) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child:
                    Icon(Icons.star_rounded, color: AppColors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Milestones', style: AppTextStyles.cardTitle),
                    Text(
                      'Long-term progress targets',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: milestones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final m = milestones[index];
              return _MilestoneRow(milestone: m);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, SummaryStats summary) {
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.timer_rounded,
              iconColor: AppColors.purple,
              value: AppDateUtils.formatDuration(
                  Duration(minutes: summary.totalFocusMinutes)),
              label: 'Total time',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.track),
          Expanded(
            child: _SummaryItem(
              icon: Icons.flag_rounded,
              iconColor: AppColors.blue,
              value: '${summary.totalSessions}',
              label: 'Sessions',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.track),
          Expanded(
            child: _SummaryItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.orange,
              value: '${summary.longestStreak}',
              label: 'Longest streak',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoExamState() {
    return EmptyStateCard(
      icon: Icons.bar_chart_rounded,
      title: 'No active exam',
      subtitle: 'Select an exam to see your progress',
      action: PrimaryPillButton(
        label: 'Go to Exams',
        icon: Icons.arrow_forward_rounded,
        onPressed: () {},
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final int completed;
  final int remaining;
  final int total;
  final double size;
  final double strokeWidth;

  const _DonutChart({
    required this.completed,
    required this.remaining,
    required this.total,
    required this.size,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return CustomPaint(
        size: Size(size, size),
        painter: _DonutPainter(
          sections: [
            _DonutSection(percent: 1.0, color: AppColors.track),
          ],
          strokeWidth: strokeWidth,
          gapAngle: 0.02,
        ),
      );
    }

    final completedPercent = completed / total;
    final remainingPercent = remaining / total;

    return CustomPaint(
      size: Size(size, size),
      painter: _DonutPainter(
        sections: [
          _DonutSection(percent: completedPercent, color: AppColors.success),
          _DonutSection(percent: remainingPercent, color: AppColors.primary),
        ],
        strokeWidth: strokeWidth,
        gapAngle: 0.02,
      ),
    );
  }
}

class _DonutSection {
  final double percent;
  final Color color;

  _DonutSection({required this.percent, required this.color});
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSection> sections;
  final double strokeWidth;
  final double gapAngle;

  _DonutPainter({
    required this.sections,
    required this.strokeWidth,
    this.gapAngle = 0.02,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    var currentAngle = -math.pi / 2;

    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      if (section.percent <= 0) continue;

      final sweepAngle = 2 * math.pi * section.percent - gapAngle;

      final paint = Paint()
        ..color = section.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );

      currentAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _DonutPainter && oldDelegate.sections != sections;
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.legendLabel),
        const Spacer(),
        Text(value, style: AppTextStyles.legendValue),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.statNumber.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style:
                AppTextStyles.statNumber.copyWith(color: color, fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _SubjectProgressRow extends StatelessWidget {
  final SubjectProgress subject;
  final SubjectStatus status;

  const _SubjectProgressRow({
    required this.subject,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isBehind = status == SubjectStatus.behind;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBehind ? AppColors.errorSoft : AppColors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: subject.subjectColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(subject.subjectName,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isBehind ? AppColors.error : AppColors.success,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  isBehind ? 'BEHIND' : 'ON TRACK',
                  style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: subject.percent,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
            backgroundColor: isBehind
                ? AppColors.error.withValues(alpha: 0.2)
                : AppColors.success.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation(
                isBehind ? AppColors.error : AppColors.success),
          ),
          const SizedBox(height: 4),
          Text(
            '${subject.completedChapters} / ${subject.totalChapters} chapters (${(subject.percent * 100).round()}%)',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _TimePerSubjectRow extends StatelessWidget {
  final String subjectName;
  final int minutes;
  final double percent;

  const _TimePerSubjectRow({
    required this.subjectName,
    required this.minutes,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(subjectName, style: AppTextStyles.body)),
            Text(AppDateUtils.formatDuration(Duration(minutes: minutes)),
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(width: 12),
            Text('${(percent * 100).round()}%',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
          backgroundColor: AppColors.track,
          valueColor: AlwaysStoppedAnimation(AppColors.blue),
        ),
      ],
    );
  }
}

class _RecordItem extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _RecordItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value,
            style:
                AppTextStyles.statNumber.copyWith(color: color, fontSize: 20)),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final MilestoneProgress milestone;

  const _MilestoneRow({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final isCompleted = milestone.isCompleted;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.successSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isCompleted ? Icons.check_rounded : Icons.star_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(milestone.name,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(milestone.description, style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${milestone.currentValue} / ${milestone.targetValue} ${milestone.unit}',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              Text('${(milestone.percent * 100).round()}%',
                  style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

// Extension for safe list access
extension SafeListAccess<T> on List<T> {
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
