import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_colors.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/empty_transactions.dart';
import '../widgets/transaction_tile.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key, required this.transactions});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final linkColor = isDarkMode ? AppColors.darkLink : AppColors.lightLink;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  context.go('/transactions');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: linkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          if (transactions.isEmpty)
            const EmptyTransactions(iconSize: 42)
          else
            Column(
              children: transactions
                  .take(5)
                  .map(
                    (transaction) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: TransactionTile(transaction: transaction),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
