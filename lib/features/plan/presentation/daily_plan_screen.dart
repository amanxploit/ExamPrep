import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/daily_plan_task.dart';
import 'package:exam_prep/features/revision/providers/revision_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/features/settings/providers/settings_providers.dart';
import 'package:exam_prep/core/services/calculation_service.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class DailyPlanScreen extends ConsumerStatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  ConsumerState<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends ConsumerState<DailyPlanScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final activeExam = ref.watch(activeExamProvider).value;
    final settings = ref.watch(settingsProvider).value ?? const Settings();
    final userId = 'user_1'; // TODO: Get from auth
    
    final tasks = ref.watch(dailyPlanTasksProvider(userId, _selectedDate));
    final completedToday = ref.watch(completedFocusSessionsTodayProvider);
    final dailyGoalMinutes = settings.dailyGoalMinutes;

    if (activeExam == null) {
      return _buildNoExamState(context);
    }

    return Column(
      children: [
        // Date selector and actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: _buildDateSelector(context),
              ),
              const SizedBox(width: 12),
              OutlinedPillButton(
                label: 'Today',
                icon: Icons.today_rounded,
                onPressed: () => setState(() => _selectedDate = DateTime.now()),
              ),
              const SizedBox(width: 8),
              PrimaryPillButton(
                label: _isGenerating ? 'Generating...' : 'Generate Plan',
                icon: Icons.auto_awesome_rounded,
                onPressed: _isGenerating ? null : _generatePlan,
              ),
            ],
          ),
        ),

        // Workload warning
        Consumer(
          builder: (context, ref, _) {
            final planResult = _selectedDate == DateTime.now().dateOnly
                ? ref.watch(dailyPlanResultProvider)
                : null;
            
            if (planResult?.hasWorkloadWarning == true) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        planResult!.workloadWarning!,
                        style: AppTextStyles.body.copyWith(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Progress summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: _buildProgressSummary(context, tasks, completedToday, dailyGoalMinutes),
        ),

        // Task list
        Expanded(
          child: tasks.isEmpty
              ? _buildEmptyState(context)
              : ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: tasks.length,
                  onReorder: _onReorder,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _buildTaskCard(context, ref, task, index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNoExamState(BuildContext context) {
    return Center(
      child: EmptyStateCard(
        icon: Icons.school_rounded,
        title: 'No active exam',
        subtitle: 'Create or select an exam to manage your daily plan',
        action: PrimaryPillButton(
          label: 'Create exam',
          icon: Icons.add_rounded,
          onPressed: () => context.push('/exams/new'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: EmptyStateCard(
        icon: Icons.calendar_today_rounded,
        title: _selectedDate == DateTime.now().dateOnly ? 'No plan for today' : 'No plan for this day',
        subtitle: 'Generate a study plan based on your goals and due revisions',
        action: PrimaryPillButton(
          label: 'Generate Plan',
          icon: Icons.auto_awesome_rounded,
          onPressed: _generatePlan,
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              _selectedDate == DateTime.now().dateOnly ? 'Today' : _selectedDate.formattedMedium,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary(BuildContext context, List<DailyPlanTask> tasks, int completedToday, int dailyGoal) {
    final studyTasks = tasks.where((t) => t.type != DailyPlanTaskType.breakTime).toList();
    final totalEstimated = studyTasks.fold(0, (sum, t) => sum + t.estimatedMinutes);
    final completedTasks = studyTasks.where((t) => t.isCompleted).toList();
    final completedMinutes = completedTasks.fold(0, (sum, t) => sum + t.actualMinutes);
    final inProgressTasks = studyTasks.where((t) => t.isInProgress).length;
    final remainingMinutes = (totalEstimated - completedMinutes).clamp(0, totalEstimated);

    return Row(
      children: [
        Expanded(
          child: _ProgressCard(
            label: 'Planned',
            value: '${totalEstimated}m',
            icon: Icons.schedule_rounded,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProgressCard(
            label: 'Completed',
            value: '${completedMinutes}m',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProgressCard(
            label: 'Remaining',
            value: '${remainingMinutes}m',
            icon: Icons.timer_rounded,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, DailyPlanTask task, int index) {
    final isBreak = task.type == DailyPlanTaskType.breakTime;
    
    return Card(
      key: ValueKey(task.id),
      margin: const EdgeInsets.only(bottom: 8),
      color: isBreak ? AppColors.primarySoft : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(
          color: task.isCompleted ? AppColors.success : (task.isInProgress ? AppColors.primary : AppColors.border),
          width: task.isCompleted || task.isInProgress ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Drag handle
                Icon(Icons.drag_indicator_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 12),
                // Task type icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTaskTypeColor(task.type).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(_getTaskTypeIcon(task.type), color: _getTaskTypeColor(task.type), size: 20),
                ),
                const SizedBox(width: 12),
                // Task info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      )),
                      if (task.description.isNotEmpty)
                        Text(task.description, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    task.status.displayName,
                    style: AppTextStyles.caption.copyWith(
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Time
                Text(
                  '${task.estimatedMinutes}m',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 8),
                // Priority score
                if (!isBreak)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priorityScore).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'P${task.priorityScore}',
                      style: AppTextStyles.caption.copyWith(
                        color: _getPriorityColor(task.priorityScore),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                if (!task.isCompleted && !task.isInProgress) ...[
                  Expanded(
                    child: OutlinedPillButton(
                      label: 'Start',
                      icon: Icons.play_arrow_rounded,
                      onPressed: () => _updateTaskStatus(ref, task, DailyPlanTaskStatus.inProgress),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (task.isInProgress) ...[
                  Expanded(
                    child: PrimaryPillButton(
                      label: 'Complete',
                      icon: Icons.check_rounded,
                      onPressed: () => _completeTask(ref, task),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedPillButton(
                      label: 'Pause',
                      icon: Icons.pause_rounded,
                      onPressed: () => _updateTaskStatus(ref, task, DailyPlanTaskStatus.pending),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (task.isCompleted) ...[
                  Expanded(
                    child: OutlinedPillButton(
                      label: 'Reopen',
                      icon: Icons.refresh_rounded,
                      onPressed: () => _updateTaskStatus(ref, task, DailyPlanTaskStatus.pending),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (!task.isCompleted) ...[
                  Expanded(
                    child: OutlinedPillButton(
                      label: 'Skip',
                      icon: Icons.skip_next_rounded,
                      onPressed: () => _updateTaskStatus(ref, task, DailyPlanTaskStatus.skipped),
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                IconButton(
                  icon: Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                  onPressed: () => _showTaskOptions(context, ref, task),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTaskTypeColor(DailyPlanTaskType type) {
    switch (type) {
      case DailyPlanTaskType.studyChapter:
        return AppColors.primary;
      case DailyPlanTaskType.revision:
        return AppColors.warning;
      case DailyPlanTaskType.flashcard:
        return AppColors.secondary;
      case DailyPlanTaskType.breakTime:
        return AppColors.success;
      case DailyPlanTaskType.custom:
        return AppColors.textSecondary;
    }
  }

  IconData _getTaskTypeIcon(DailyPlanTaskType type) {
    switch (type) {
      case DailyPlanTaskType.studyChapter:
        return Icons.menu_book_rounded;
      case DailyPlanTaskType.revision:
        return Icons.repeat_rounded;
      case DailyPlanTaskType.flashcard:
        return Icons.style_rounded;
      case DailyPlanTaskType.breakTime:
        return Icons.coffee_rounded;
      case DailyPlanTaskType.custom:
        return Icons.edit_rounded;
    }
  }

  Color _getStatusColor(DailyPlanTaskStatus status) {
    switch (status) {
      case DailyPlanTaskStatus.pending:
        return AppColors.textSecondary;
      case DailyPlanTaskStatus.inProgress:
        return AppColors.primary;
      case DailyPlanTaskStatus.completed:
        return AppColors.success;
      case DailyPlanTaskStatus.skipped:
        return AppColors.warning;
    }
  }

  Color _getPriorityColor(int score) {
    if (score >= 1000) return AppColors.error;
    if (score >= 500) return AppColors.warning;
    if (score >= 100) return AppColors.primary;
    return AppColors.textSecondary;
  }

  void _onReorder(int oldIndex, int newIndex) {
    final userId = 'user_1';
    final tasks = ref.read(dailyPlanTasksProvider(userId, _selectedDate));
    if (newIndex > oldIndex) newIndex--;
    final reorderedTasks = List<DailyPlanTask>.from(tasks);
    final task = reorderedTasks.removeAt(oldIndex);
    reorderedTasks.insert(newIndex, task);
    ref.read(dailyPlanTasksProvider(userId, _selectedDate).notifier).reorderTasks(reorderedTasks);
  }

  Future<void> _generatePlan() async {
    if (_isGenerating) return;
    
    setState(() => _isGenerating = true);
    
    final activeExam = ref.read(activeExamProvider).value;
    if (activeExam == null) {
      setState(() => _isGenerating = false);
      return;
    }

    final settings = ref.read(settingsProvider).value ?? const Settings();
    final userId = 'user_1';
    final existingTasks = ref.read(dailyPlanTasksProvider(userId, _selectedDate));
    final completedToday = ref.read(completedFocusSessionsTodayProvider);

    try {
      final calc = ref.read(calculationServiceProvider);
      final result = calc.generateDailyPlan(
        examId: activeExam.id,
        userId: userId,
        availableMinutes: settings.dailyGoalMinutes,
        dailyGoalMinutes: settings.dailyGoalMinutes,
        completedTodayMinutes: completedToday,
        existingTasks: existingTasks,
        focusBlockMinutes: settings.focusDuration.inMinutes,
        shortBreakMinutes: settings.shortBreakDuration.inMinutes,
        longBreakMinutes: settings.longBreakDuration.inMinutes,
        sessionsBeforeLongBreak: settings.sessionsBeforeLongBreak,
      );

      // Save generated tasks
      final repo = ref.read(examRepositoryProvider);
      for (final task in result.tasks) {
        await repo.addDailyPlanTask(task);
      }

      ref.invalidate(dailyPlanTasksProvider(userId, _selectedDate));
      ref.invalidate(dailyPlanResultProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generated ${result.tasks.length} tasks (${result.studyMinutes}m study, ${result.breakMinutes}m breaks)'),
            action: result.hasWorkloadWarning
                ? SnackBarAction(
                    label: 'View Warning',
                    onPressed: () {},
                  )
                : null,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _updateTaskStatus(WidgetRef ref, DailyPlanTask task, DailyPlanTaskStatus status) {
    final updated = task.copyWith(
      status: status,
      startedAt: status == DailyPlanTaskStatus.inProgress ? DateTime.now() : task.startedAt,
    );
    ref.read(dailyPlanTasksProvider('user_1', _selectedDate).notifier).updateTask(updated);
  }

  void _completeTask(WidgetRef ref, DailyPlanTask task) {
    final updated = task.copyWith(
      status: DailyPlanTaskStatus.completed,
      completedAt: DateTime.now(),
      actualMinutes: task.estimatedMinutes,
    );
    ref.read(dailyPlanTasksProvider('user_1', _selectedDate).notifier).updateTask(updated);
    
    // If it's a revision task, mark the revision item as completed
    if (task.type == DailyPlanTaskType.revision && task.sourceId != null) {
      // This would need a provider to get the revision item
      // For now, just update the task
    }
  }

  void _showTaskOptions(BuildContext context, WidgetRef ref, DailyPlanTask task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Text(task.title, style: AppTextStyles.sheetTitle),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Edit task'),
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(context, ref, task);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded, color: AppColors.error),
              title: Text('Delete', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTask(context, ref, task);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, DailyPlanTask task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final minutesController = TextEditingController(text: task.estimatedMinutes.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minutesController,
              decoration: const InputDecoration(labelText: 'Estimated Minutes'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryPillButton(
            label: 'Save',
            onPressed: () {
              final minutes = int.tryParse(minutesController.text) ?? task.estimatedMinutes;
              final updated = task.copyWith(
                title: titleController.text,
                description: descriptionController.text,
                estimatedMinutes: minutes,
              );
              ref.read(dailyPlanTasksProvider('user_1', _selectedDate).notifier).updateTask(updated);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, WidgetRef ref, DailyPlanTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(dailyPlanTasksProvider('user_1', _selectedDate).notifier).deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProgressCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.title.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }
}