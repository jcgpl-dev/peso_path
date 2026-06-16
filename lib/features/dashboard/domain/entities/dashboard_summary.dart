import 'package:peso_path/features/transactions/domain/entities/transaction.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.budgetAmount,
    required this.totalSpent,
    required this.remainingBudget,
    required this.safeBudget,
    required this.recentTransactions,
  });

  final double budgetAmount;

  final double totalSpent;

  final double remainingBudget;

  final double safeBudget;

  final List<Transaction> recentTransactions;
}
