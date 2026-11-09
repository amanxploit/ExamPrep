import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/exam.dart';
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
    weeklyLabelsProgressProvider;
    final weeklyFocus = ref.watch(weeklyFocusMinutesProgressProvider);
    final summary = ref.watch(summaryStatsProvider);
    
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
                _buildOverallProgressCard(ref, overall),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildWeeklyChartCard(
                  'This week',
                  'chapters completed',
                  weeklyChapters,
                  ref.watch(weeklyLabelsProgressProvider),
                  '🔥 ${weeklyChapters.reduce((a, b) => a + b)} done',
                  AppColors.primaryLight,
                  AppColors.primary,
                  isChapters: true,
                ),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildWeeklyChartCard(
                  'Focus time',
                  'minutes this week',
                  weeklyFocus,
                  ref.watch(weeklyLabelsProgressProvider),
                  '🔥 ${ref.watch(currentStreakProvider)} day streak',
                  AppColors.successSoft,
                  AppColors.successDark,
                  isChapters: false,
                ),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildSummaryCard(summary),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
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
                          await ref.read(examRepositoryProvider).setActiveExam(exam.id);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primarySoft : Colors.white,
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
                                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isActive)
                              Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
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
  
  Widget _buildOverallProgressCard(WidgetRef ref, Map<String, int> overall) {
    final completed = overall['completed'] ?? 0;
    final remaining = overall['remaining'] ?? 0;
    final total = overall['total'] ?? 0;
    final percent = total > 0 ? completed / total : 0.0;
    
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
                  completed: completed,
                  remaining: remaining,
                  total: total,
                  size: AppSpacing.donutSize,
                  strokeWidth: AppSpacing.donutStroke,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(percent * 100).round()}%',
                      style: AppTextStyles.donutPercent,
                    ),
                    Text('READY', style: AppTextStyles.donutLabel),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendRow(
                  color: AppColors.success,
                  label: 'Completed',
                  value: '$completed',
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: AppColors.primary,
                  label: 'Remaining',
                  value: '$remaining',
                ),
                const SizedBox(height: 10),
                _LegendRow(
                  color: AppColors.track,
                  label: 'Total',
                  value: '$total',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeeklyChartCard(
    String title,
    String subtitle,
    List<int> data,
    List<String> labels,
    String badge,
    Color barColor,
    Color todayColor,
    {required bool isChapters}
  ) {
    final todayIndex = 6; // Last item is today
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isChapters ? AppColors.orangeSoft : AppColors.successSoft,
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
                        if (index < 0 || index >= labels.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index],
                            style: AppTextStyles.caption.copyWith(
                              color: index == todayIndex ? AppColors.primary : AppColors.textSecondary,
                              fontWeight: index == todayIndex ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data[index].toDouble(),
                        width: AppSpacing.barWidth,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
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
  
  Widget _buildSummaryCard(Map<String, dynamic> summary) {
    final totalMinutes = summary['totalTime'] as int;
    final sessions = summary['sessions'] as int;
    final longestStreak = summary['longestStreak'] as int;
    
    return SoftCard(
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              icon: Icons.timer_rounded,
              iconColor: AppColors.purple,
              value: AppDateUtils.formatDuration(Duration(minutes: totalMinutes)),
              label: 'Total time',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.track),
          Expanded(
            child: _SummaryItem(
              icon: Icons.flag_rounded,
              iconColor: AppColors.blue,
              value: '$sessions',
              label: 'Sessions',
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.track),
          Expanded(
            child: _SummaryItem(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.orange,
              value: '$longestStreak',
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
    return oldDelegate is _DonutPainter &&
        oldDelegate.sections != sections;
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