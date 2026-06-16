import 'package:flutter/material.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class MonthlyOverviewCard extends StatelessWidget {
  const MonthlyOverviewCard({
    super.key,
    required this.income,
    required this.expense,
    required List<Transaction> transactions,
  });

  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _Item(
                  title: 'Income',
                  value: income,
                  color: AppColors.income,
                ),
              ),

              Expanded(
                child: _Item(
                  title: 'Expenses',
                  value: expense,
                  color: AppColors.expense,
                ),
              ),

              Expanded(
                child: _Item(
                  title: 'Balance',
                  value: balance,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, required this.value, required this.color});

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),

        const SizedBox(height: 8),

        Text(
          '₱${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
