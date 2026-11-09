import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/subject.dart';
import 'package:exam_prep/data/models/chapter.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/exams/presentation/new_exam_sheet.dart';
import 'package:exam_prep/features/syllabus/providers/syllabus_providers.dart';
import 'package:exam_prep/features/home/providers/home_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class SyllabusScreen extends ConsumerWidget {
  const SyllabusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeExam = ref.watch(activeExamProvider).value;
    final subjectsAsync = ref.watch(subjectsProvider);

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
                subjectsAsync.when(
                  data: (subjects) =>
                      _buildSubjectsList(context, ref, subjects),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _buildErrorState(),
                ),
              ] else ...[
                _buildNoExamState(context),
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
              Text('Your syllabus', style: AppTextStyles.overline),
              const SizedBox(height: 4),
              Text('Subjects', style: AppTextStyles.screenTitle),
            ],
          ),
        ),
        if (activeExam != null) ...[
          ExamSelectorChip(
            examName: activeExam.name,
            dotColor: activeExam.color,
            onTap: () => _showExamSelectorSheet(ref),
          ),
          const SizedBox(width: 12),
        ],
        GradientPlusButton(
          onTap: () => _showAddSubjectSheet(context, ref),
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

  Widget _buildSubjectsList(
      BuildContext context, WidgetRef ref, List<Subject> subjects) {
    if (subjects.isEmpty) {
      return _buildEmptySubjectsState(context, ref);
    }

    return Column(
      children: subjects.map((subject) {
        return _buildSubjectCard(context, ref, subject);
      }).toList(),
    );
  }

  Widget _buildEmptySubjectsState(BuildContext context, WidgetRef ref) {
    return EmptyStateCard(
      icon: Icons.layers_rounded,
      title: 'No subjects yet',
      subtitle: 'Add your first subject to start organizing your syllabus',
      iconColor: AppColors.primary,
      backgroundColor: AppColors.primarySoft,
      action: PrimaryPillButton(
        label: 'Add subject',
        icon: Icons.add_rounded,
        onPressed: () => _showAddSubjectSheet(context, ref),
      ),
    );
  }

  Widget _buildNoExamState(BuildContext context) {
    return EmptyStateCard(
      icon: Icons.school_rounded,
      title: 'No active exam',
      subtitle: 'Create or select an exam to manage your syllabus',
      action: PrimaryPillButton(
        label: 'Create exam',
        icon: Icons.add_rounded,
        onPressed: () => NewExamSheet.show(context),
      ),
    );
  }

  Widget _buildSubjectCard(
      BuildContext context, WidgetRef ref, Subject subject) {
    final chaptersProvider = ref.watch(chaptersForSubjectProvider(subject.id));
    final status = ref.watch(subjectStatusesProvider)[subject.id] ?? 'on track';
    final isOnTrack = status == 'on track';

    return chaptersProvider.when(
      data: (chapters) {
        final total = chapters.length;
        final completed = chapters.where((c) => c.isCompleted).length;
        final progress = total > 0 ? completed / total : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ExpandableSubjectCard(
            subject: subject,
            chapters: chapters,
            total: total,
            completed: completed,
            progress: progress,
            isOnTrack: isOnTrack,
            onToggleChapter: (chapter) =>
                ref.read(toggleChapterProvider(chapter).future),
            onAddChapter: () => _showAddChapterSheet(context, ref, subject),
            onReorder: (newChapters) =>
                ref.read(reorderChaptersProvider(newChapters).future),
            onDeleteSubject: () => _confirmDeleteSubject(context, ref, subject),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

  void _showAddSubjectSheet(BuildContext context, WidgetRef ref) {
    final exam = ref.read(activeExamProvider).value;
    if (exam == null) return;

    final TextEditingController nameController = TextEditingController();
    int selectedColorIndex = 0;
    final TextEditingController bulkController = TextEditingController();

    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.blue,
      AppColors.orange,
      AppColors.purple,
      AppColors.indigo,
    ];

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
                  Text('New Subject', style: AppTextStyles.sheetTitle),
                  const SizedBox(height: 20),
                  Text('SUBJECT NAME', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'e.g. Mathematics',
                      hintStyle: AppTextStyles.inputHint,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('COLOR', style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(colors.length, (index) {
                      final color = colors[index];
                      final isSelected = index == selectedColorIndex;
                      return InkWell(
                        onTap: () => setState(() => selectedColorIndex = index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color: color.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 4))
                                  ]
                                : [],
                          ),
                          child: isSelected
                              ? Icon(Icons.check_rounded,
                                  color: Colors.white, size: 24)
                              : null,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Text('BULK CHAPTERS (OPTIONAL)',
                      style: AppTextStyles.fieldLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: bulkController,
                    maxLines: 4,
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'One chapter per line',
                      hintStyle: AppTextStyles.inputHint,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isEmpty) return;

                        final bulkChapters = bulkController.text
                            .split('\n')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        ref.read(addSubjectProvider(
                          examId: exam.id,
                          subjectName: name,
                          colorValue: colors[selectedColorIndex].value,
                          bulkChapters:
                              bulkChapters.isEmpty ? null : bulkChapters,
                        ));
                        Navigator.pop(context);
                      },
                      child:
                          Text('Add Subject', style: AppTextStyles.buttonText),
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

  void _showAddChapterSheet(
      BuildContext context, WidgetRef ref, Subject subject) {
    final TextEditingController nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) {
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
              Text('Add Chapter', style: AppTextStyles.sheetTitle),
              const SizedBox(height: 20),
              Text('CHAPTER NAME', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                autofocus: true,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: 'e.g. Chapter 1: Algebra',
                  hintStyle: AppTextStyles.inputHint,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    ref.read(addChapterProvider(
                      subjectId: subject.id,
                      chapterName: name,
                    ));
                    Navigator.pop(context);
                  },
                  child: Text('Add Chapter', style: AppTextStyles.buttonText),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteSubject(
      BuildContext context, WidgetRef ref, Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete subject?', style: AppTextStyles.sheetTitle),
        content: Text(
          'This will delete all chapters in "${subject.name}". This action cannot be undone.',
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
              ref.read(deleteSubjectProvider(subject.id).future);
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
      title: 'Error loading subjects',
      subtitle: 'Please try again',
      iconColor: Colors.red,
    );
  }
}

class _ExpandableSubjectCard extends StatefulWidget {
  final Subject subject;
  final List<Chapter> chapters;
  final int total;
  final int completed;
  final double progress;
  final bool isOnTrack;
  final Future<void> Function(Chapter) onToggleChapter;
  final VoidCallback onAddChapter;
  final Future<void> Function(List<Chapter>) onReorder;
  final VoidCallback onDeleteSubject;

  const _ExpandableSubjectCard({
    required this.subject,
    required this.chapters,
    required this.total,
    required this.completed,
    required this.progress,
    required this.isOnTrack,
    required this.onToggleChapter,
    required this.onAddChapter,
    required this.onReorder,
    required this.onDeleteSubject,
  });

  @override
  State<_ExpandableSubjectCard> createState() => _ExpandableSubjectCardState();
}

class _ExpandableSubjectCardState extends State<_ExpandableSubjectCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.subject.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.subject.order + 1}',
                        style: AppTextStyles.body.copyWith(
                          color: widget.subject.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.subject.name,
                      style: AppTextStyles.subjectName,
                    ),
                  ),
                  Text(
                    '${widget.completed}/${widget.total}',
                    style: AppTextStyles.caption
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.isOnTrack
                          ? AppColors.successSoft
                          : AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: widget.isOnTrack
                        ? Icon(Icons.check_rounded,
                            color: AppColors.success, size: 16)
                        : Icon(Icons.radio_button_unchecked_rounded,
                            color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          PillProgressBar(
            value: widget.progress,
            color: widget.isOnTrack ? AppColors.success : AppColors.primary,
            height: 4,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        const SizedBox(height: 12),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.chapters.length + 1,
          onReorder: (oldIndex, newIndex) {
            if (oldIndex == widget.chapters.length ||
                newIndex == widget.chapters.length) return;
            final newChapters = List<Chapter>.from(widget.chapters);
            final item = newChapters.removeAt(oldIndex);
            newChapters.insert(newIndex, item);
            widget.onReorder(newChapters);
          },
          itemBuilder: (context, index) {
            if (index == widget.chapters.length) {
              return _buildAddChapterRow();
            }
            return _buildChapterRow(widget.chapters[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildChapterRow(Chapter chapter, int index) {
    return Padding(
      key: ValueKey(chapter.id),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Drag handle
          Icon(Icons.drag_indicator_rounded,
              color: AppColors.textMuted, size: 20),
          const SizedBox(width: 12),
          // Checkbox
          InkWell(
            onTap: () => widget.onToggleChapter(chapter),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedScale(
              scale: 1.0,
              duration: AppDurations.pressScale,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: chapter.isCompleted
                      ? AppColors.success
                      : Colors.transparent,
                  border: Border.all(
                    color: chapter.isCompleted
                        ? AppColors.success
                        : AppColors.track,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: chapter.isCompleted
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Chapter name
          Expanded(
            child: Text(
              chapter.name,
              style: AppTextStyles.chapterName.copyWith(
                decoration:
                    chapter.isCompleted ? TextDecoration.lineThrough : null,
                color: chapter.isCompleted
                    ? AppColors.textMuted
                    : AppColors.textPrimary,
              ),
            ),
          ),
          // Menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded,
                color: AppColors.textMuted, size: 20),
            onSelected: (value) {
              if (value == 'rename') _showRenameChapterDialog(chapter);
              if (value == 'delete') _confirmDeleteChapter(chapter);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddChapterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.onAddChapter,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            const SizedBox(width: 32),
            Icon(Icons.add_circle_outline_rounded,
                color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Text('Add chapter', style: AppTextStyles.linkText),
          ],
        ),
      ),
    );
  }

  void _showRenameChapterDialog(Chapter chapter) {
    final controller = TextEditingController(text: chapter.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename chapter', style: AppTextStyles.sheetTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: 'Chapter name',
            hintStyle: AppTextStyles.inputHint,
          ),
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
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                widget.onToggleChapter(chapter.copyWith(name: name));
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteChapter(Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete chapter?', style: AppTextStyles.sheetTitle),
        content:
            Text('This action cannot be undone.', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: AppTextStyles.buttonText
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              widget.onToggleChapter(
                  chapter); // This should be deleteChapterProvider
              Navigator.pop(context);
            },
            child: Text('Delete',
                style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
