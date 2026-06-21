import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_bloc.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_event.dart';

import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:peso_path/features/transactions/presentation/pages/add_transaction_page.dart';

import 'package:peso_path/injection/injection.dart';

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
    final currentIndex = navigationShell.currentIndex;

    if (currentIndex == 2) {
      context.push('/add-savings-goal', extra: context.read<SavingsBloc>());
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<TransactionBloc>(),
            child: const AddTransactionPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<TransactionBloc>()..add(LoadTransactions()),
        ),
        BlocProvider(create: (_) => sl<SavingsBloc>()..add(LoadSavingsGoals())),
      ],
      child: Builder(
        builder: (context) {
          final int currentIndex = navigationShell.currentIndex;
          // Hide the FAB completely if we are viewing the Settings tab (index 3)
          final bool showFab = currentIndex != 3;

          return Scaffold(
            body: navigationShell,
            floatingActionButton: showFab
                ? FloatingActionButton(
                    onPressed: () => _onFabPressed(context),
                    elevation: 0,
                    shape: const CircleBorder(),
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    child: Icon(
                      currentIndex == 2 ? Icons.savings : Icons.add,
                      size: 28,
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              clipBehavior: Clip.antiAlias,
              // Smooth transition: remove the notch cutout when FAB is absent
              shape: showFab ? const CircularNotchedRectangle() : null,
              notchMargin: AppSpacing.sm,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ..._buildNavItems(context, [0, 1]),
                  // Collapse the center gap spacing if the FAB is hidden
                  if (showFab) const SizedBox(width: AppSpacing.xl),
                  ..._buildNavItems(context, [2, 3]),
                ],
              ),
            ),
          );
        },
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
