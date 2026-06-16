import 'package:flutter/material.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class SafeBudgetCard extends StatelessWidget {
  const SafeBudgetCard({
    super.key,
    required this.safeBudget,
    required List<Transaction> transactions,
  });

  final double safeBudget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/card-bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Safe Budget",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            '₱${safeBudget.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: AppSpacing.sm),

          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg * 3),
            child: Text(
              'You can spend up to ₱${safeBudget.toStringAsFixed(2)} today and stay on track.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
