import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class TransactionSummaryCard extends StatelessWidget {
  const TransactionSummaryCard({
    super.key,
    required this.income,
    required this.expense,
  });

  final double income;

  final double expense;

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(title: 'Income', amount: income, color: Colors.green),
            _SummaryItem(title: 'Expense', amount: expense, color: Colors.red),
            _SummaryItem(
              title: 'Balance',
              amount: balance,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  final String title;

  final double amount;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '₱${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
