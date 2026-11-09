import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/revision_item.dart';
import 'package:exam_prep/data/models/revision_review.dart';
import 'package:exam_prep/features/revision/providers/revision_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class RevisionScreen extends ConsumerWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeExam = ref.watch(activeExamProvider).value;
    final revisionHealth = activeExam != null
        ? ref.watch(revisionHealthProvider(activeExam.id))
        : 0.0;
    final dueRevisions = activeExam != null
        ? ref.watch(dueRevisionsProvider(activeExam.id))
        : [];
    final overdueRevisions = activeExam != null
        ? ref.watch(overdueRevisionsProvider(activeExam.id))
        : [];
    final upcomingRevisions = activeExam != null
        ? ref.watch(upcomingRevisionsProvider(activeExam.id))
        : [];

    if (activeExam == null) {
      return _buildNoExamState(context);
    }

    final slivers = <Widget>[
      SliverToBoxAdapter(child: _buildHealthCard(context, revisionHealth)),
      _buildSectionHeader(
          context, 'Due Today', dueRevisions.length, AppColors.warning,
          showCount: dueRevisions.isNotEmpty),
      ..._buildRevisionSlivers(context, ref, dueRevisions, true),
      _buildSectionHeader(
          context, 'Overdue', overdueRevisions.length, AppColors.error,
          showCount: overdueRevisions.isNotEmpty),
      ..._buildRevisionSlivers(context, ref, overdueRevisions, true),
      _buildSectionHeader(
          context, 'Upcoming', upcomingRevisions.length, AppColors.primary,
          showCount: false),
      ..._buildRevisionSlivers(context, ref, upcomingRevisions, false),
      const SliverToBoxAdapter(child: SizedBox(height: 100)),
    ];

    return CustomScrollView(slivers: slivers);
  }

  List<Widget> _buildRevisionSlivers(BuildContext context, WidgetRef ref,
      List<RevisionItem> items, bool isDueOrOverdue) {
    if (items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _buildEmptySection(
            context,
            isDueOrOverdue ? 'No revisions due today' : 'No overdue revisions',
            isDueOrOverdue
                ? 'Great job! All caught up for today.'
                : 'You\'re on track!',
            isDueOrOverdue
                ? Icons.check_circle_rounded
                : Icons.schedule_rounded,
            isDueOrOverdue ? AppColors.success : AppColors.warning,
          ),
        ),
      ];
    }
    return [
      SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildRevisionCard(context, ref, items[index], isDueOrOverdue);
        },
      ),
    ];
  }

  Widget _buildNoExamState(BuildContext context) {
    return Center(
      child: EmptyStateCard(
        icon: Icons.school_rounded,
        title: 'No active exam',
        subtitle: 'Create or select an exam to manage revisions',
        action: PrimaryPillButton(
          label: 'Create exam',
          icon: Icons.add_rounded,
          onPressed: () => context.push('/exams/new'),
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, double health) {
    final percent = (health * 100).round();
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getHealthColor(health).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$percent%',
                    style: AppTextStyles.headline.copyWith(
                      color: _getHealthColor(health),
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
                    Text('Revision Health', style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(
                      _getHealthDescription(health),
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: health,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppColors.track,
            valueColor: AlwaysStoppedAnimation(_getHealthColor(health)),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double health) {
    if (health >= 0.8) return AppColors.success;
    if (health >= 0.5) return AppColors.warning;
    return AppColors.error;
  }

  String _getHealthDescription(double health) {
    if (health >= 0.8) return 'Excellent! You\'re on top of your revisions.';
    if (health >= 0.5) return 'Good, but some revisions need attention.';
    return 'Several revisions are overdue. Schedule time to catch up.';
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, int count, Color color,
      {bool showCount = true}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Row(
          children: [
            Text(title,
                style: AppTextStyles.sectionTitle.copyWith(color: color)),
            const Spacer(),
            if (showCount && count > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySection(BuildContext context, String title, String subtitle,
      IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.title.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: AppTextStyles.body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionCard(BuildContext context, WidgetRef ref,
      RevisionItem item, bool isDueOrOverdue) {
    final isOverdue = item.isOverdue;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isOverdue
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.border,
          width: isOverdue ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? AppColors.error.withValues(alpha: 0.15)
                      : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  isOverdue ? 'Overdue' : 'Due Today',
                  style: AppTextStyles.caption.copyWith(
                    color: isOverdue ? AppColors.error : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Rep: ${item.repetitions} | Interval: ${item.intervalDays}d',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: AppTextStyles.title),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Due: ${item.dueAt.formattedShort}',
                style: AppTextStyles.caption.copyWith(
                  color: isOverdue ? AppColors.error : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (item.easeFactor > 0)
                Text(
                  'Ease: ${item.easeFactor.toStringAsFixed(2)}',
                  style: AppTextStyles.caption,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedPillButton(
                  label: 'Again',
                  icon: Icons.refresh_rounded,
                  onPressed: () =>
                      _showReviewDialog(context, ref, item, ReviewRating.again),
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedPillButton(
                  label: 'Hard',
                  icon: Icons.remove_rounded,
                  onPressed: () =>
                      _showReviewDialog(context, ref, item, ReviewRating.hard),
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryPillButton(
                  label: 'Good',
                  icon: Icons.check_rounded,
                  onPressed: () =>
                      _showReviewDialog(context, ref, item, ReviewRating.good),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryPillButton(
                  label: 'Easy',
                  icon: Icons.bolt_rounded,
                  onPressed: () =>
                      _showReviewDialog(context, ref, item, ReviewRating.easy),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, RevisionItem item,
      ReviewRating rating) {
    final calc = ref.read(calculationServiceProvider);
    final result = calc.calculateSM2Interval(
      rating: rating,
      currentIntervalDays: item.intervalDays,
      currentEaseFactor: item.easeFactor,
      currentRepetitions: item.repetitions,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Review: ${item.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating: ${rating.displayName}'),
            const SizedBox(height: 12),
            Text('Next due: ${result.nextDueAt.formattedShort}'),
            Text('New interval: ${result.newIntervalDays} days'),
            Text('New ease factor: ${result.newEaseFactor.toStringAsFixed(2)}'),
            Text('Repetitions: ${result.newRepetitions}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryPillButton(
            label: 'Confirm',
            onPressed: () {
              final repo = ref.read(examRepositoryProvider);
              final review = calc.createRevisionReview(
                userId: 'user_1',
                item: item,
                rating: rating,
              );
              final updatedItem = calc.updateRevisionItemAfterReview(
                item: item,
                rating: rating,
              );
              repo.addRevisionReview(review);
              repo.updateRevisionItem(updatedItem);
              final examId = ref.read(activeExamProvider).value!.id;
              ref.invalidate(revisionItemsProvider(examId));
              ref.invalidate(dueRevisionsProvider(examId));
              ref.invalidate(overdueRevisionsProvider(examId));
              ref.invalidate(upcomingRevisionsProvider(examId));
              ref.invalidate(revisionHealthProvider(examId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Review recorded: ${rating.displayName}')),
              );
            },
          ),
        ],
      ),
    );
  }
}
