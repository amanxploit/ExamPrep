import 'package:flutter/material.dart';

class AppColors {
  // Primary green/teal palette
  static const primary = Color(0xFF00A885); // Teal primary
  static const primaryDark = Color(0xFF00876A);
  static const primaryLight = Color(0xFF4DD4B8);
  static const primarySoft = Color(0xFFE8F8F4);

  // Gradient
  static const gradientCardStart = Color(0xFF00B894);
  static const gradientCardEnd = Color(0xFF00A885);

  // Background - neutral light
  static const bgTop = Color(0xFFF5F9F8);
  static const bgBottom = Color(0xFFFFFFFF);

  // Surface
  static const surface = Color(0xFFFFFFFF);

  // Semantic colors
  static const success = Color(0xFF10B981); // Emerald
  static const successSoft = Color(0xFFECFDF5);
  static const successDark = Color(0xFF059669);

  static const warning = Color(0xFFF59E0B); // Amber
  static const warningSoft = Color(0xFFFFF4E6);
  static const warningDark = Color(0xFFD97706);

  static const error = Color(0xFFEF4444); // Red
  static const errorSoft = Color(0xFFFEF2F2);
  static const errorDark = Color(0xFFDC2626);

  static const indigo = Color(0xFF4F46E5);
  static const indigoSoft = Color(0xFFEEF2FF);

  static const blue = Color(0xFF3B82F6);
  static const blueSoft = Color(0xFFEFF6FF);

  static const orange = Color(0xFFF97316);
  static const orangeSoft = Color(0xFFFFF0E6);

  static const purple = Color(0xFF8B5CF6);
  static const purpleSoft = Color(0xFFF5F3FF);

  static const secondary = Color(0xFF6366F1);
  static const secondarySoft = Color(0xFFEEF2FF);

  static const border = Color(0xFFE5E7EB);

  // Text
  static const textPrimary = Color(0xFF111827); // Gray-900
  static const textSecondary = Color(0xFF6B7280); // Gray-500
  static const textMuted = Color(0xFF9CA3AF); // Gray-400

  // Progress track
  static const track = Color(0xFFE5E7EB); // Gray-200

  // Navigation
  static const navBar = Color(0xFF111827); // Gray-900

  // Segmented control track
  static const segmentedTrack = Color(0xFFF3F4F6); // Gray-100

  // Input fill
  static const inputFill = Color(0xFFF9FAFB); // Gray-50
  static const inputBorder = Color(0xFFE5E7EB); // Gray-200

  // White with opacity
  static const white85 = Color(0xD9FFFFFF); // 85%
  static const white70 = Color(0xB3FFFFFF); // 70%
  static const white30 = Color(0x4DFFFFFF); // 30%

  // Teal glow
  static const tealGlow = Color(0x5900A885); // 35%
  static const tealShadow = Color(0x1400A885); // 8%

  // Onboarding background
  static const onboardingStart = Color(0xFF00B894);
  static const onboardingEnd = Color(0xFF00A885);
}

class AppGradients {
  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientCardStart, AppColors.gradientCardEnd],
  );

  static const scaffoldBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.bgTop, AppColors.bgBottom],
  );

  static const onboardingBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.onboardingStart, AppColors.onboardingEnd],
  );

  static const tealGlow = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [AppColors.tealGlow, Colors.transparent],
  );
}

class AppShadows {
  static const cardShadow = BoxShadow(
    color: AppColors.tealShadow,
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const tealGlowShadow = BoxShadow(
    color: AppColors.tealGlow,
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  static const navBarShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 20,
    offset: Offset(0, -4),
  );

  static const buttonShadow = BoxShadow(
    color: AppColors.tealGlow,
    blurRadius: 16,
    offset: Offset(0, 6),
  );

  static const smallShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 8,
    offset: Offset(0, 2),
  );
}

class AppRadius {
  static const card = 20.0;
  static const chip = 999.0;
  static const button = 999.0;
  static const smallIconButton = 14.0;
  static const countdownCard = 24.0;
  static const sheetTop = 28.0;
  static const createButton = 18.0;
  static const segmented = 16.0;
  static const input = 16.0;
  static const progressBar = 3.0;
  static const daysBox = 16.0;
  static const subjectCard = 20.0;
  static const chapterRow = 12.0;
  static const statCard = 20.0;
  static const focusCard = 20.0;
  static const timerRing = 130.0;
  static const playButton = 44.0;
  static const navBar = 32.0;
  static const navItem = 999.0;
  static const sm = 8.0;
  static const pill = 999.0;
}

class AppSpacing {
  static const screenHorizontal = 20.0;
  static const sectionVertical = 16.0;
  static const sectionVerticalLarge = 20.0;
  static const cardPadding = 20.0;
  static const chipPadding = 12.0;
  static const iconBadgeSize = 40.0;
  static const iconBadgeIconSize = 20.0;
  static const squareButtonSize = 44.0;
  static const plusButtonSize = 52.0;
  static const playButtonSize = 88.0;
  static const timerRingSize = 260.0;
  static const timerRingStroke = 8.0;
  static const progressBarHeight = 6.0;
  static const statNumberSize = 24.0;
  static const hugeNumberSize = 84.0;
  static const timerNumberSize = 64.0;
  static const screenTitleSize = 28.0;
  static const overlineSize = 14.0;
  static const cardTitleSize = 17.0;
  static const bodySize = 14.0;
  static const captionSize = 12.0;
  static const labelSize = 13.0;
  static const examNameSize = 15.0;
  static const dateSize = 14.0;
  static const sectionTitleSize = 18.0;
  static const sheetTitleSize = 22.0;
  static const fieldLabelSize = 12.0;
  static const helperTextSize = 13.0;
  static const headlineSize = 34.0;
  static const subheadlineSize = 26.0;
  static const onboardingBodySize = 16.0;
  static const donutSize = 120.0;
  static const donutStroke = 12.0;
  static const barWidth = 24.0;
  static const navBarHeight = 64.0;
  static const navBarMargin = 16.0;
  static const bottomPadding = 100.0;
}

class AppDurations {
  static const pressScale = Duration(milliseconds: 100);
  static const navAnimation = Duration(milliseconds: 250);
  static const chartAnimation = Duration(milliseconds: 600);
  static const countUpAnimation = Duration(milliseconds: 900);
  static const sheetAnimation = Duration(milliseconds: 300);
  static const bobAnimation = Duration(seconds: 3);
}

class AppEasing {
  static const easeOutCubic = Cubic(0.33, 0.66, 0.66, 1.0);
  static const standard = Curves.easeInOutCubic;
}
