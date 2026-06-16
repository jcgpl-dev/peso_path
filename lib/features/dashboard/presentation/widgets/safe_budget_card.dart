import 'package:flutter/material.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class SafeBudgetCard extends StatelessWidget {
  const SafeBudgetCard({
    super.key,
    required this.safeBudget,
    required this.endDate,
    required List<Transaction> transactions,
  });

  final double safeBudget;
  final DateTime endDate;

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

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
            padding: const EdgeInsets.only(right: AppSpacing.lg * 2),
            child: Text(
              'You can spend up to ₱${safeBudget.toStringAsFixed(2)} today and stay on track until ${_formatDate(endDate)}.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(220),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
