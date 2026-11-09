import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/data/models/settings.dart';
import 'package:exam_prep/features/onboarding/presentation/onboarding_screen.dart';
import 'package:exam_prep/features/settings/providers/settings_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value ?? Settings();
    
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
              _buildSection(
                'Timer',
                children: [
                  _buildStepperTile(
                    'Focus duration',
                    settings.focusMinutes,
                    (val) => _updateSettings(ref, settings.copyWith(focusMinutes: val)),
                    5,
                    120,
                    icon: Icons.timer_rounded,
                    iconColor: AppColors.primary,
                  ),
                  _buildStepperTile(
                    'Short break',
                    settings.shortBreakMinutes,
                    (val) => _updateSettings(ref, settings.copyWith(shortBreakMinutes: val)),
                    1,
                    30,
                    icon: Icons.coffee_rounded,
                    iconColor: AppColors.success,
                  ),
                  _buildStepperTile(
                    'Long break',
                    settings.longBreakMinutes,
                    (val) => _updateSettings(ref, settings.copyWith(longBreakMinutes: val)),
                    5,
                    60,
                    icon: Icons.hotel_rounded,
                    iconColor: AppColors.successDark,
                  ),
                  _buildStepperTile(
                    'Sessions before long break',
                    settings.sessionsBeforeLongBreak,
                    (val) => _updateSettings(ref, settings.copyWith(sessionsBeforeLongBreak: val)),
                    2,
                    10,
                    icon: Icons.repeat_rounded,
                    iconColor: AppColors.orange,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionVertical),
              _buildSection(
                'Behavior',
                children: [
                  SwitchListTile(
                    title: Text('Auto-start breaks', style: AppTextStyles.body),
                    subtitle: Text('Automatically start the next session when one ends', style: AppTextStyles.caption),
                    value: settings.autoStartBreaks,
                    onChanged: (val) => _updateSettings(ref, settings.copyWith(autoStartBreaks: val)),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionVertical),
              _buildSection(
                'Notifications',
                children: [
                  _buildReminderTile(settings, ref),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionVertical),
              _buildSection(
                'Feedback',
                children: [
                  SwitchListTile(
                    title: Text('Sound', style: AppTextStyles.body),
                    subtitle: Text('Play sound when timer completes', style: AppTextStyles.caption),
                    value: settings.sound,
                    onChanged: (val) => _updateSettings(ref, settings.copyWith(sound: val)),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    title: Text('Vibration', style: AppTextStyles.body),
                    subtitle: Text('Vibrate when timer completes', style: AppTextStyles.caption),
                    value: settings.vibration,
                    onChanged: (val) => _updateSettings(ref, settings.copyWith(vibration: val)),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionVertical),
              _buildSection(
                'Data',
                children: [
                  ListTile(
                    leading: Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24),
                    title: Text('Reset all data', style: AppTextStyles.body.copyWith(color: Colors.red)),
                    subtitle: Text('Permanently delete all exams, subjects, chapters, tasks, and sessions', style: AppTextStyles.caption),
                    onTap: () => _confirmResetAllData(context, ref),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionVertical),
              _buildSection(
                'About',
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: AppColors.textSecondary, size: 24),
                    title: Text('Version', style: AppTextStyles.body),
                    trailing: Text('1.0.0', style: AppTextStyles.caption),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: Icon(Icons.code_rounded, color: AppColors.textSecondary, size: 24),
                    title: Text('Open Source', style: AppTextStyles.body),
                    trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: AppColors.textSecondary, size: 24),
                    title: Text('Privacy Policy', style: AppTextStyles.body),
                    trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
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
              Text('Settings', style: AppTextStyles.screenTitle),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSection(String title, {required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 12),
        SoftCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
  
  Widget _buildStepperTile(
    String label,
    int value,
    ValueChanged<int> onChanged,
    int min,
    int max, {
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          _buildStepper(value, onChanged, min, max),
        ],
      ),
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
  
  Widget _buildReminderTile(Settings settings, WidgetRef ref) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.notifications_active_rounded, color: AppColors.orange, size: 20),
      ),
      title: Text('Daily reminder', style: AppTextStyles.body),
      subtitle: Text(
        settings.dailyReminderTime != null
            ? 'Remind me at ${settings.dailyReminderTime}'
            : 'Set a daily reminder time',
        style: AppTextStyles.caption,
      ),
      trailing: settings.dailyReminderTime != null
          ? TextButton(
              onPressed: () => _updateSettings(ref, settings.copyWith(clearReminderTime: true)),
              child: Text('Remove', style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
            )
          : Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: settings.dailyReminderTime == null ? () => _pickReminderTime(settings, ref) : null,
      contentPadding: EdgeInsets.zero,
    );
  }
  
  void _pickReminderTime(Settings settings, WidgetRef ref) async {
    final time = await showTimePicker(
      context: ref.context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (time != null) {
      final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      _updateSettings(ref, settings.copyWith(dailyReminderTime: timeString));
    }
  }
  
  void _updateSettings(WidgetRef ref, Settings newSettings) {
    ref.read(updateSettingsProvider(newSettings));
  }
  
  void _confirmResetAllData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset all data?', style: AppTextStyles.sheetTitle),
        content: Text(
          'This will permanently delete ALL your exams, subjects, chapters, tasks, focus sessions, and settings. This action cannot be undone.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonText.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(resetAllDataProvider.future);
              Navigator.pop(context);
            },
            child: Text('Reset', style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}