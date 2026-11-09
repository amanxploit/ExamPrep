import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/models/study_task.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/exams/presentation/new_exam_sheet.dart';
import 'package:exam_prep/features/focus/presentation/focus_screen.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/features/home/providers/task_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeExam = ref.watch(activeExamProvider).value;
    
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
              _buildGreetingAndSettings(context, ref),
              const SizedBox(height: AppSpacing.sectionVertical),
              if (activeExam != null) ...[
                _buildExamSelector(ref, activeExam),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildCountdownCard(context, ref, activeExam),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildStatCards(ref),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildFocusCard(context, ref),
                const SizedBox(height: AppSpacing.sectionVertical),
                _buildTodaysPlan(context, ref),
              ] else ...[
                _buildEmptyState(context),
              ],
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildGreetingAndSettings(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppDateUtils.greeting(),
                style: AppTextStyles.overline,
              ),
              const SizedBox(height: 4),
              Text(
                "Let's get ready",
                style: AppTextStyles.screenTitle,
              ),
            ],
          ),
        ),
        SquareIconButton(
          icon: Icons.tune_rounded,
          onTap: () => context.push('/settings'),
        ),
      ],
    );
  }
  
  Widget _buildExamSelector(WidgetRef ref, Exam exam) {
    return ExamSelectorChip(
      examName: exam.name,
      dotColor: exam.color,
      onTap: () => _showExamSelectorSheet(ref),
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
  
  Widget _buildCountdownCard(BuildContext context, WidgetRef ref, Exam exam) {
    final daysLeft = ref.watch(daysLeftProvider);
    final percent = ref.watch(percentPreparedProvider);
    final completed = ref.watch(completedChaptersProvider);
    final total = ref.watch(totalChaptersProvider);
    
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: daysLeft),
      duration: AppDurations.countUpAnimation,
      curve: Curves.easeOutCubic,
      builder: (context, animatedDays, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppGradients.gradientCard,
            borderRadius: BorderRadius.circular(AppRadius.countdownCard),
            boxShadow: [AppShadows.pinkGlowShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exam.name,
                      style: AppTextStyles.examNameCountdown,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    exam.examDate.formatMMMd(),
                    style: AppTextStyles.dateCountdown,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$animatedDays',
                    style: AppTextStyles.hugeNumber,
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'days left',
                      style: AppTextStyles.examNameCountdown.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(percent * 100).round()}% prepared',
                    style: AppTextStyles.examNameCountdown,
                  ),
                  Text(
                    '$completed/$total chapters',
                    style: AppTextStyles.dateCountdown,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PillProgressBar(
                value: percent,
                color: Colors.white,
                height: 4,
                trackColor: AppColors.white30,
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStatCards(WidgetRef ref) {
    final total = ref.watch(totalChaptersProvider);
    final completed = ref.watch(completedChaptersProvider);
    final remaining = ref.watch(remainingChaptersProvider);
    
    return Row(
      children: [
        Expanded(
          child: StatTile(
            icon: Icons.menu_book_rounded,
            value: '$total',
            label: 'Total',
            iconColor: AppColors.primary,
            softColor: AppColors.primarySoft,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatTile(
            icon: Icons.check_circle_rounded,
            value: '$completed',
            label: 'Done',
            iconColor: AppColors.success,
            softColor: AppColors.successSoft,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatTile(
            icon: Icons.flag_rounded,
            value: '$remaining',
            label: 'To go',
            iconColor: AppColors.blue,
            softColor: AppColors.blueSoft,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFocusCard(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(currentStreakProvider);
    final todayMinutes = ref.watch(todayFocusMinutesProvider);
    final progress = ref.watch(todayFocusProgressProvider);
    final goal = ref.watch(dailyGoalMinutesProvider);
    
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.schedule_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ready to focus?', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.caption,
                        children: [
                          TextSpan(
                            text: '🔥 ',
                            style: const TextStyle(fontSize: 14),
                          ),
                          TextSpan(
                            text: '$streak days',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                          ),
                          TextSpan(
                            text: ' · ',
                            style: AppTextStyles.caption,
                          ),
                          TextSpan(
                            text: '$todayMinutes min today',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryPillButton(
                label: '▶ Start',
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.go('/focus'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PillProgressBar(
            value: progress,
            color: AppColors.primary,
            height: 6,
          ),
          const SizedBox(height: 8),
          Text(
            '$todayMinutes/$goal min toward today\'s goal',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTodaysPlan(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(todayTasksProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today's plan", style: AppTextStyles.sectionTitle),
            TextButton(
              onPressed: () => _showAddTaskSheet(context, ref),
              child: Text('+ Add task', style: AppTextStyles.linkText),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          _buildEmptyTasksState()
        else
          _buildTasksList(context, ref, tasks),
      ],
    );
  }
  
  Widget _buildEmptyTasksState() {
    return SoftCard(
      color: AppColors.successSoft,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconBadge(
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            softColor: AppColors.success.withOpacity(0.15),
            size: 56,
            iconSize: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You're all caught up", style: AppTextStyles.emptyTitle),
                const SizedBox(height: 4),
                Text(
                  'Great job! No tasks for today.',
                  style: AppTextStyles.emptySubtitle,
                ),
              ],
            ),
          ),
          Text('📋', style: TextStyle(fontSize: 48)),
        ],
      ),
    );
  }
  
  Widget _buildTasksList(BuildContext context, WidgetRef ref, List<StudyTask> tasks) {
    return Column(
      children: tasks.map((task) {
        final subject = task.subjectId != null 
            ? ref.read(examRepositoryProvider).getSubject(task.subjectId!)
            : null;
        
        return Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 24),
          ),
          confirmDismiss: (direction) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete task?', style: AppTextStyles.sheetTitle),
                content: Text('This action cannot be undone.', style: AppTextStyles.body),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel', style: AppTextStyles.buttonText.copyWith(color: AppColors.textSecondary)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete', style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
                  ),
                ],
              ),
            );
            return confirmed ?? false;
          },
          onDismissed: (_) => ref.read(deleteTaskProvider(task.id).future),
          child: InkWell(
            onTap: () => ref.read(toggleTaskProvider(task).future),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedScale(
              scale: 1.0,
              duration: AppDurations.pressScale,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.track),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: task.isDone 
                            ? (subject?.color ?? AppColors.success)
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isDone 
                              ? (subject?.color ?? AppColors.success)
                              : AppColors.track,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: task.isDone
                          ? Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    if (subject != null) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: subject.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTextStyles.body.copyWith(
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                          color: task.isDone ? AppColors.textMuted : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  void _showAddTaskSheet(BuildContext context, WidgetRef ref) {
    final exam = ref.read(activeExamProvider).value;
    if (exam == null) return;
    
    final subjects = ref.read(examRepositoryProvider).getSubjectsForExam(exam.id);
    String? selectedSubjectId;
    DateTime selectedDate = DateTime.now();
    
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
            final titleController = TextEditingController();
            
            void _submitTask() {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              ref.read(addTaskProvider(
                examId: exam.id,
                title: title,
                subjectId: selectedSubjectId,
                dueDate: selectedDate,
              ));
              Navigator.pop(context);
            }
            
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
                  Text('Add Task', style: AppTextStyles.sheetTitle),
                  const SizedBox(height: 20),
                  Text('TASK TITLE', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'e.g. Review Chapter 3',
                      hintStyle: AppTextStyles.inputHint,
                    ),
                    onSubmitted: (_) => _submitTask(),
                  ),
                  const SizedBox(height: 16),
                  Text('SUBJECT (OPTIONAL)', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedSubjectId,
                    decoration: InputDecoration(
                      hintText: 'Select subject',
                      hintStyle: AppTextStyles.inputHint,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('No subject')),
                      ...subjects.map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: s.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(s.name),
                          ],
                        ),
                      )),
                    ],
                    onChanged: (value) => setState(() => selectedSubjectId = value),
                  ),
                  const SizedBox(height: 16),
                  Text('DUE DATE', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(primary: AppColors.primary),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            selectedDate.formatMMMd(),
                            style: AppTextStyles.inputText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _submitTask,
                      child: Text('Add Task', style: AppTextStyles.buttonText),
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
  
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        EmptyStateCard(
          icon: Icons.school_rounded,
          title: 'No exams yet',
          subtitle: 'Create your first exam to start tracking your preparation',
          action: PrimaryPillButton(
            label: 'Create your first exam',
            icon: Icons.add_rounded,
            onPressed: () => NewExamSheet.show(context),
          ),
        ),
      ],
    );
  }
}