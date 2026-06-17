import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_radius.dart';
import 'package:peso_path/features/transactions/presentation/widgets/empty_transactions.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_snackbar.dart';

import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

import '../widgets/transaction_card.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  Future<void> _refresh() async {
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionDeleted) {
              AppSnackbar.showSuccess(
                context,
                'Transaction deleted successfully',
              );
            }

            if (state is TransactionFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },

          buildWhen: (previous, current) =>
              current is! TransactionLoading || previous is TransactionInitial,
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransactionLoaded) {
              if (state.transactions.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    children: const [
                      SizedBox(height: 200),
                      Center(child: EmptyTransactions()),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.separated(
                  itemCount: state.transactions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];

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
                                      style: TextStyle(
                                        color: colorScheme.error,
                                      ),
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
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
