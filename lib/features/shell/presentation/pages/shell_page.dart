import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'Transactions',
    ),
    (icon: Icons.savings_outlined, activeIcon: Icons.savings, label: 'Savings'),
    (
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  void _onFabPressed(BuildContext context) {
    // TODO: show add expense bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        elevation: 4,
        highlightElevation: 8,
        splashColor: Colors.white.withValues(alpha: 0.2),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: AppSpacing.sm,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._buildNavItems(context, [0, 1]),
            const SizedBox(width: AppSpacing.xl), // FAB gap
            ..._buildNavItems(context, [2, 3]),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context, List<int> indices) {
    final colorScheme = Theme.of(context).colorScheme;

    return indices.map((index) {
      final tab = _tabs[index];
      final isSelected = navigationShell.currentIndex == index;
      final color = isSelected
          ? colorScheme.primary
          : colorScheme.onSurfaceVariant;

      return Expanded(
        child: InkWell(
          onTap: () => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isSelected ? tab.activeIcon : tab.icon, color: color),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tab.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
