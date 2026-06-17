import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_bloc.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_event.dart';
import 'package:peso_path/features/transactions/presentation/sections/transactions_body_section.dart';
import 'package:peso_path/features/transactions/presentation/sections/transactions_header_section.dart';

import '../../../../shared/widgets/app_snackbar.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _allFilterCategories = [
    'All',
    'Food',
    'Transportation',
    'Bills',
    'Shopping',
    'Savings',
    'Salary',
    'Freelance',
    'Investments',
    'Allowance',
    'Others',
  ];

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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Transactions',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionDeleted) {
              context.read<SavingsBloc>().add(LoadSavingsGoals());
              AppSnackbar.showSuccess(
                context,
                'Transaction deleted and goal adjusted',
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
              final filteredTransactions = state.transactions.where((tx) {
                final matchesSearch =
                    tx.title.toLowerCase().contains(_searchQuery) ||
                    (tx.note?.toLowerCase().contains(_searchQuery) ?? false);

                final matchesCategory =
                    _selectedCategory == 'All' ||
                    tx.category.toLowerCase() ==
                        _selectedCategory.toLowerCase();

                return matchesSearch && matchesCategory;
              }).toList();

              return Column(
                children: [
                  TransactionsHeaderSection(
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    categories: _allFilterCategories,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value.trim().toLowerCase());
                    },
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  Expanded(
                    child: TransactionsBodySection(
                      filteredTransactions: filteredTransactions,
                      onRefresh: _refresh,
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
