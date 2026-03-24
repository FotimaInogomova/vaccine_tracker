import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/schedule_utils.dart';
import 'children_list_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'today_screen.dart';
import 'vaccines_info_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;
  int _todayCount = 0;

  final _screens = const [
    ChildrenListScreen(),
    TodayScreen(),
    StatisticsScreen(),
    VaccinesInfoScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadTodayCount();
  }

  Future<void> _loadTodayCount() async {
    final parent = await AuthService.instance.getCurrentParent();
    if (parent == null) return;

    final parentId = parent['id'] as int;
    final children = await DatabaseHelper.instance.getChildrenByParent(parentId);
    final vaccines = await DatabaseHelper.instance.getVaccines();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int count = 0;
    for (final child in children) {
      final childId = child.id;
      if (childId == null) continue;

      final doneIds = await DatabaseHelper.instance.getDoneVaccineIds(childId);
      final recommendedDates = await calculateRecommendedDatesForChild(
        child: child,
        vaccines: vaccines,
      );
      for (final vaccine in vaccines) {
        if (doneIds.contains(vaccine.id)) continue;
        if (vaccine.type == 'recommended' && !child.showRecommended) continue;
        if (vaccine.type == 'optional' && !child.showOptional) continue;

        final recommendedDate = recommendedDates[vaccine.id] ??
            calculateBaseRecommendedDate(
              child.birthDate,
              vaccine.ageInMonths,
            );
        final due = DateTime(
          recommendedDate.year,
          recommendedDate.month,
          recommendedDate.day,
        );

        if (due == today) {
          count++;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _todayCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _screens[_index],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) {
            setState(() {
              _index = value;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.child_care_outlined),
              selectedIcon: const Icon(Icons.child_care),
              label: loc.children,
            ),
            NavigationDestination(
              icon: badges.Badge(
                showBadge: _todayCount > 0,
                badgeContent: Text(
                  _todayCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                child: const Icon(Icons.today_outlined),
              ),
              selectedIcon: badges.Badge(
                showBadge: _todayCount > 0,
                badgeContent: Text(
                  _todayCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                child: const Icon(Icons.today),
              ),
              label: loc.today,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: loc.statistics,
            ),
            NavigationDestination(
              icon: const Icon(Icons.info_outline),
              selectedIcon: const Icon(Icons.info),
              label: loc.info,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: loc.settings,
            ),
          ],
        ),
      ),
    );
  }
}
