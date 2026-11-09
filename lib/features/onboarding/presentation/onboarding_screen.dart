import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep/core/constants/app_design.dart';
import 'package:exam_prep/core/constants/app_text_styles.dart';
import 'package:exam_prep/core/widgets/common_widgets.dart';
import 'package:exam_prep/features/exams/presentation/new_exam_sheet.dart';
import 'package:exam_prep/features/onboarding/providers/onboarding_providers.dart';
import 'package:exam_prep/core/extensions/extensions.dart';
import 'dart:math' as math;

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _bobController;
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      headline: 'Track Your Exams',
      subheadline: 'Stay Ahead, Always',
      body: 'Never miss a deadline again.',
      emojis: ['🎯', '📖', '📊'],
    ),
    OnboardingPageData(
      headline: 'Stay Focused',
      subheadline: 'One Block at a Time',
      body: 'Short breaks. Better focus. Big results.',
      emojis: ['⏱', '🧠', '🏆'],
    ),
    OnboardingPageData(
      headline: 'Track Your Progress',
      subheadline: 'See How Far You\'ve Come',
      body: 'Small steps today, big results tomorrow.',
      emojis: ['📈', '🎓', '📚'],
    ),
    OnboardingPageData(
      headline: 'Plan Your Exams',
      subheadline: 'Stay Organized, Stay Ahead',
      body: 'Everything you need to prepare with confidence.',
      emojis: ['📅', '✏️', '✨'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bobController = AnimationController(
      duration: AppDurations.bobAnimation,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.onboardingBackground,
        ),
        child: Stack(
          children: [
            // Floating emojis
            ..._buildFloatingEmojis(),
            // Page content
            SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text('Skip',
                              style: AppTextStyles.body
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  // Page view
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemBuilder: (context, index) =>
                          _buildPage(_pages[index]),
                    ),
                  ),
                  // Dots and next button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        // Get started / Next button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: _currentPage == _pages.length - 1
                                ? _completeOnboarding
                                : () => _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOutCubic,
                                    ),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.button),
                              ),
                            ),
                            child: Text(
                              _currentPage == _pages.length - 1
                                  ? 'Get started'
                                  : 'Next',
                              style: AppTextStyles.buttonText.copyWith(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingEmojis() {
    final allEmojis = ['🎯', '📖', '📊', '🏆', '🧠', '⏱', '🎓', '📚'];
    final random = List<int>.generate(8, (i) => i)..shuffle();

    return List.generate(8, (index) {
      final emoji = allEmojis[random[index]];
      final left = (index % 4) * 0.25 + 0.05;
      final top = (index / 4).floor() * 0.4 + 0.1;

      return AnimatedBuilder(
        animation: _bobController,
        builder: (context, child) {
          final offset =
              math.sin(_bobController.value * 2 * math.pi + index) * 15;
          return Positioned(
            left: MediaQuery.of(context).size.width * left,
            top: MediaQuery.of(context).size.height * top + offset,
            child:
                Text(emoji, style: TextStyle(fontSize: 40 + (index % 3) * 10)),
          );
        },
      );
    });
  }

  Widget _buildPage(OnboardingPageData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emojis for this page
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: page.emojis
                .map((e) => Text(e, style: TextStyle(fontSize: 60)))
                .toList(),
          ),
          const SizedBox(height: 48),
          Text(
            page.headline,
            style:
                AppTextStyles.onboardingHeadline.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            page.subheadline,
            style: AppTextStyles.onboardingSubheadline
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            style: AppTextStyles.onboardingBody
                .copyWith(color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    await ref.read(completeOnboardingProvider.future);
    if (mounted) {
      context.go('/home');
    }
  }
}

class OnboardingPageData {
  final String headline;
  final String subheadline;
  final String body;
  final List<String> emojis;

  OnboardingPageData({
    required this.headline,
    required this.subheadline,
    required this.body,
    required this.emojis,
  });
}
