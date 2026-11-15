import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppNavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AppNavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// AppBottomNavigation provides a sleek, modern Material 3 bottom navigation
/// bar with subtle glass shadow and responsive item indicators.
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final List<AppNavigationItem> items;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onItemSelected,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.electricBlue.withOpacity(
            isDark ? 0.22 : 0.12,
          ),
          destinations: items.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(
                item.selectedIcon,
                color: AppColors.electricBlue,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
