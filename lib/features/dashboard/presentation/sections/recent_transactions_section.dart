import 'package:flutter/material.dart';

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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge,
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
