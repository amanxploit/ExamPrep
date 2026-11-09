import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/exams/presentation/new_exam_sheet.dart';
import 'package:exam_prep/features/exams/providers/exams_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/features/syllabus/providers/syllabus_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class ExamsScreen extends ConsumerWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(allExamsProvider);
    final repo = ref.watch(examRepositoryProvider);
    final currentActiveExam = repo.getActiveExam();

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
              _buildHeader(context),
              const SizedBox(height: AppSpacing.sectionVertical),
              examsAsync.when(
                data: (exams) =>
                    _buildExamsList(context, ref, exams, currentActiveExam),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildErrorState(),
              ),
              if (currentActiveExam != null) ...[
                const SizedBox(height: AppSpacing.sectionVerticalLarge),
                _buildActiveExamDetails(context, ref, currentActiveExam!),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Everything you\'re prepping for',
                  style: AppTextStyles.overline),
              const SizedBox(height: 4),
              Text('Exams', style: AppTextStyles.screenTitle),
            ],
          ),
        ),
        GradientPlusButton(
          onTap: () => NewExamSheet.show(context),
        ),
      ],
    );
  }

  Widget _buildExamsList(BuildContext context, WidgetRef ref, List<Exam> exams,
      Exam? currentActiveExam) {
    if (exams.isEmpty) {
      return EmptyStateCard(
        icon: Icons.calendar_month_rounded,
        title: 'No exams yet',
        subtitle: 'Create your first exam to start tracking',
        action: PrimaryPillButton(
          label: 'Create exam',
          icon: Icons.add_rounded,
          onPressed: () => NewExamSheet.show(context),
        ),
      );
    }

    return Column(
      children: exams.map((exam) {
        final isActive = exam.id == (currentActiveExam?.id ?? '');
        return _buildExamCard(context, ref, exam, isActive);
      }).toList(),
    );
  }

  Widget _buildExamCard(
      BuildContext context, WidgetRef ref, Exam exam, bool isActive) {
    final stats = ref.watch(examStatsProvider(exam.id));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border:
            isActive ? Border.all(color: AppColors.primary, width: 1.5) : null,
        boxShadow: isActive ? [AppShadows.cardShadow] : [],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Days box
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.indigoSoft,
                    borderRadius: BorderRadius.circular(AppRadius.daysBox),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${exam.daysLeft}',
                        style: AppTextStyles.statNumber.copyWith(
                          color: AppColors.indigo,
                          fontSize: 30,
                        ),
                      ),
                      Text('DAYS',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.indigo)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Exam info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exam.name,
                              style: AppTextStyles.examNameList,
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text('Active',
                                  style: AppTextStyles.activeBadge),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded,
                            color: AppColors.textMuted, size: 20),
                        onSelected: (value) {
                          if (value == 'activate') {
                            ref.read(setActiveExamProvider(exam.id).future);
                          } else if (value == 'edit') {
                            _showEditExamSheet(context, ref, exam);
                          } else if (value == 'delete') {
                            _confirmDeleteExam(context, ref, exam);
                          }
                        },
                        itemBuilder: (context) => [
                          if (!isActive)
                            const PopupMenuItem(
                                value: 'activate',
                                child: Text('Set as active')),
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${exam.examDate.formatMMMd()} · ${stats['totalChapters']} subjects',
                      style: AppTextStyles.caption,
                    ),
                    Text(
                      '${stats['syllabusPercent']}% · ${stats['completedChapters']}/${stats['totalChapters']} chapters',
                      style: AppTextStyles.progressPercent,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                PillProgressBar(
                  value: (stats['totalChapters'] ?? 0) > 0
                      ? ((stats['completedChapters'] ?? 0) /
                          (stats['totalChapters'] ?? 1))
                      : 0.0,
                  color: AppColors.indigo,
                  height: 4,
                  trackColor: AppColors.track,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveExamDetails(
      BuildContext context, WidgetRef ref, Exam exam) {
    final stats = ref.watch(examStatsProvider(exam.id));
    final subjects = ref.watch(subjectsForExamProvider(exam.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chapter progress', style: AppTextStyles.sectionTitle),
            Text(
              '${stats['completedChapters']} / ${stats['totalChapters']}',
              style: AppTextStyles.body.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...subjects.take(5).map((subject) {
          final chapters = ref
              .read(examRepositoryProvider)
              .getChaptersForSubject(subject.id);
          final completed = chapters.where((c) => c.isCompleted).length;
          final total = chapters.length;
          final progress = total > 0 ? completed / total : 0.0;
          final status =
              ref.watch(subjectStatusesProvider)[subject.id] ?? 'on track';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: subject.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(subject.name, style: AppTextStyles.subjectName),
                ),
                Text(
                  '$completed/$total',
                  style: AppTextStyles.caption
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  child: PillProgressBar(
                    value: progress,
                    color: status == 'on track'
                        ? AppColors.success
                        : AppColors.primary,
                    height: 4,
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => context.push('/syllabus'),
            child: Text('View all chapters >', style: AppTextStyles.linkText),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionVertical),
        // Stats tiles
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.menu_book_rounded,
                iconColor: AppColors.success,
                softColor: AppColors.successSoft,
                value: '${stats['completedChapters']}',
                label: 'Completed',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.flag_rounded,
                iconColor: AppColors.blue,
                softColor: AppColors.blueSoft,
                value: '${stats['remainingChapters']}',
                label: 'Remaining',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.timer_rounded,
                iconColor: AppColors.purple,
                softColor: AppColors.purpleSoft,
                value: AppDateUtils.formatDuration(
                    Duration(minutes: stats['focusMinutes'] ?? 0)),
                label: 'Focus time',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.orange,
                softColor: AppColors.orangeSoft,
                value: '${stats['streak']}',
                label: 'Day streak',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.success,
                softColor: AppColors.successSoft,
                value: '${stats['syllabusPercent']}%',
                label: 'Syllabus %',
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditExamSheet(BuildContext context, WidgetRef ref, Exam exam) {
    final TextEditingController nameController =
        TextEditingController(text: exam.name);
    DateTime selectedDate = exam.examDate;
    int dailyGoal = exam.dailyGoalMinutes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
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
                  Row(
                    children: [
                      Text('Edit Exam', style: AppTextStyles.sheetTitle),
                      const Spacer(),
                      SquareIconButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.pop(context),
                        size: 36,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('EXAM NAME', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'e.g. Final Semester',
                      hintStyle: AppTextStyles.inputHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('EXAM DATE', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 2)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme:
                                ColorScheme.light(primary: AppColors.primary),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: AppColors.textSecondary, size: 20),
                          const SizedBox(width: 12),
                          Text(selectedDate.formatMMMd(),
                              style: AppTextStyles.inputText),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${selectedDate.daysUntil(DateTime.now())} days from today',
                    style: AppTextStyles.helperText,
                  ),
                  const SizedBox(height: 16),
                  Text('DAILY GOAL (MINUTES)', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller:
                              TextEditingController(text: dailyGoal.toString()),
                          style: AppTextStyles.inputText,
                          decoration: InputDecoration(
                            hintText: '120',
                            hintStyle: AppTextStyles.inputHint,
                          ),
                          onChanged: (val) =>
                              dailyGoal = int.tryParse(val) ?? dailyGoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty || !selectedDate.isInFuture) return;
                        ref.read(updateExamProvider(exam.copyWith(
                          name: name,
                          examDate: selectedDate,
                          dailyGoalMinutes: dailyGoal,
                        )));
                        Navigator.pop(context);
                      },
                      child:
                          Text('Save Changes', style: AppTextStyles.buttonText),
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

  void _confirmDeleteExam(BuildContext context, WidgetRef ref, Exam exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete exam?', style: AppTextStyles.sheetTitle),
        content: Text(
          'This will delete "${exam.name}" and all its subjects, chapters, tasks, and sessions. This action cannot be undone.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: AppTextStyles.buttonText
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(deleteExamProvider(exam.id).future);
              Navigator.pop(context);
            },
            child: Text('Delete',
                style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return EmptyStateCard(
      icon: Icons.error_outline_rounded,
      title: 'Error loading exams',
      subtitle: 'Please try again',
      iconColor: Colors.red,
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color softColor;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.softColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: AppTextStyles.statNumber.copyWith(fontSize: 20)),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
