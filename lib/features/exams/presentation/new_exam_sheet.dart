import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/utils/date_utils.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/exam.dart';
import 'package:exam_prep/data/repositories/exam_repository.dart';
import 'package:exam_prep/features/exams/providers/exams_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class NewExamSheet extends ConsumerWidget {
  const NewExamSheet._();
  
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheetTop)),
      ),
      builder: (context) => const NewExamSheet._(),
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: const _NewExamForm(),
    );
  }
}

class _NewExamForm extends ConsumerStatefulWidget {
  const _NewExamForm();
  
  @override
  ConsumerState<_NewExamForm> createState() => _NewExamFormState();
}

class _NewExamFormState extends ConsumerState<_NewExamForm> {
  final _nameController = TextEditingController();
  final _dailyGoalController = TextEditingController(text: '120');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 60));
  int _selectedColorIndex = 0;
  String? _errorMessage;
  
  final List<Color> _colors = [
    const Color(0xFFE9547B), // Pink
    const Color(0xFF34B98A), // Green
    const Color(0xFF3D7BF5), // Blue
    const Color(0xFFF57C3A), // Orange
    const Color(0xFF8B6CF0), // Purple
    const Color(0xFF2E3192), // Indigo
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _dailyGoalController.dispose();
    super.dispose();
  }
  
  bool get _isNameValid => _nameController.text.trim().isNotEmpty;
  bool get _isDateValid => _selectedDate.isAfter(DateTime.now());
  bool get _isValid => _isNameValid && _isDateValid;
  
  @override
  Widget build(BuildContext context) {
    final daysFromToday = _selectedDate.daysUntil(DateTime.now());
    
    return Column(
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
            Text('New exam', style: AppTextStyles.sheetTitle),
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
          controller: _nameController,
          autofocus: true,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: 'e.g. Final Semester',
            hintStyle: AppTextStyles.inputHint,
            errorText: _isNameValid ? null : 'Please enter an exam name',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        Text('EXAM DATE', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(
                color: _isDateValid ? AppColors.inputBorder : Colors.red,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Text(
                  _selectedDate.formatMMMd(), 
                  style: AppTextStyles.inputText.copyWith(
                    color: _isDateValid ? AppColors.textPrimary : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '$daysFromToday days from today',
              style: _isDateValid 
                  ? AppTextStyles.helperText 
                  : AppTextStyles.helperText.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('DAILY GOAL (MINUTES)', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dailyGoalController,
                keyboardType: TextInputType.number,
                style: AppTextStyles.inputText,
                decoration: InputDecoration(
                  hintText: '120',
                  hintStyle: AppTextStyles.inputHint,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('COLOR', style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(_colors.length, (index) {
            final color = _colors[index];
            final isSelected = index == _selectedColorIndex;
            return InkWell(
              onTap: () => setState(() => _selectedColorIndex = index),
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
                      ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4))]
                      : [],
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 24)
                    : null,
              ),
            );
          }),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            style: AppTextStyles.helperText.copyWith(color: Colors.red),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _isValid
                ? () async {
                    setState(() => _errorMessage = null);
                    try {
                      final dailyGoal = int.tryParse(_dailyGoalController.text.trim()) ?? 120;
                      await ref.read(createExamProvider(
                        examName: _nameController.text.trim(),
                        examDate: _selectedDate,
                        colorValue: _colors[_selectedColorIndex].value,
                        dailyGoalMinutes: dailyGoal,
                      ));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Exam created successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        // Navigate to home screen after creating exam
                        context.go('/home');
                      }
                    } catch (e) {
                      setState(() => _errorMessage = 'Failed to create exam: $e');
                    }
                  }
                : null,
            child: Text('Create exam', style: AppTextStyles.buttonText),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
  
  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }
}