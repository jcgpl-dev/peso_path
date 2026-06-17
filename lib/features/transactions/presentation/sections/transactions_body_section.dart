import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../widgets/empty_transactions.dart';
import '../widgets/transaction_card.dart';

class TransactionsBodySection extends StatelessWidget {
  const TransactionsBodySection({
    super.key,
    required this.filteredTransactions,
    required this.onRefresh,
  });

  final List<Transaction> filteredTransactions;
  final RefreshCallback onRefresh;

  Map<String, List<Transaction>> _groupTransactionsByTimeline(
    List<Transaction> transactions,
  ) {
    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final sevenDaysAgo = todayStart.subtract(const Duration(days: 7));
    final thirtyDaysAgo = todayStart.subtract(const Duration(days: 30));

    grouped['Today'] = [];
    grouped['Yesterday'] = [];
    grouped['This Week'] = [];
    grouped['This Month'] = [];
    grouped['Older'] = [];

    for (final tx in transactions) {
      final txDate = DateTime.tryParse(tx.transactionDate);
      if (txDate == null) continue;

      if (txDate.isAfter(todayStart) || txDate.isAtSameMomentAs(todayStart)) {
        grouped['Today']!.add(tx);
      } else if (txDate.isAfter(yesterdayStart) ||
          txDate.isAtSameMomentAs(yesterdayStart)) {
        grouped['Yesterday']!.add(tx);
      } else if (txDate.isAfter(sevenDaysAgo)) {
        grouped['This Week']!.add(tx);
      } else if (txDate.isAfter(thirtyDaysAgo)) {
        grouped['This Month']!.add(tx);
      } else {
        grouped['Older']!.add(tx);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (filteredTransactions.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: EmptyTransactions()),
          ],
        ),
      );
    }

    final groupedMap = _groupTransactionsByTimeline(filteredTransactions);
    final sectionHeaders = groupedMap.keys.toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: sectionHeaders.length,
        itemBuilder: (context, sectionIndex) {
          final headerTitle = sectionHeaders[sectionIndex];
          final sectionItems = groupedMap[headerTitle]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Heading (e.g., Today, Yesterday)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  headerTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              // Sub-list for transactions in this timeframe
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sectionItems.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final transaction = sectionItems[index];

                  return Dismissible(
                    key: ValueKey(transaction.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete Transaction'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${transaction.title}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ) ??
                          false;
                    },
                    onDismissed: (direction) {
                      context.read<TransactionBloc>().add(
                        DeleteTransactionRequested(transaction.id),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    child: TransactionCard(
                      transaction: transaction,
                      onTap: () {
                        context.push(
                          '/edit-transaction',
                          extra: {
                            'bloc': context.read<TransactionBloc>(),
                            'transaction': transaction,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }
}
