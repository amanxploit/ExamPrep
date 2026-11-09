import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_design.dart';

class AppTextStyles {
  // Plus Jakarta Sans for UI
  static final _plusJakarta = GoogleFonts.plusJakartaSans;
  
  // Inter for numbers
  static final _inter = GoogleFonts.inter;
  
  // Screen title: 28 / w700, textPrimary
  static TextStyle get screenTitle => _plusJakarta(
    fontSize: AppSpacing.screenTitleSize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  // Overline greeting: 14 / w400, textSecondary
  static TextStyle get overline => _plusJakarta(
    fontSize: AppSpacing.overlineSize,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.2,
  );
  
  // Card title: 17 / w600
  static TextStyle get cardTitle => _plusJakarta(
    fontSize: AppSpacing.cardTitleSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Body: 14 / w500
  static TextStyle get body => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Caption: 12 / w500, textSecondary
  static TextStyle get caption => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  // Huge number (countdown): Inter 84 / w800, white, letterSpacing -3
  static TextStyle get hugeNumber => _inter(
    fontSize: AppSpacing.hugeNumberSize,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.0,
    letterSpacing: -3.0,
  );
  
  // Timer: Inter 64 / w800
  static TextStyle get timerNumber => _inter(
    fontSize: AppSpacing.timerNumberSize,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.0,
    letterSpacing: -2.0,
  );
  
  // Stat number: 24 / w700
  static TextStyle get statNumber => _plusJakarta(
    fontSize: AppSpacing.statNumberSize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  // Exam name in countdown: 15 w500 white
  static TextStyle get examNameCountdown => _plusJakarta(
    fontSize: AppSpacing.examNameSize,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 1.3,
  );
  
  // Date in countdown: white at 85%
  static TextStyle get dateCountdown => _plusJakarta(
    fontSize: AppSpacing.dateSize,
    fontWeight: FontWeight.w500,
    color: AppColors.white85,
    height: 1.3,
  );
  
  // Section title: 18 w700
  static TextStyle get sectionTitle => _plusJakarta(
    fontSize: AppSpacing.sectionTitleSize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Sheet title: 22 w700
  static TextStyle get sheetTitle => _plusJakarta(
    fontSize: AppSpacing.sheetTitleSize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Field label: 12 w600 letterSpacing 1 textSecondary uppercase
  static TextStyle get fieldLabel => _plusJakarta(
    fontSize: AppSpacing.fieldLabelSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 1.0,
  );
  
  // Helper text: 13 pink
  static TextStyle get helperText => _plusJakarta(
    fontSize: AppSpacing.helperTextSize,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
  );
  
  // Timer label: 13 w700 letterSpacing 1.5
  static TextStyle get timerLabel => _plusJakarta(
    fontSize: AppSpacing.labelSize,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.3,
    letterSpacing: 1.5,
  );
  
  // Timer subtitle
  static TextStyle get timerSubtitle => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w500,
    color: AppColors.white85,
    height: 1.3,
  );
  
  // Exam name in list: 18 w700
  static TextStyle get examNameList => _plusJakarta(
    fontSize: AppSpacing.examNameSize + 3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Subject name: 16 w600
  static TextStyle get subjectName => _plusJakarta(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Chapter name: 14 w500
  static TextStyle get chapterName => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Progress percent: indigo w600
  static TextStyle get progressPercent => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w600,
    color: AppColors.indigo,
    height: 1.3,
  );
  
  // Nav label
  static TextStyle get navLabel => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.3,
  );
  
  // Onboarding headline: pink 34 w800
  static TextStyle get onboardingHeadline => _plusJakarta(
    fontSize: AppSpacing.headlineSize,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    height: 1.2,
  );
  
  // Onboarding subheadline: black 26 w700
  static TextStyle get onboardingSubheadline => _plusJakarta(
    fontSize: AppSpacing.subheadlineSize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  // Onboarding body: grey 16
  static TextStyle get onboardingBody => _plusJakarta(
    fontSize: AppSpacing.onboardingBodySize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // Donut center percent
  static TextStyle get donutPercent => _inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.0,
  );
  
  // Donut center label
  static TextStyle get donutLabel => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.3,
    letterSpacing: 1.0,
  );
  
  // Legend value
  static TextStyle get legendValue => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Legend label
  static TextStyle get legendLabel => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  // Button text
  static TextStyle get buttonText => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.3,
  );
  
  // Chip text
  static TextStyle get chipText => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  // Input text
  static TextStyle get inputText => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Input hint
  static TextStyle get inputHint => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );
  
  // Active badge
  static TextStyle get activeBadge => _plusJakarta(
    fontSize: AppSpacing.captionSize,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.3,
  );
  
  // Empty state title
  static TextStyle get emptyTitle => _plusJakarta(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
    height: 1.3,
  );
  
  // Empty state subtitle
  static TextStyle get emptySubtitle => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Link text
  static TextStyle get linkText => _plusJakarta(
    fontSize: AppSpacing.bodySize,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.3,
  );
}