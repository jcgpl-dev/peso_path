import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_state.dart';
import '../widgets/transaction_summary_card.dart';

class TransactionsSummarySection extends StatelessWidget {
  const TransactionsSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) => current is TransactionLoaded,
      builder: (context, state) {
        if (state is! TransactionLoaded) {
          return const SizedBox.shrink();
        }

        double income = 0;

        double expense = 0;

        for (final transaction in state.transactions) {
          if (transaction.type == 'income') {
            income += transaction.amount;
          } else {
            expense += transaction.amount;
          }
        }

        return TransactionSummaryCard(income: income, expense: expense);
      },
    );
  }
}
