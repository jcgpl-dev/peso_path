import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class BudgetCycleCard extends StatelessWidget {
  const BudgetCycleCard({
    super.key,
    required this.budgetAmount,
    required this.totalSpent,
    required this.remainingBudget,
  });

  final double budgetAmount;
  final double totalSpent;
  final double remainingBudget;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Budget Cycle',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.lg),

          _RowItem(title: 'Budget', value: budgetAmount),

          const SizedBox(height: 8),

          _RowItem(title: 'Spent', value: totalSpent),

          const SizedBox(height: 8),

          _RowItem(title: 'Remaining', value: remainingBudget),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push('/budget-setup');
              },
              child: const Text('Manage Budget'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.title, required this.value});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),

        const Spacer(),

        Text(
          '₱${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
