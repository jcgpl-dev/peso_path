import '../../domain/entities/dashboard_summary.dart';
import '../../../transactions/domain/entities/transaction.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.budgetAmount,
    required super.totalSpent,
    required super.remainingBudget,
    required super.safeBudget,
    required super.recentTransactions,
    required super.endDate,
  });

  factory DashboardSummaryModel.fromData({
    required double budgetAmount,
    required double totalSpent,
    required double remainingBudget,
    required double safeBudget,
    required List<Transaction> recentTransactions,
    required DateTime endDate,
  }) {
    return DashboardSummaryModel(
      budgetAmount: budgetAmount,
      totalSpent: totalSpent,
      remainingBudget: remainingBudget,
      safeBudget: safeBudget,
      recentTransactions: recentTransactions,
      endDate: endDate,
    );
  }
}
