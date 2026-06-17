import 'package:flutter/material.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class SafeBudgetCard extends StatelessWidget {
  const SafeBudgetCard({
    super.key,
    required this.safeBudget,
    required this.endDate,
    required this.transactions,
  });

  final double safeBudget;
  final DateTime endDate;
  final List<Transaction> transactions;

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

  double _calculateTodaySpent() {
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    double total = 0.0;
    for (final tx in transactions) {
      if (tx.transactionDate.startsWith(todayStr)) {
        if (tx.type.toLowerCase() == 'expense' ||
            tx.type.toLowerCase() == 'debit' ||
            tx.amount < 0) {
          total += tx.amount.abs();
        }
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final todaySpent = _calculateTodaySpent();

    // Custom dynamic message strings based on actual daily consumption behavior
    final descriptionText = todaySpent > 0
        ? 'You\'ve spent ₱${todaySpent.toStringAsFixed(2)} today. You have ₱${safeBudget.toStringAsFixed(2)} remaining to stay on track until ${_formatDate(endDate)}.'
        : 'You haven\'t spent anything today! You have up to ₱${safeBudget.toStringAsFixed(2)} available to use and remain on track until ${_formatDate(endDate)}.';

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
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Text(
              descriptionText,
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
