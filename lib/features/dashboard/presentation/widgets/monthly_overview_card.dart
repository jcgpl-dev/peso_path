import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class MonthlyOverviewCard extends StatelessWidget {
  const MonthlyOverviewCard({
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Budget Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/budget-setup');
                },
                child: Builder(
                  builder: (context) {
                    final isDarkMode =
                        Theme.of(context).brightness == Brightness.dark;

                    return Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode
                            ? AppColors.darkLink
                            : AppColors.lightLink,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _Item(
                  title: 'Budget',
                  value: budgetAmount,
                  color: AppColors.primary,
                ),
              ),

              Expanded(
                child: _Item(
                  title: 'Spent',
                  value: totalSpent,
                  color: AppColors.expense,
                ),
              ),

              Expanded(
                child: _Item(
                  title: 'Remaining',
                  value: remainingBudget,
                  color: AppColors.income,
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
