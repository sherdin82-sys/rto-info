import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/localization/app_locale.dart';
import 'app_bottom_navigation.dart';

/// AppScaffoldWithNavBar provides bottom navigation bar shell for GoRouter.
class AppScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldWithNavBar({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isHindi = locale.languageCode == 'hi';

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onItemSelected: _onDestinationSelected,
        items: [
          AppNavigationItem(
            icon: Icons.directions_car_outlined,
            selectedIcon: Icons.directions_car,
            label: isHindi ? 'होम' : 'Home',
          ),
          AppNavigationItem(
            icon: Icons.history_outlined,
            selectedIcon: Icons.history,
            label: isHindi ? 'इतिहास' : 'History',
          ),
          AppNavigationItem(
            icon: Icons.bookmark_outline,
            selectedIcon: Icons.bookmark,
            label: isHindi ? 'पसंदीदा' : 'Favourites',
          ),
          AppNavigationItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            label: isHindi ? 'सेटिंग्स' : 'Settings',
          ),
        ],
      ),
    );
  }
}
