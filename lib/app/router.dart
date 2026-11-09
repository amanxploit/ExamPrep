import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/focus/presentation/focus_screen.dart';
import '../features/syllabus/presentation/syllabus_screen.dart';
import '../features/exams/presentation/exams_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../core/widgets/common_widgets.dart';
import '../core/constants/app_design.dart';
import '../core/constants/app_text_styles.dart';
import '../features/onboarding/providers/onboarding_providers.dart';

part 'router.g.dart';

enum AppTab { home, focus, syllabus, exams }

@riverpod
GoRouter router(RouterRef ref) {
  // Watch onboardingDone to make router reactive to changes
  final onboardingDone = ref.watch(onboardingDoneProvider);
  
  return GoRouter(
    initialLocation: onboardingDone ? '/home' : '/onboarding',
    redirect: (context, state) {
      // Use watch to make redirect reactive to onboardingDone changes
      final isOnboardingDone = ref.watch(onboardingDoneProvider);
      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      
      // If onboarding is done but user is on onboarding page, redirect to home
      if (isOnboardingDone && isOnboardingRoute) {
        return '/home';
      }
      // If onboarding not done but user tries to access main app, redirect to onboarding
      if (!isOnboardingDone && !isOnboardingRoute) {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/focus',
                builder: (context, state) => const FocusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/syllabus',
                builder: (context, state) => const SyllabusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/exams',
                builder: (context, state) => const ExamsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  
  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          Expanded(child: navigationShell),
          _CustomBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  
  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });
  
  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.timer_outlined, activeIcon: Icons.timer_rounded, label: 'Focus'),
    _NavItem(icon: Icons.layers_outlined, activeIcon: Icons.layers_rounded, label: 'Syllabus'),
    _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Exams'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.navBarMargin,
        0,
        AppSpacing.navBarMargin,
        AppSpacing.navBarMargin,
      ),
      child: Container(
        height: AppSpacing.navBarHeight,
        decoration: BoxDecoration(
          color: AppColors.navBar,
          borderRadius: BorderRadius.circular(AppRadius.navBar),
          boxShadow: [AppShadows.navBarShadow],
        ),
        child: Stack(
          children: [
            // Animated active indicator
            AnimatedAlign(
              alignment: Alignment(
                (currentIndex * 2.0 / (_items.length - 1)) - 1.0,
                0,
              ),
              duration: AppDurations.navAnimation,
              curve: AppEasing.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 1.0 / _items.length,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.navItem),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _items[currentIndex].activeIcon,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _items[currentIndex].label,
                          style: AppTextStyles.navLabel,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Touch targets - only show icons for inactive items
            Row(
              children: List.generate(_items.length, (index) {
                if (index == currentIndex) {
                  return Expanded(child: Container()); // Empty space for active item
                }
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(AppRadius.navItem),
                    child: Center(
                      child: Icon(
                        _items[index].icon,
                        color: Colors.white.withOpacity(0.85),
                        size: 26,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}