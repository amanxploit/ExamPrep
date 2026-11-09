import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_design.dart';
import '../constants/app_text_styles.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.scaffoldBackground,
        ),
        child: Stack(
          children: [
            const _SparklesBackground(),
            SafeArea(
              bottom: false,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklesBackground extends StatelessWidget {
  const _SparklesBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklesPainter(),
      size: Size.infinite,
    );
  }
}

class _SparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    final heartPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Draw scattered sparkles
    final sparklePositions = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width * 0.05, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.9),
      Offset(size.width * 0.8, size.height * 0.4),
    ];

    for (final pos in sparklePositions) {
      _drawSparkle(canvas, pos, paint);
    }

    // Draw hearts
    final heartPositions = [
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.65),
      Offset(size.width * 0.95, size.height * 0.2),
      Offset(size.width * 0.02, size.height * 0.8),
    ];

    for (final pos in heartPositions) {
      _drawHeart(canvas, pos, heartPaint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, Paint paint) {
    const size = 8.0;
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..lineTo(center.dx + size * 0.3, center.dy - size * 0.3)
      ..lineTo(center.dx + size, center.dy)
      ..lineTo(center.dx + size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx, center.dy + size)
      ..lineTo(center.dx - size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx - size, center.dy)
      ..lineTo(center.dx - size * 0.3, center.dy - size * 0.3)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, Paint paint) {
    const size = 12.0;
    final path = Path()
      ..moveTo(center.dx, center.dy + size * 0.3)
      ..cubicTo(
        center.dx - size,
        center.dy - size * 0.3,
        center.dx - size * 1.5,
        center.dy - size * 0.8,
        center.dx,
        center.dy + size * 0.5,
      )
      ..cubicTo(
        center.dx + size * 1.5,
        center.dy - size * 0.8,
        center.dx + size,
        center.dy - size * 0.3,
        center.dx,
        center.dy + size * 0.3,
      )
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? radius;
  final List<BoxShadow>? shadows;
  final Color? color;

  const SoftCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.radius,
    this.shadows,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius ?? AppRadius.card),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
        boxShadow: shadows ?? [AppShadows.cardShadow],
      ),
      child: child,
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color softColor;
  final double? size;
  final double? iconSize;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    required this.softColor,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? AppSpacing.iconBadgeSize,
      height: size ?? AppSpacing.iconBadgeSize,
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize ?? AppSpacing.iconBadgeIconSize,
      ),
    );
  }
}

class PillProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  final Color? trackColor;
  final Duration? animationDuration;

  const PillProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = AppSpacing.progressBarHeight,
    this.trackColor,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: animationDuration ?? const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor ?? AppColors.track,
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedValue,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ExamSelectorChip extends StatelessWidget {
  final String examName;
  final Color dotColor;
  final VoidCallback onTap;
  final bool showChevron;

  const ExamSelectorChip({
    super.key,
    required this.examName,
    required this.dotColor,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.chip),
      child: AnimatedScale(
        scale: 1.0,
        duration: AppDurations.pressScale,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.chipPadding,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            boxShadow: [AppShadows.smallShadow],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                examName,
                style: AppTextStyles.chipText,
              ),
              if (showChevron) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;
  final double? iconSize;

  const SquareIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.smallIconButton),
      child: AnimatedScale(
        scale: 1.0,
        duration: AppDurations.pressScale,
        child: Container(
          width: size ?? AppSpacing.squareButtonSize,
          height: size ?? AppSpacing.squareButtonSize,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.smallIconButton),
            boxShadow: [AppShadows.smallShadow],
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize ?? 22,
          ),
        ),
      ),
    );
  }
}

class GradientPlusButton extends StatelessWidget {
  final VoidCallback onTap;
  final double? size;
  final IconData? icon;

  const GradientPlusButton({
    super.key,
    required this.onTap,
    this.size,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedScale(
        scale: 1.0,
        duration: AppDurations.pressScale,
        child: Container(
          width: size ?? AppSpacing.plusButtonSize,
          height: size ?? AppSpacing.plusButtonSize,
          decoration: BoxDecoration(
            gradient: AppGradients.gradientCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [AppShadows.buttonShadow],
          ),
          child: Center(
            child: Icon(
              icon ?? Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color softColor;
  final double? iconSize;

  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.softColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconBadge(
          icon: icon,
          color: iconColor,
          softColor: softColor,
          iconSize: iconSize,
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.statNumber,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color trackColor;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.value,
    this.size = AppSpacing.donutSize,
    this.strokeWidth = AppSpacing.donutStroke,
    required this.color,
    required this.trackColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          value: value.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
          color: color,
          trackColor: trackColor,
        ),
        child: child != null ? Center(child: child) : null,
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  _ProgressRingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw track
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _ProgressRingPainter &&
        oldDelegate.value != value &&
        oldDelegate.color != color;
  }
}

class PrimaryPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final Color? color;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSecondary ? Colors.white : (color ?? AppColors.primary);
    final foregroundColor =
        isSecondary ? (color ?? AppColors.primary) : Colors.white;
    final borderColor =
        isSecondary ? (color ?? AppColors.primary) : Colors.transparent;

    return AnimatedScale(
      scale: 1.0,
      duration: AppDurations.pressScale,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          width: width,
          height: 52,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: isSecondary ? [] : [AppShadows.buttonShadow],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: foregroundColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class OutlinedPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final Color? color;
  final Color? textColor;

  const OutlinedPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = color ?? AppColors.primary;
    final foregroundColor = textColor ?? (color ?? AppColors.primary);

    return AnimatedScale(
      scale: 1.0,
      duration: AppDurations.pressScale,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Container(
          width: width,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: foregroundColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SegmentedControl<T> extends StatelessWidget {
  final List<T> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? trackColor;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.labelBuilder,
    this.selectedColor,
    this.unselectedColor,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: trackColor ?? AppColors.segmentedTrack,
        borderRadius: BorderRadius.circular(AppRadius.segmented),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(
              (options.indexOf(selectedValue) * 2.0 / (options.length - 1)) -
                  1.0,
              0,
            ),
            duration: AppDurations.navAnimation,
            curve: AppEasing.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 1.0 / options.length,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.segmented),
                  boxShadow: [AppShadows.smallShadow],
                ),
              ),
            ),
          ),
          Row(
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(option),
                  borderRadius: BorderRadius.circular(AppRadius.segmented),
                  child: Center(
                    child: Text(
                      labelBuilder(option),
                      style: AppTextStyles.body.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? illustration;
  final Widget? action;
  final Color? iconColor;
  final Color? backgroundColor;

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.illustration,
    this.action,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: backgroundColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBadge(
            icon: icon,
            color: iconColor ?? AppColors.success,
            softColor: (iconColor ?? AppColors.success).withOpacity(0.15),
            size: 56,
            iconSize: 28,
          ),
          const SizedBox(height: 16),
          Text(title,
              style: AppTextStyles.emptyTitle, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle,
              style: AppTextStyles.emptySubtitle, textAlign: TextAlign.center),
          if (illustration != null) ...[
            const SizedBox(height: 16),
            illustration!,
          ],
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}
