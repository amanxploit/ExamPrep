import 'package:flutter/material.dart';

class AppColors {
  // Primary pink palette
  static const primary = Color(0xFFE9547B);
  static const primaryDark = Color(0xFFD63F68);
  static const primaryLight = Color(0xFFF7A8BC);
  static const primarySoft = Color(0xFFFDE7ED);
  
  // Gradient
  static const gradientCardStart = Color(0xFFF07A98);
  static const gradientCardEnd = Color(0xFFE04A72);
  
  // Background
  static const bgTop = Color(0xFFFCE4EC);
  static const bgBottom = Color(0xFFFFF7F9);
  
  // Surface
  static const surface = Color(0xEBFFFFFF); // 92% opacity white
  
  // Semantic colors
  static const success = Color(0xFF34B98A);
  static const successSoft = Color(0xFFE3F6EE);
  static const successDark = Color(0xFF1E9E70);
  
  static const warning = Color(0xFFF59E0B);
  static const warningSoft = Color(0xFFFFF4E6);
  static const warningDark = Color(0xFFD97706);
  
  static const error = Color(0xFFEF4444);
  static const errorSoft = Color(0xFFFEF2F2);
  static const errorDark = Color(0xFFDC2626);
  
  static const indigo = Color(0xFF2E3192);
  static const indigoSoft = Color(0xFFECEBFB);
  
  static const blue = Color(0xFF3D7BF5);
  static const blueSoft = Color(0xFFE6EEFE);
  
  static const orange = Color(0xFFF57C3A);
  static const orangeSoft = Color(0xFFFFF0E6);
  
  static const purple = Color(0xFF8B6CF0);
  static const purpleSoft = Color(0xFFF1ECFE);
  
  static const secondary = Color(0xFF6366F1);
  static const secondarySoft = Color(0xFFEEF2FF);
  
  static const border = Color(0xFFE5E5E5);
  
  // Text
  static const textPrimary = Color(0xFF16161A);
  static const textSecondary = Color(0xFF6B6B76);
  static const textMuted = Color(0xFFA0A0AA);
  
  // Progress track
  static const track = Color(0xFFF1E6EA);
  
  // Navigation
  static const navBar = Color(0xFF1C1C22);
  
  // Segmented control track
  static const segmentedTrack = Color(0xFFF1ECEE);
  
  // Input fill
  static const inputFill = Color(0xFFF7F7F9);
  static const inputBorder = Color(0xFFEEEEEE);
  
  // White with opacity
  static const white85 = Color(0xD9FFFFFF); // 85%
  static const white70 = Color(0xB3FFFFFF); // 70%
  static const white30 = Color(0x4DFFFFFF); // 30%
  
  // Pink glow
  static const pinkGlow = Color(0x59E9547B); // 35%
  static const pinkShadow = Color(0x14E9547B); // 8%
  
  // Onboarding background
  static const onboardingStart = Color(0xFFF07A98);
  static const onboardingEnd = Color(0xFFE04A72);
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
  
  static const pinkGlow = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [Color(0x59E9547B), Colors.transparent],
  );
}

class AppShadows {
  static const cardShadow = BoxShadow(
    color: AppColors.pinkShadow,
    blurRadius: 24,
    offset: Offset(0, 8),
  );
  
  static const pinkGlowShadow = BoxShadow(
    color: AppColors.pinkGlow,
    blurRadius: 20,
    offset: Offset(0, 10),
  );
  
  static const navBarShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 20,
    offset: Offset(0, -4),
  );
  
  static const buttonShadow = BoxShadow(
    color: AppColors.pinkGlow,
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