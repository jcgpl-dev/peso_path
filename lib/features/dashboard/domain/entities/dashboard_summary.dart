import '../../../transactions/domain/entities/transaction.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.balance,
    required this.safeBudget,
    required this.recentTransactions,
  });

  final double monthlyIncome;
  final double monthlyExpense;
  final double balance;
  final double safeBudget;
  final List<Transaction> recentTransactions;
}
