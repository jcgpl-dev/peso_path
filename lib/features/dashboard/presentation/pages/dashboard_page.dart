import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_state.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_state.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_state.dart';

import '../../../../core/theme/app_spacing.dart';

import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

import '../widgets/dashboard_header.dart';
import '../widgets/monthly_overview_card.dart';
import '../widgets/safe_budget_card.dart';

import '../sections/recent_transactions_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    context.read<DashboardBloc>().add(LoadDashboardSummary());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionAdded ||
                state is TransactionUpdated ||
                state is TransactionDeleted) {
              context.read<DashboardBloc>().add(LoadDashboardSummary());
            }
          },
        ),
        BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetCreated || state is BudgetUpdated) {
              context.read<DashboardBloc>().add(LoadDashboardSummary());
            }
          },
        ),
      ],
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(child: Text(state.message));
          }

          if (state is DashboardLoaded) {
            final summary = state.summary;

            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(LoadDashboardSummary());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          String displayName = "User";

                          if (authState is AuthAuthenticated) {
                            displayName = authState.name;
                          }

                          return DashboardHeader(userFullname: displayName);
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      SafeBudgetCard(
                        safeBudget: summary.safeBudget,
                        transactions: summary.recentTransactions,
                        endDate: summary.endDate, //todo
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      MonthlyOverviewCard(
                        budgetAmount: summary.budgetAmount,
                        totalSpent: summary.totalSpent,
                        remainingBudget: summary.remainingBudget,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RecentTransactionsSection(
                        transactions: summary.recentTransactions,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
