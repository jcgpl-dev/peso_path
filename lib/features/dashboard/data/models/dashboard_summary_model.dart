import '../../domain/entities/dashboard_summary.dart';
import '../../../transactions/domain/entities/transaction.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.monthlyIncome,
    required super.monthlyExpense,
    required super.balance,
    required super.safeBudget,
    required super.recentTransactions,
  });

  factory DashboardSummaryModel.fromData({
    required double monthlyIncome,
    required double monthlyExpense,
    required double safeBudget,
    required List<Transaction> recentTransactions,
  }) {
    return DashboardSummaryModel(
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
      balance: monthlyIncome - monthlyExpense,
      safeBudget: safeBudget,
      recentTransactions: recentTransactions,
    );
  }
}
